" Search in file names and contents and some quickfix tweaks.

MyInstall rg apt-get install ripgrep

" " Always show signs column
" sign define MyQuickfixSignEmpty
" augroup MyQuickfixAugroupPersistentSignsColumn
"   autocmd!
"   autocmd BufEnter * call MyQuickfixShowSignsColumn()
"   autocmd FileType qf call MyQuickfixShowSignsColumn()
" augroup END

" function! MyQuickfixShowSignsColumn() abort
"   execute 'execute ":sign place 9999 line=1
"         \ name=MyQuickfixSignEmpty buffer=".bufnr("")'
" endfunction

let &signcolumn = 'no'

nnoremap <silent> <tab> :copen<cr>
nnoremap <silent> <s-tab> :lopen<cr>

function! MyQuickfixBufferDir() abort
  return expand("%:p:h")
endfunction

let g:MyQuickfixIgnoreFile = $CONTRIB . '/ignore-files'

let g:MyQuickfixSearchLimit = '5000'

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
  let hidden = get(options, 'hidden', 1)
  let fuzzy = get(options, 'fuzzy', '0')
  let ask = get(options, 'ask', '0')
  let selection = get(options, 'selection', '0')
  let wordBoundary = get(options, 'wordBoundary', '0')
  let title = get(options, 'title', '')
  let strict = 0
  let path = get(options, 'path', '')
  let ignoreCase = get(options, 'ignoreCase', 1)
  let type = get(options, 'type', 0)

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

  " apparently you can not word-bind non-word characters
  let isWordBoundable = 0
  if term =~ '\v^\w' && term =~ '\v\w$'
    let isWordBoundable = 1
  endif

  let pos = []
  call substitute(term, '\v([^\:]+)\:(\d+)(\:(\d+))*', {m -> extend(pos, m)[0]}, 'g')
  let file = get(pos, 1, term)
  let line = get(pos, 2)
  let column = get(pos, 4)

  if line
    let term = file
  endif

  " fuzzy search for most case variants and plurals
  if fuzzy
    let words = split(term, '\v\s+')
    let allVariants = []
    for word in words
      let variants = []
      call add(variants, word)
      call add(variants, substitute(word, 's$', '', 'gi'))
      call add(variants, substitute(word, '$', 's', 'gi'))
      call add(variants, substitute(word, 'y$', 'ies', 'gi'))
      call add(variants, substitute(word, 'ies$', 'y', 'gi'))
      let words = copy(variants)
      for word in words
        call add(variants, substitute(word, '\(\<\u\l\+\|\l\+\)\(\u\)', '\l\1.{0,1}\l\2', 'g'))
      endfor
      let words = copy(variants)
      let variants = []
      for word in words
        call add(variants, substitute(word, '\v[-_]+', '.{0,1}', 'g'))
      endfor
      call add(allVariants, variants)
    endfor
    let term = ''
    for variants in allVariants
      let term .= '(?=^.*(' . join(uniq(sort(variants)), '|') . ').*$)'
    endfor
  endif

  if strict && ! fuzzy
    let term = '\Q' . term . '\E'
  endif

  if !strict
    let term = substitute(term, '\v\s+', '.*', 'g')
  endif

  if wordBoundary && isWordBoundable
    let term = '(\b|_)' . term . '(\b|_)'
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
    let filenameTerm = '/.*' . term . '[^/]*$'
  else
    " exclude current path from file match
    let filenameTerm = '\Q' . fnameescape(path) . '\E' . '.*' . filenameTerm
  endif

  let grepprg = "rg --pcre2 --vimgrep --type-add 'javascript:*.js'"

  " don't search for ignore files
  " let grepprg .= ' --no-ignore --iglob "!.git"'

  if useIgnoreFile
    let grepprg .= ' --ignore-file ' . g:MyQuickfixIgnoreFile
  else
    let grepprg .= ' --no-ignore'
  endif

  if hidden
    let grepprg .= ' --hidden'
  endif

  if ignoreCase
    let grepprg .= ' --ignore-case'
  endif

  if type
    let grepprg .= ' -t ' . &filetype
  endif

  let grepprg .= ' --iglob "!.git"'

  let limit = ''
  if g:MyQuickfixSearchLimit
    let limit = ' -' . g:MyQuickfixSearchLimit
  endif

  let findprg = grepprg
        \ . ' --files'
        \ . ' ' . fnameescape(path)

  if filenameTerm != ''
    let findprg .= ' | rg --follow --ignore-case --pcre2 ' . shellescape(filenameTerm)
  endif

  if orderBy == 'recent'
    let findprg .= ' | sort-by-file-modification | tac'
  else
    let findprg .= ''
          \ . ' | sort'
          \ . ' | head-warn' . limit

          " \ . ' | sort-by-path-depth'
  endif

  let findprg .= " | errorformatregex 'n/^()(.+)()()$/gm'"

  let grepprg .= ' ' . shellescape(term) . ' ' . fnameescape(path)
  let grepprg .= " | errorformatregex 'n/^()(.+?)\\:(\\d+)\\:(\\d+)\\:/gm'"
  let grepprg .= ' | head-warn' . limit

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

  let g:MyQuickfixFindPrg = findprg
  let g:MyQuickfixGrepPrg = grepprg

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

  let &l:errorformat = '%f:%l:%c:%t:%m,%f'
  execute 'cgetfile ' . tempfile
  if line
    call MyQuickfixSetDefaultPos(line, column)
  endif
  call MyQuickfixSetTitle(title)
  call cursor(l:save_pos[1:])
  call MyHelpersClosePreviewWindow()
  copen
endfunction

function! MyQuickfixSetDefaultPos(line, column) abort
  let qflist = getqflist()
  for entry in qflist
    if entry.lnum == 0
      let entry.lnum = a:line
      let entry.col = a:column
    endif
  endfor
  call setqflist(qflist)
endfunction

let g:MyQuickfixAllSearchOptions = []
function! MyQuickfixAddMappings(key, options) abort
  let options = [
        \ { 'key': 'f', 'title': '<all files>', 'grep': 0,},
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

nnoremap <silent> <leader>fT :call MyQuickfixSearch({ 'term': 'todo' })<cr>

function! MyQuickfixFindInBuffer() abort
  return { 'find': 0, 'path': expand('%:p') }
endfunction

function! MyQuickfixFindInBufferDir() abort
  return { 'path': MyQuickfixBufferDir() }
endfunction

call MyQuickfixAddMappings('f', {})
call MyQuickfixAddMappings('fz', { 'fuzzy': 1 })
call MyQuickfixAddMappings('fa', { 'useIgnoreFile': 0 })
call MyQuickfixAddMappings('fh', { 'hidden': 1 })
call MyQuickfixAddMappings('fb', { 'function': 'MyQuickfixFindInBuffer' } )
call MyQuickfixAddMappings('fd', { 'function': 'MyQuickfixFindInBufferDir' })
call MyQuickfixAddMappings('fn', { 'path': g:MyNotesDir })
call MyQuickfixAddMappings('ft', { 'type': 1 })

nnoremap <silent> <leader>fg :let &g:errorformat = '%f' \| cgetexpr system('git diff-files --name-only --diff-filter=d') \| :copen<cr>
nnoremap <silent> <leader>jt :call Redir("!tree -C --summary --no-color --exclude node_modules", 0, 0)<cr>

call MyQuickfixAddMappings('fp', { 'path': '~/src/' })
nnoremap <silent> <leader>fpp :edit ~/src/<cr>

nnoremap <silent> <leader>vph :execute 'edit '
      \ . stdpath('config') . '/pack/minpac/opt/'
      \ . expand('%:t:r') . '/README.md'<cr>

function! MyQuickfixOutline(location) abort
  silent wall
  cclose
  " let pcreDefine = substitute(&define, '^\\v', '', 'g')
  if ! exists('b:outline')
    return
  endif
  " let pcreDefine = RegexToPcre(b:outline)
  let pcreDefine = b:outline
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
  " let saved_cursor = getcurpos()
  let cmd = join(a:000)
  let &l:makeprg = cmd
  let &l:errorformat = '%f:%l:%c:%t:%m'
  " let &l:errorformat = '%m'
  let g:lastCommand = &l:makeprg
  silent wall
  silent! make!
  copen
  " call setpos('.', saved_cursor)
endfunction
command! -bang -nargs=* Run call MyQuickfixRun(<f-args>)
nnoremap <leader>ef :call MyQuickfixRun(expand('%:p'))<left>
nnoremap <leader>ei :Run<space>
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
function! MyQuickfixFormatAsSimple() abort
  if BufferIsLoclist()
    let qflist = getloclist(0)
  else
    let qflist = getqflist()
  endif
  setlocal modifiable
  %delete _
  let maxFilenameLength = 0
  let maxTextLength = 0
  let singleFilename = 1
  let lastFilename = ''
  for entry in qflist
    let textLength = len(entry.text)
    if textLength > maxTextLength
      let maxTextLength = textLength
    endif
    if entry.bufnr == 0
      let bufname = ''
    else
      let bufname = bufname(entry.bufnr) 
    endif
    let path = fnamemodify(bufname, ':.')
    let basename = fnamemodify(path, ':t')
    let dir = fnamemodify(path, ':h:t')
    if dir == '.'
      let dir = ''
    else
      let dir .= '/'
    endif
    let filename = dir . basename
    if lastFilename == ''
      let lastFilename = filename
    endif
    if lastFilename != filename
      let singleFilename = 0
    endif
    " let filenameLength = len(filename)
    let filenameLength = len(path)
    if filenameLength > maxFilenameLength
      let maxFilenameLength = filenameLength
    endif
  endfor
  let texts = []
  for entry in qflist
    if entry.bufnr == 0
      let bufname = ''
    else
      let bufname = bufname(entry.bufnr)
    endif
    let path = fnamemodify(bufname, ':.')
    let basename = fnamemodify(path, ':t')
    let dir = fnamemodify(path, ':h:t')
    if dir == '.'
      let dir = ''
    else
      let dir .= '/'
    endif
    " let filename = dir . basename
    let filename = path
    let text = filename
    " if ! singleFilename
      " if entry.valid
      "   if entry.text == ''
      "     let text = filename
      "   endif
      " endif
      if maxTextLength > 0
        let text = printf('%-' . maxFilenameLength . 's', text)
        let text .= ' │ '
      endif
    " endif
    if entry.valid
      " if entry.text != ''
      " if maxTextLength > 0
        " let text .= '❭ '
        " let text .= '❱ '
        " let text .= '⚠ '
      " else
        " let text = '❱ ' . text
      " endif
    else
        " let text = '  ' . text
    endif
    " let text .= substitute(entry.text, '\v^\s*', '', 'g')
    let text .= entry.text
    let text = substitute(text, '\v[\n\r]', '', 'g')
    call add(texts, text)
  endfor
  " a lot faster to add all lines in a list sometimes (umlauts problem?)
  call append(line('$'), texts)
  keepjumps normal! "_dd
  setlocal nomodifiable
  setlocal nomodified
endfunction

function! MyQuickfixFormatAsNoFile() abort
  if BufferIsLoclist()
    let qflist = getloclist(0)
  else
    let qflist = getqflist()
  endif
  setlocal modifiable
  %delete _
  let texts = []
  for entry in qflist
    let text = entry.text
    " if entry.valid
    "     let text = '❱ ' . text
    " else
    "     let text = '  ' . text
    " endif
    let text = substitute(text, '\v[\n\r]', '', 'g')
    call add(texts, text)
  endfor
  " a lot faster to add all lines in a list sometimes (umlauts problem?)
  call append(line('$'), texts)
  keepjumps normal! "_dd
  setlocal nomodifiable
  setlocal nomodified
endfunction

augroup MyQuickfixAugroupCloseQfWindows
  autocmd!
  autocmd QuickFixCmdPre * cclose | lclose
augroup END

augroup MyQuickfixAugroupFormat
  autocmd!
  autocmd FileType qf call MyQuickfixFormat()
augroup END

let g:MyQuickfixFormat = 'Simple'
function! MyQuickfixFormat() abort
  call function('MyQuickfixFormatAs' . g:MyQuickfixFormat)()
endfunction

function! MyQuickfixFormatAsNone() abort
  " nothing
endfunction

function! MyQuickfixFormatToggle() abort
  if g:MyQuickfixFormat == 'Simple'
    let g:MyQuickfixFormat = 'None'
  else
    let g:MyQuickfixFormat = 'Simple'
  endif
  if BufferIsQuickfix()
    cclose
    copen
  else
    lclose
    lopen
  endif
endfunction

function! MyQuickfixSetTitle(title) abort
  call setqflist([], 'a', { 'title' : a:title })
endfunction

" TODO: keep cursor in qf
" nnoremap <silent> <cmd> 5 {-> execute('pedit ' . MyQuickfixGetCurrent().filename)}
" nnoremap <silent> <cmd> 5 execute 'pedit ' . MyQuickfixGetCurrent().filename<cr>
" nnoremap <leader>5 :call MyQuickfixPreview()<cr>
function! MyQuickfixPreview() abort
  let filename = MyQuickfixGetCurrent().filename
  " cclose
  execute 'pedit ' . filename
  " copen
endfunction

function! MyQuickfixGetCurrent() abort
  let [bufnum, lnum, col, off] = getpos('.')
  let qflist = getqflist()
  let qflnum = 0
  for entry in qflist
    let qflnum = qflnum + 1
    if qflnum == lnum
      let entry.filename = bufname(entry.bufnr)
      return entry
    endif
  endfor
  return {}
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

function! MyQuickfixHideWarnings()
  call setqflist(filter(getqflist(), "v:val['type'] == 'E'"))
endfunction
command! -bang -nargs=* -complete=file QFwarnings call
      \ MyQuickfixHideWarnings()

" augroup MyQuickfixAugroupTodo
"     " QuickFixCmd* Does not match :ltag
"     autocmd QuickFixCmdPost [^l]* nnoremap <tab> :copen<cr>
"     autocmd QuickFixCmdPost [^l]* botright copen
"     autocmd QuickFixCmdPost [^l]* let b:isQuickfix = 1
"     autocmd QuickFixCmdPost    l* nnoremap <tab> :lopen<cr>
"     autocmd QuickFixCmdPost    l* botright lopen
" augroup END

function! MyQuickfixIsError() abort
  echo getqflist()[getcurpos()[1]-1].valid
endfunction

" TODO: split by \r and add new entries to the quickfix
" Vars are stored with <00> in vim and don't result in new lines when printed
function! MyQuickfixFixNewlines() abort
  let qflist = getqflist()
  for entry in qflist
    let entry.text = substitute(entry.text, '\%u00', '\r', 'g')
  endfor
  call setqflist(qflist)
endfunction
