" Use for: linting, makeing, testing, formatting, finding stuff

" Always show signs column
sign define MyQuickfixSignEmpty
augroup MyQuickfixAugroupPersistentSignsColumn
  autocmd!
  autocmd BufEnter * call MyQuickfixShowSignsColumn()
  autocmd FileType qf call MyQuickfixShowSignsColumn()
augroup END

function! MyQuickfixShowSignsColumn() abort
  execute 'execute ":sign place 9999 line=1
        \ name=MyQuickfixSignEmpty buffer=".bufnr("")'
endfunction

nnoremap <silent> <tab> :copen<cr>
nnoremap <silent> <s-tab> :lopen<cr>

function! MyQuickfixBufferDir() abort
  return expand("%:p:h")
endfunction

" NOTE: to ignore files not in .gitignore use a .agignore file
let g:MyQuickfixIgnoreFile = g:vim.contrib.etc.dir . 'ignore-files'
let g:MyQuickfixGrepCommand = 'grep -inHR --exclude-from ' .
      \  g:MyQuickfixIgnoreFile
if executable('ag')
  let g:MyQuickfixGrepCommand = 'ag -f --nogroup --nocolor --column '
        \ . ' --ignore-case --all-text'

  " TODO: add --smart-case option?
  " TODO: --word-regexp:
  " TODO: checkout --vimgrep
endif

let g:MyQuickfixSearchLimit = '500'

command! -bang -nargs=1 Search call MyQuickfixSearch({'term': <q-args>})
function! MyQuickfixSearch(options) abort

  let options = {}
  call extend(options, a:options)

  let functionRef = get(a:options, 'function', '')
  echo functionRef
  if functionRef != ''
    call extend(options, {functionRef}())
  endif

  let l:save_pos = getcurpos()
  let term = get(options, 'term', '')
  let find = get(options, 'find', '1')
  let grep = get(options, 'grep', '1')
  let matchFilenameOnly = get(options, 'matchFilenameOnly', '1')
  let orderBy = get(options, 'orderBy', '')
  let useIgnoreFile = get(options, 'useIgnoreFile', 1)
  let fuzzy = get(options, 'fuzzy', '0')
  let ask = get(options, 'ask', '0')
  let selection = get(options, 'selection', '0')
  let wordBoundary = get(options, 'wordBoundary', '0')
  let title = get(options, 'title', '')
  let strict = 0
  let path = get(options, 'path', '')

  if selection
    let term = substitute(MyHelpersGetVisualSelection(), '\v[\r\n\s]*$', '', 'g') 
    let strict = 1
  elseif ask
    let term = input('Search: ')
  endif

  if exists('options["expand"]')
    let term = expand(options['expand'])
    let strict = 1
  endif

  " apparently you can not work-bind non-word characters
  let isWordBoundable = 0
  if term =~ '\v^\w' && term =~ '\v\w$' 
    let isWordBoundable = 1
  endif

  " fuzzy search for most case variants and plurals
  if fuzzy
    let words = split(term, ' +')
    let variants = []
    for word in words
      call add(variants, word)
      call add(variants, substitute(word, 's$', '', 'gi'))
      call add(variants, substitute(word, '$', 's', 'gi'))
      call add(variants, substitute(word, 'y$', 'ies', 'gi'))
      call add(variants, substitute(word, 'ies$', 'y', 'gi'))
    endfor
    let words = copy(variants)
    for word in words
      call add(variants, substitute(word, '\(\<\u\l\+\|\l\+\)\(\u\)', '\l\1.{0,1}\l\2', 'g'))
    endfor
    let words = copy(variants)
    let variants = []
    for word in words
      call add(variants, substitute(word, '\v[-_]+', '.{0,1}', 'g'))
    endfor
    let term = '(' . join(uniq(sort(variants)), '|') . ')+'
  endif

  if strict && ! fuzzy
    let term = '\Q' . term . '\E'
  endif

  if wordBoundary && isWordBoundable
    let term = '\b' . term . '\b'
  endif

  let project_dir = FindRootDirectory()
  if project_dir == ''
    let project_dir = MyQuickfixBufferDir()
  endif
  if path == ''
    let path = project_dir
  endif
  let path = fnamemodify(path, ':p')

  let filenameTerm = term
  if matchFilenameOnly
    let filenameTerm = '\/.*' . term . '[^/]*$'
  else
    " exclude current path from file match
    let filenameTerm = '\Q' . fnameescape(path) . '\E' . '.*' . filenameTerm
  endif

  let grepprg = g:MyQuickfixGrepCommand

  if useIgnoreFile
    let grepprg .= ' -p ' . g:MyQuickfixIgnoreFile
  endif

  let limit = ''
  if g:MyQuickfixSearchLimit
    let limit = ' -' . g:MyQuickfixSearchLimit
  endif

  " /dev/null forces absolute paths if greping a single file
  let findprg = grepprg
        \ . ' -g ' . shellescape(filenameTerm)
        \ . ' ' . fnameescape(path)
        \ . ' /dev/null'

  if orderBy == 'recent'
    let findprg .= ' | sort-by-file-modification | tac '
  else
    let findprg .= ''
          \ . ' | sort '
          \ . ' | sort-by-path-depth '
          \ . ' | head-warn' . limit
  endif

  let grepprg .= ' ' . shellescape(term) . ' ' . fnameescape(path)
        \ . ' /dev/null'
        \ . ' | head-warn' . limit

  let tempfile = tempname()
  call writefile([], tempfile)

  if $DEBUG
    call writefile([tempfile . ':0:0:tempfile'], tempfile, 'a')
    if find
      call writefile(['/dev/null:0:0:findprg: ' . findprg], tempfile, 'a')
    endif
    if grep
      call writefile(['/dev/null:0:0:grepprg: ' . grepprg], tempfile, 'a')
    endif
  endif

  if find
    call system(findprg . '>> ' . tempfile)
  endif
  if grep
    call system(grepprg . '>> ' . tempfile)
  endif

  " NOTE: semicolon seem to trigger a redirect into a vim tempfile.
  " let &l:makeprg = findprg . '\; ' . grepprg
  " make!

  if term != ''
    let title = term
  endif
  if title != ''
    let title = 'Search for: ' . title
  endif

  " let &l:errorformat = '%f:%l:%c:%m,%f:%l%m,%f  %l%m,%f'
  let &l:errorformat = '%f:%l:%c:%m,%f,%m'
  execute 'cgetfile ' . tempfile
  call MyQuickfixSetTitle(title)
  call cursor(l:save_pos[1:])
  call MyHelpersClosePreviewWindow()
  copen
endfunction

let g:MyQuickfixAllSearchOptions = []
function! MyQuickfixAddMappings(key, options) abort
  let options = [
        \ { 'key': 'f' , 'title': '<all files>', },
        \ { 'key': 'i', 'ask': 1, },
        \ { 'key': 'I', 'ask': 1, 'wordBoundary': 1, },
        \ { 'key': 'w', 'expand': '<cword>', 'wordBoundary': 1, },
        \ { 'key': 'W', 'expand': '<cWORD>', 'wordBoundary': 1, },
        \ { 'key': 'l', 'expand': '<cword>', },
        \ { 'key': 'L', 'expand': '<cWORD>', },
        \ { 'key': 'r', 'orderBy': 'recent', },
        \ { 'key': 'F', 'expand': '%:t', },
        \ { 'key': 'B', 'expand': '%:t:r', },
        \ ]
  for optionsEntry in options
    let combinedOptions = optionsEntry
    call extend(combinedOptions, a:options)
    call add(g:MyQuickfixAllSearchOptions, combinedOptions)

    execute 'nnoremap <silent> <leader>'
          \ . a:key . optionsEntry['key']
          \ . ' :call MyQuickfixSearch(g:MyQuickfixAllSearchOptions['
          \ . (len(g:MyQuickfixAllSearchOptions) - 1)
          \ . '])<cr>'
  endfor

  let combinedOptions = a:options
  call extend(combinedOptions, {'selection' : 1})
  call add(g:MyQuickfixAllSearchOptions, combinedOptions)
  " let keyPostfix = a:key[-1:]
  execute 'vnoremap <silent> <leader>'
        \ . a:key
        \ . 's'
        \ . ' :call MyQuickfixSearch(g:MyQuickfixAllSearchOptions['
        \ . (len(g:MyQuickfixAllSearchOptions) - 1)
        \ . '])<cr>'
endfunction
nnoremap <silent> <leader>f <nop>

nnoremap <silent> <leader>ft :call MyQuickfixSearch({ 'term': 'todo' })<cr>

function! MyQuickfixFindInBuffer() abort
  return { 'find': 0, 'path': expand('%:p') }
endfunction

function! MyQuickfixFindInBufferDir() abort
  return { 'path': MyQuickfixBufferDir() }
endfunction

call MyQuickfixAddMappings('f', {})
call MyQuickfixAddMappings('fz', { 'fuzzy': 1 })
call MyQuickfixAddMappings('fa', { 'useIgnoreFile': 0 })
call MyQuickfixAddMappings('fb', { 'function': 'MyQuickfixFindInBuffer' } )
call MyQuickfixAddMappings('fv', { 'path': g:vim.etc.dir })
call MyQuickfixAddMappings('fvp', { 'path': g:vim.bundle.dir })
call MyQuickfixAddMappings('fd', { 'function': 'MyQuickfixFindInBufferDir' })
call MyQuickfixAddMappings('fn', { 'path': g:MyNotesDir })

call MyQuickfixAddMappings('fp', { 'path': '~/src/' })
nnoremap <silent> <leader>fpp :edit ~/src/<cr>

nnoremap <silent> <leader>vph :execute 'help ' . expand('%:t:r')<cr>

function! MyQuickfixOutline(location) abort
  silent wall
  cclose
  " let pcreDefine = substitute(&define, '^\\v', '', 'g')
  let pcreDefine = RegexToPcre(&define)
  if a:location == 'bufferOnly'
    call MyQuickfixSearch({ 'term': pcreDefine, 'find': 0, 'path': expand('%:p'), })
  else
    call MyQuickfixSearch({ 'term': pcreDefine, 'find': 0, })
  endif
endfunction
nnoremap <silent> <leader>o :call MyQuickfixOutline('bufferOnly')<cr>
nnoremap <silent> <leader>O :call MyQuickfixOutline('wholeProject')<cr>

let g:lastCommand = 'echo "Specify command"'
function! MyQuickfixRun(...) abort
  let saved_cursor = getcurpos()
  let cmd = join(a:000)
  let &l:makeprg = cmd
  let &l:errorformat = '%f:%l:%c:%m,%f'
  let g:lastCommand = &l:makeprg
  silent wall
  silent! make!
  copen
  call setpos('.', saved_cursor)
endfunction
command! -bang -nargs=1 Run call MyQuickfixRun(<f-args>)
nnoremap <silent> <leader>ef :call MyQuickfixRun(expand('%:p'))<cr>
nnoremap <silent> <leader>ei :call MyQuickfixRun(input('Command: '))<cr>
nnoremap <silent> <leader>el :call MyQuickfixRun(substitute(getline('.'), '\v^["#/ ]+', "", ""))<cr>
nnoremap <silent> <leader>ee :call MyQuickfixRun(g:lastCommand)<cr>

command! -nargs=* MyQuickfixDump call MyQuickfixDump (<f-args>)
function! MyQuickfixDump(...) abort
  call DUMP(getqflist())
endfunction

command! -nargs=* MyLoclistDump call MyLoclistDump (<f-args>)
function! MyLoclistDump(...) abort
  call DUMP(getloclist(0))
endfunction

" setqflist() has a fixed display format so it can not be used for formatting.
" This function only formats and *must* not delete entries - use a different
" function for that.
function! MyQuickfixFormatSimple() abort
  let qflist = getqflist()
  setlocal modifiable
  %delete _
  let maxFilenameLength = 0
  let maxTextLength = 0
  for entry in qflist
    let textLength = len(entry.text)
    if textLength > maxTextLength
      let maxTextLength = textLength
    endif
    let path = fnamemodify(bufname(entry.bufnr), ':.')
    let basename = fnamemodify(path, ':t')
    let dir = fnamemodify(path, ':h:t')
    if dir == '.'
      let dir = ''
    else
      let dir .= '/'
    endif
    let filename = dir . basename
    let filenameLength = len(filename)
    if filenameLength > maxFilenameLength
      let maxFilenameLength = filenameLength
    endif
  endfor
  for entry in qflist
    let path = fnamemodify(bufname(entry.bufnr), ':.')
    let basename = fnamemodify(path, ':t')
    let dir = fnamemodify(path, ':h:t')
    if dir == '.'
      let dir = ''
    else
      let dir .= '/'
    endif
    let filename = dir . basename
    let text = printf('%-' . maxFilenameLength . 's', filename)
    " if entry.text != ''
      if maxTextLength > 0
        let text .= ' │ '
      endif
      " let text .= entry.text
      let text .= substitute(entry.text, '\v^\s*', '', 'g')
    " endif
    let text = substitute(text, '\v[\r]*$', '', 'g')
		call append(line('$'), text)
  endfor
  keepjumps normal! "_dd
  setlocal nomodifiable
  setlocal nomodified
endfunction

augroup MyQuickfixAugroupFormat
  autocmd!
  autocmd FileType qf :call MyQuickfixFormat()
augroup END

let g:MyQuickfixFormat = 'Simple'
function! MyQuickfixFormat() abort
  if g:MyQuickfixFormat == 'None'
    return
  endif
  call function('MyQuickfixFormat' . g:MyQuickfixFormat)()
endfunction

function! MyQuickfixSetTitle(title) abort
  call setqflist([], 'a', { 'title' : a:title })
endfunction

function! MyQuickfixFormatToggle() abort
  let found = 0
  for format in ['Simple', 'None', 'last']
    if found == 1
      let g:MyQuickfixFormat = format
      break
    endif
    if g:MyQuickfixFormat == format
      let found = 1
    endif
  endfor
  if g:MyQuickfixFormat == 'last'
    let g:MyQuickfixFormat = 'Simple'
  endif
  " call MyQuickfixSetTitle(g:MyQuickfixFormat)
  copen
endfunction

function! MyQuickfixRemoveInvalid() abort
  call setqflist(filter(copy(getqflist()), 'v:val.valid == 1'))
endfunction

" http://dhruvasagar.com/2013/12/17/vim-filter-quickfix-list
function! MyQuickfixFilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~?' : '=~?'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) "
        \ . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file QFilter call
      \ MyQuickfixFilterQuickfixList(<bang>0, <q-args>)

" map _  <Plug>(operator-adjust)
" call operator#user#define('adjust', 'Op_adjust_window_height')
" function! Op_adjust_window_height(motion_wiseness)
"   execute (line("']") - line("'[") + 1) 'wincmd' '_'
"   normal! `[zt
" endfunction

" if neobundle#tap('vim-operator-user')
"   function! neobundle#hooks.on_post_source(bundle) abort
"     call operator#user#define('grep', 'MyQuickfixOpGrep')
"     function! MyQuickfixOpGrep(motion_wise)
"       let v = operator#user#visual_command_from_wise_name(a:motion_wise)
"       execute 'normal!' '`[' . v . '`]"xy'
"       " call INFO('X: ', getreg(operator#user#register()))
"       call MyQuickfixSearch({'term': @x})
"     endfunction
"   endfunction
"   call neobundle#untap()
" endif
" map x  <Plug>(operator-grep)

" augroup MyQuickfixAugroupTodo
"     " QuickFixCmd* Does not match :ltag
"     autocmd QuickFixCmdPost [^l]* nnoremap <tab> :copen<cr>
"     autocmd QuickFixCmdPost [^l]* botright copen
"     autocmd QuickFixCmdPost [^l]* let b:isQuickfix = 1
"     autocmd QuickFixCmdPost    l* nnoremap <tab> :lopen<cr>
"     autocmd QuickFixCmdPost    l* botright lopen
" augroup END

function! MyQuickfixGetErrorCount() abort
  return len(filter(getqflist(), 'v:val.valid'))
endfunction

function! MyLoclistGetErrorCount() abort
  return len(filter(getloclist(0), 'v:val.valid'))
endfunction
