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
  let l:save_pos = getcurpos() 
  let term = get(a:options, 'term', '')
  let find = get(a:options, 'find', '1')
  let grep = get(a:options, 'grep', '1')
  let matchFilenameOnly = get(a:options, 'matchFilenameOnly', '1')
  let orderBy = get(a:options, 'orderBy', '')
  let useIgnoreFile = get(a:options, 'useIgnoreFile', 1)
  let fuzzy = get(a:options, 'fuzzy', '0')
  let ask = get(a:options, 'ask', '0')
  let selection = get(a:options, 'selection', '0')
  let wordBoundary = get(a:options, 'wordBoundary', '0')

  if selection
    let term = '\Q' . MyHelpersGetVisualSelection() . '\E'
  elseif ask
    let term = input('Search: ')
  endif

  if exists('a:options["expand"]')
    let term = expand(a:options['expand'])
  endif

  " fuzzy search for most case variants and plurals
  if fuzzy
    let words = split(term, ' +')
    let finalTerms = []
    let variants = []
    for word in words
      call add(variants, word)
      call add(variants, substitute(word, 's$', '', 'gi'))
      call add(variants, substitute(word, '$', 's', 'gi'))
      call add(variants, substitute(word, 'y$', 'ies', 'gi'))
      call add(variants, substitute(word, 'ies$', 'y', 'gi'))
      call add(finalTerms, '(' . join(variants, '|') . ')')
    endfor
    let words = copy(variants)
    for word in words
      call add(variants, substitute(word, '[-_]+', '.', 'g'))
      call add(variants, substitute(word, '\(\<\u\l\+\|\l\+\)\(\u\)', '\l\1[\s\_\-]{0,1}\l\2', 'g'))
    endfor
    let term = '(' . join(uniq(sort(variants)), '|') . ')+'
  endif

  if wordBoundary
    let term = '\b' . term . '\b'
  endif

  " call INFO('term:', term)

  let filenameTerm = term

  let project_dir = FindRootDirectory()
  if project_dir == ''
    let project_dir = MyQuickfixBufferDir()
  endif
  let path = get(a:options, 'path', project_dir)
  let path = fnamemodify(path, ':p')

  " force path to be ralative in quickfix display
  " execute 'lcd' path

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
        \ . ' | head-warn ' . limit
  endif

  let grepprg .= ' ' . shellescape(term) . ' ' . fnameescape(path)
        \ . ' /dev/null'
        \ . ' | head-warn ' . limit

  let makers = 'find'
  if term != ''
    if grep != '0'
      " let makers .= ' delimiter grep'
      let makers .= ' grep'
    endif
  endif

  let MyErrorformat = '%f:%l:%c:%m,%f:%l%m,%f  %l%m,%f'
  let g:neomake_delimiter_maker = MyQuickfixToMaker('echo',
        \ MyErrorformat)
  if find
    let g:neomake_find_maker = MyQuickfixToMaker(findprg,
          \ MyErrorformat)
  endif
  if grep
    let g:neomake_grep_maker = MyQuickfixToMaker(grepprg,
          \ MyErrorformat)
  endif

  let findprg = substitute(findprg, '|', '\\|', 'g')
  let grepprg = substitute(grepprg, '|', '\\|', 'g')

  " call INFO('findprg:', findprg)
  " call INFO('grepprg:', grepprg)

  call cursor(l:save_pos[1:])

  " let &l:errorformat = '%f:%l:%c:%m,%f:%l%m,%f  %l%m,%f'
  " let &l:makeprg = findprg . '\; ' . grepprg
  " let &l:makeprg = grepprg
  " let &l:makeprg = findprg 

  " call INFO('Running: ' . &makeprg . ' ###')

  " make!
  " copen

  execute 'Neomake! ' . makers
endfunction

let g:MyQuickfixAllSearchOptions = []
function! MyQuickfixAddMappings(key, options) abort
  let options = [
        \ { 'key': 'f' },
        \ { 'key': 'i', 'ask': 1, },
        \ { 'key': 'w', 'expand': '<cword>', 'wordBoundary': 1 },
        \ { 'key': 'W', 'expand': '<cWORD>', 'wordBoundary': 1 },
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
nnoremap <silent> <leader>ft :call MyQuickfixSearch({ 'term': 'todo'})<cr>
call MyQuickfixAddMappings('ff', {})
call MyQuickfixAddMappings('fz', { 'fuzzy': 1 })
call MyQuickfixAddMappings('fa', { 'useIgnoreFile': 0 })
call MyQuickfixAddMappings('fs', { 'path': '~/src/' })
call MyQuickfixAddMappings('fb', { 'find': 0, 'path': expand('%:p') })
call MyQuickfixAddMappings('fv', { 'path': g:vim.etc.dir })
call MyQuickfixAddMappings('fvp', { 'path': g:vim.bundle.dir })
call MyQuickfixAddMappings('fd', { 'path': MyQuickfixBufferDir() })
call MyQuickfixAddMappings('fn', { 'path': g:MyNotesDir })

let g:lastCommand = 'echo "Specify command"'
function! MyQuickfixRun(...) abort
  let saved_cursor = getcurpos()
  " TODO: limit to myrun
  NeomakeCancelJobs
  " prevent vim from removing leading space by replacing it with special space (utf8 2001)
  " let cmd = join(a:000) . ' 2>&1 ' . " | perl -pe 's/^\\s/\x{2001}/g'" 
  let cmd = join(a:000) . ' 2>&1 ' . " | perl -pe 's/^\\s/ /g'" 
  let g:lastCommand = cmd
  silent wall
  let g:neomake_myrun_maker = MyQuickfixToMaker(
        \ cmd,
        \ '%f:%l:%c:%m,%f')
  call setpos('.', saved_cursor)
  execute 'Neomake! myrun'
  call setpos('.', saved_cursor)
endfunction
command! -bang -nargs=1 Run call MyQuickfixRun(<f-args>)
nnoremap <silent> <leader>ef :call MyQuickfixRun(expand('%:p'))<cr>
nnoremap <silent> <leader>el :call MyQuickfixRun(substitute(getline('.'), '\v^["#/ ]+', "", ""))<cr>
nnoremap <silent> <leader>ee :call MyQuickfixRun(g:lastCommand)<cr>
nnoremap <silent> <leader>ep :NeomakeListJobs<cr>

function! MyQuickfixToMaker(cmd, errorformat) abort
  let cmd = a:cmd
  let exe = substitute(cmd, '\s.*', '', 'g')
  let args = substitute(cmd, '^\w\+\s*', '', 'g')
  return {
      \ 'exe' : exe,
      \ 'args': args,
      \ 'errorformat': a:errorformat
      \ }
endfunction

nnoremap <silent><leader>o :call MyQuickfixOutline()<cr>
function! MyQuickfixOutline() abort
  let l:filetype = &filetype
  if exists("b:filetype")
    let l:filetype = b:filetype
  endif
  let cmd = 'outline --filename ' . expand('%:p')
        \ . ' --filetype ' . l:filetype . ' 2>/dev/null'
  call MyQuickfixRun(cmd)
endfunction

command! -nargs=* MyQuickfixDump call MyQuickfixDump (<f-args>)
function! MyQuickfixDump(...) abort
  call DUMP(getqflist())
endfunction

command! -nargs=* MyLoclistDump call MyLoclistDump (<f-args>)
function! MyLoclistDump(...) abort
  call DUMP(getloclist(0))
endfunction

" TODO nnoremap <silent><leader>vh :call _Denite('vim_help', 'help', '', '')<cr>
function! MyQuickfixHelp(term) abort
    silent! execute 'helpgrep ' . a:term
    " silent! execute 'tag /' . a:term
    silent! copen
endfunction
command! -bang -nargs=1 -complete=file H call MyQuickfixHelp(<q-args>)

function! MyQuickfixRemoveSomeLibs() abort
  let qflist = getqflist()
  let newlist = []
  for i in qflist
    let path = fnamemodify(bufname(i.bufnr), ':p')
    if path =~ '\vbluebird'
      continue
    endif
    call add(newlist, i)
  endfor
  call setqflist(newlist)
endfunction

function! MyQuickfixRemoveWhitespace() abort
  let qflist = getqflist()
  let newlist = []
  for i in qflist
    let i.text = substitute(i.text, '\v^[ [:return:]]*', '', 'g')
    " if i.text =~ '\v^\s*$'
    "   continue
    " endif
    call add(newlist, i)
  endfor
  call setqflist(newlist)
endfunction

function! MyQuickfixRemoveInvalidFiles() abort
  let qflist = getqflist()
  let newlist = []
  for i in qflist
    let path = fnamemodify(bufname(i.bufnr), ':p')
    if i.valid == 1
      if ! filereadable(path)
        continue
      endif
    endif
    " if i.text =~ '\v^\s*$'
    "   continue
    " endif
    " let i.text = substitute(i.text, '\v^[ [:return:]]*', '', 'g')
    " if path =~ 'mocha'
    "   continue
    " endif
    call add(newlist, i)
  endfor
  call setqflist(newlist)
endfunction

" setqflist() has a fixed display format
" setqflist() triggers event qf
let g:MyQuickfixFullPath = 1
function! MyQuickfixFormat() abort
  let saved_cursor = getcurpos()
  let qflist = getqflist()
  " setlocal modifiable
  " %delete _
  let i = -1
  let newlist = []
  for entry in qflist
    let path = fnamemodify(bufname(entry.bufnr), ':.')
    if ! filereadable(path)
      " continue
    endif
    let dir = fnamemodify(path, ':h:t')
    if dir == '.'
      let dir = ''
    else
      let dir .= '/'
    endif
    let filename = fnamemodify(path, ':t')
    let text = dir . filename
    if g:MyQuickfixFullPath
      let text = path
    endif
    if !empty(entry.text)
      let text = text . ' || ' . entry.text
    endif
    " let text = substitute(text, '\v^ \+', '  ', 'g')
    let text = substitute(text, '\v^ +', 'XXX', 'g')
    let i = i + 1
    " call append(i, text)
    call add(newlist, entry)
  endfor
  call setqflist(newlist)
  " normal! "_dd
  " call setpos('.', saved_cursor)
  " setlocal nomodifiable
  " setlocal nomodified
endfunction

augroup MyQuickfixAugroupFormat
  autocmd!
  autocmd QuickfixCmdPost * call MyQuickfixFormat()
augroup END

nnoremap <silent> <leader>qff :let g:MyQuickfixFullPath = 1 \| :call MyQuickfixFormat()<cr>
nnoremap <silent> <leader>qfs :let g:MyQuickfixFullPath = 0 \| :call MyQuickfixFormat()<cr>

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
