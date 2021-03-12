" Search in file names and contents and some quickfix tweaks.

MyInstall rg ripgrep-install
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

function! my_quickfix#openLoclist() abort
  if len(getloclist(0)) == 0
    call nb#info('Location list is empty.')
    return
  endif
  lopen
endfunction
nnoremap <silent> <tab> :copen<cr>
nnoremap <silent> <s-tab> :call g:my_quickfix#openLoclist()<cr>

function! MyQuickfixBufferDir() abort
  return expand("%:p:h")
endfunction

let g:MyQuickfixIgnoreFile = $CONTRIB . '/ignore-files'
let g:MyQuickfixSearchLimit = '5000'
let g:MyQuickfixWrap = 'nowrap'

command! -bang -nargs=* Search call MyQuickfixSearch({'term': <q-args>})
function! MyQuickfixSearch(options) abort

  let options = {}
  call extend(options, a:options)

  let functionRef = get(a:options, 'function', '')
  " echo functionRef
  if functionRef != ''
    call extend(options, {functionRef}())
  endif

  let l:save_pos = getcurpos()
  let term = get(options, 'term', '')
  let find = get(options, 'find', '1')
  let grep = get(options, 'grep', '1')
  let matchFilenameOnly = get(options, 'matchFilenameOnly', '0')
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
  let multiline = get(options, 'multiline', 1)
  let exact = get(options, 'exact', 0)

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

  call setreg('/', term)

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

  let orgTerm = term

  let term = substitute(orgTerm, '\v\s+', '[\n]*.*', 'g')

  if strict
    let term = '\Q' . orgTerm . '\E'
  endif

  if exact
    let term = orgTerm
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
    " let filenameTerm = '/.*' . term . '[^/]*$'
    let filenameTerm = '.*' . term . '.*$'
  else
    " exclude current path from file match
    let filenameTerm = '\Q' . fnameescape(path) . '\E' . '.*' . filenameTerm
  endif

  let grepprg = "timeout -s kill 5s rg --pcre2 --vimgrep --type-add 'javascript:*.js'"

  if multiline == 1
    let grepprg .= " -U"
  endif

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

  let grepprg .= ' --iglob ''!.git'''

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

  let grepprg .= ' ' . shellescape(term) . ' ' . fnameescape(path)
  let grepprg .= " | errorformatregex 'n/^(?<file>.+?)\\:(?<row>\\d+)\\:(?<col>\\d+)\\:/gm' 2>&1"
  let grepprg .= ' | head-warn' . limit

  let tempfile = tempname()

  if $DEBUG
    let tempfile .= '-mydebug'
  endif

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
    let &makeprg = findprg
    call system(findprg . '>> ' . tempfile)
    if v:shell_error
      echoerr 'Error finding.'
    endif
  endif
  if grep
    if matchFilenameOnly != 1
      let &makeprg = grepprg
      call system(grepprg . '>> ' . tempfile)
      if v:shell_error
        echoerr 'Error grepping.'
      endif
    endif
  endif

	" let somectx = {'makeprg' : &makeprg}
	" call setqflist([], 'a', {'context' : somectx})
  " call setqflist([], 'a', {'context': { 'foo': 'no'}})

  " NOTE: semicolons seem to trigger a redirect into a vim tempfile.
  " let &l:makeprg = findprg . '\; ' . grepprg
  " make!

  " if title == ''
  "   let title = term
  "   let title = substitute(title, '\v\n', '', 'g')
  "   let title = 'Search: ' .. title
  " endif

  let &l:errorformat = 'errorformatregex:%f:%l:%c:%t:%m,errorformatregex:%f,%f'
  execute 'cgetfile ' . tempfile
  if line
    call MyQuickfixSetDefaultPos(line, column)
  endif
  call setqflist([], 'a', { 'title' : title })
  call cursor(l:save_pos[1:])
  silent! pclose
  " call MyHelpersClosePreviewWindow()
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
        \ { 'key': 'f', 'title': 'all files', 'grep': 0,},
        \ { 'key': 'i', 'ask': 1, },
        \ { 'key': 'I', 'ask': 1, 'wordBoundary': 1, },
        \ { 'key': 'w', 'expand': '<cword>', 'wordBoundary': 1, },
        \ { 'key': 'W', 'expand': '<cWORD>', 'wordBoundary': 1, },
        \ { 'key': 'l', 'expand': '<cword>', },
        \ { 'key': 'L', 'expand': '<cWORD>', },
        \ { 'key': 'r', 'orderBy': 'recent', 'grep': 0, },
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
call MyQuickfixAddMappings('ft', { 'type': 1 })
call MyQuickfixAddMappings('fn', { 'matchFilenameOnly': '1', })

nnoremap <silent><leader>// :let g:MyQuickfixFormatOnce = 'NoFile' \| normal <leader>fbi<cr>
nnoremap <silent><leader>* :let g:MyQuickfixFormatOnce = 'NoFile' \| normal <leader>fw<cr>

" nnoremap <silent> <leader>jj :call MyQuickfixSearch({ 'path': '/tmp', 'term': '.', 'find': 1, 'grep': 0, 'orderBy': 'recent', })<cr>

nnoremap <silent> <leader>fg :let &g:errorformat = '%f' \| cgetexpr system('git diff-files --name-only --diff-filter=d') \| :copen<cr>
nnoremap <silent> <leader>jt :call Redir("!tree -C --summary --no-color --exclude node_modules", 0, 0)<cr>

call MyQuickfixAddMappings('fp', { 'path': '~/src/' })
nnoremap <silent> <leader>fpp :edit ~/src/<cr>

nnoremap <silent> <leader>vph :execute 'edit '
      \ . stdpath('config') . '/pack/minpac/opt/'
      \ . expand('%:t:r') . '/README.md'<cr>

nnoremap <silent> <leader>vpp :execute 'edit '
      \ . stdpath('config') . '/pack/minpac/opt/'<cr>

function! MyQuickfixOutline(location) abort
  cclose
  " let pcreDefine = substitute(&define, '^\\v', '', 'g')
  if ! exists('b:outline')
    call nb#info('b:outline not defined for filetye: ' . &filetype)
    return
  endif
  " let pcreDefine = RegexToPcre(b:outline)
  let pcreDefine = b:outline
  if a:location == 'bufferOnly'
    let g:MyQuickfixFormatOnce = 'NoFile'
    call MyQuickfixSearch({ 'term': pcreDefine, 'find': 0, 'path': expand('%:p'), 'multiline': 0, 'exact': 1})
  else
    call MyQuickfixSearch({ 'term': pcreDefine, 'find': 0, 'multiline': 0, 'exact': 1})
  endif
  call setqflist([], 'a', { 'title' : 'outline' })
  " TODO: loop over qf list to find line closest to current and set it
endfunction
nnoremap <silent> <leader>o :call MyQuickfixOutline('bufferOnly')<cr>
nnoremap <silent> <leader>O :call MyQuickfixOutline('wholeProject')<cr>

let g:lastCommand = 'echo "Specify command"'
function! MyQuickfixRun(...) abort
  let cmd = join(a:000)
  let &makeprg = cmd
  let &errorformat = '%f:%l:%c:%t:%m'
  let g:lastCommand = &makeprg
  silent wall
  silent make!
  copen
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
  silent! %delete _
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

augroup my_quickfix#augroupWrite
  autocmd!
  autocmd QuickFixCmdPre * silent! wall
augroup END

augroup MyQuickfixAugroupFormat
  autocmd!
  autocmd FileType qf call MyQuickfixFormat()
augroup END

let g:MyQuickfixFormat = 'Simple'
let g:MyQuickfixFormatOnce = ''
function! MyQuickfixFormat() abort
  if g:MyQuickfixFormatOnce != ''
    let format = g:MyQuickfixFormatOnce
    let g:MyQuickfixFormatOnce = ''
  else
    let format = g:MyQuickfixFormat
  endif
  call function('MyQuickfixFormatAs' . format)()
endfunction

function! MyQuickfixFormatAsNone() abort
  " nothing
endfunction

function! MyQuickfixFormatToggle() abort
  if g:MyQuickfixFormat == 'Simple'
    let g:MyQuickfixFormat = 'NoFile'
    " let g:MyQuickfixFormat = 'None'
    let g:MyQuickfixWrap = 'wrap'
  else
    let g:MyQuickfixFormat = 'Simple'
    let g:MyQuickfixWrap = 'nowrap'
  endif
  if BufferIsQuickfix()
    cclose
    copen
  else
    lclose
    lopen
  endif
endfunction

" TODO: keep cursor position in qf
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

function! MyQlistVars() abort
  silent Verbose set include? define? includeexpr? suffixesadd?
endfunction

function! my_quickfix#showMakeInfo() abort
  Redirv echo &makeprg
  silent! keeppatterns %s/\v \| /\r    | /g
  RedirAppendv echo &errorformat
  keepjumps normal gg
endfunction
nnoremap <silent> <leader>vi :call my_quickfix#showMakeInfo()<cr>

