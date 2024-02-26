" Search in file names and contents and some quickfix tweaks.
" TODO: checkout vim dispatch for async?

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

  " TBD: scpan new lines
  " let words = split(orgTerm, '\v\s+')
  " let regex = []
  " for word in words
  "   call add(regex, word)
  "   call add(regex, '(?:(?!' .. word .. ').)*?')
  " endfor
  " let regex = regex[0:len(regex)-2]
  " let term = join(regex, '')

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

  let grepprg = "timeout -s kill 500s rg --pcre2 --vimgrep --type-add 'javascript:*.js' --type-add 'typescript:*.ts' --sort-files"
  " let grepprg = "timeout -s kill 500s rg --only-matching --pcre2 --vimgrep --type-add 'javascript:*.js' --type-add 'typescript:*.ts'"

  if multiline == 1
    " let grepprg .= " --multiline --multiline-dotall"
    let grepprg .= " --multiline"
  endif

  " don't search for ignore files
  " let grepprg .= ' --no-ignore --iglob "!.git"'

  if useIgnoreFile
    let grepprg .= ' --ignore-file ' . g:MyQuickfixIgnoreFile
    let grepprg .= ' --ignore-file .ignore'
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
  let grepprg .= ' --iglob ''!node_modules'''

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

  let tempfile = g:nb#tempdir . 'my_quickfix'
  call writefile([], tempfile)

  call nb#debug("quickfix tempfile: " . tempfile)
  call nb#debug('findprg:' . findprg)
  call nb#debug('grepprg:' . grepprg)

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

  " NOTE: semicolons seem to trigger a redirect into a vim tempfile.
  " let &l:makeprg = findprg . '\; ' . grepprg
  " make!

  if title == ''
    let title = term
    let title = substitute(title, '\v\n', '', 'g')
    " NOTE: qf list title seems to have a max length - if longer it's not shown
    let title = strcharpart(title, 0, 21)
    let title = 'Search: ' . title
  endif

  let &l:errorformat = 'errorformatregex:%f:%l:%c:%t:%m,errorformatregex:%f,%f'
  execute 'cgetfile ' . tempfile
  if line
    call MyQuickfixSetDefaultPos(line, column)
  endif
  call setqflist([], 'a', { 'title' : title })
  call cursor(l:save_pos[1:])
  silent! pclose
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
        \ { 'key': 'c', 'ask': 1, 'ignoreCase': 0},
        \ { 'key': 'C', 'ask': 1, 'wordBoundary': 1, 'ignoreCase': 0},
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
call MyQuickfixAddMappings('f/', { 'function': 'MyQuickfixFindInBuffer' } )
call MyQuickfixAddMappings('fd', { 'function': 'MyQuickfixFindInBufferDir' })
call MyQuickfixAddMappings('ft', { 'type': 1 })
call MyQuickfixAddMappings('fn', { 'matchFilenameOnly': '1', })

nnoremap <silent><leader>// :normal <leader>fbi<cr>
nnoremap <silent><leader>*  :normal <leader>fw<cr>

" nnoremap <silent> <leader>jj :call MyQuickfixSearch({ 'path': '/tmp', 'term': '.', 'find': 1, 'grep': 0, 'orderBy': 'recent', })<cr>

nnoremap <silent> <leader>fg :let &g:errorformat = '%f' \| cgetexpr system('git diff-files --name-only --diff-filter=d') \| :copen<cr>
nnoremap <silent> <leader>jt :call Redir("!tree -C --summary --no-color --exclude node_modules", 0, 0)<cr><cr>

call MyQuickfixAddMappings('fp', { 'path': '~/src/' })
nnoremap <silent> <leader>fpp :edit ~/src/README.md<cr>

nnoremap <silent> <leader>vph :execute 'edit '
      \ . stdpath('config') . '/pack/minpac/opt/'
      \ . expand('%:t:r') . '/README.md'<cr>

nnoremap <silent> <leader>vpp :execute 'edit '
      \ . stdpath('config') . '/pack/minpac/opt/'<cr>

function! MyQuickfixOutline(location) abort
  cclose
  " let pcreDefine = substitute(&define, '^\\v', '', 'g')
  if ! exists('b:outline')
    call nb#info('b:outline not defined for filetype: ' . &filetype)
    return
  endif
  silent wall
  " let pcreDefine = RegexToPcre(b:outline)
  let pcreDefine = b:outline
  if a:location == 'bufferOnly'
    call MyQuickfixSearch({ 'term': pcreDefine, 'find': 0, 'path': expand('%:p'), 'multiline': 0, 'exact': 1})
  else
    call MyQuickfixSearch({ 'term': pcreDefine, 'find': 0, 'multiline': 0, 'exact': 1})
  endif
  call setqflist([], 'a', { 'title' : 'outline' })
  " TODO: loop over qf list to find line closest to current and set it
endfunction
nnoremap <silent> <leader>o :call MyQuickfixOutline('bufferOnly')<cr>
nnoremap <silent> <leader>O :call MyQuickfixOutline('wholeProject')<cr>

nnoremap <silent> <leader>vqq :call MyQuickfixDump()<cr>
function! MyQuickfixDump(...) abort
  call DUMP(getqflist({'all': 1}))
  keepjumps /^  "title":
  keepjumps normal! ddggjP
endfunction

nnoremap <silent> <leader>vll :call MyLoclistDump()<cr>
function! MyLoclistDump(...) abort
  call DUMP(getloclist(0, {'all': 1}))
  keepjumps /^  "title":
  keepjumps normal! ddggjP
endfunction

let g:my_quickfix#maxFilenameLength = 50
let g:my_quickfix#showDir = 0

" setqflist() has a fixed display format so it can not be used for formatting.
" This function only formats and *must* not delete entries - use a different
" function for that.
function! MyQuickfixFormat() abort
  if BufferIsLoclist()
    let qflist = getloclist(0)
  else
    let qflist = getqflist()
  endif
  setlocal modifiable
  silent! %delete _

  let foundBufnr = ''
  let first = 1
  let multipleFiles = 0
  for entry in qflist
    if first == 1
      let foundBufnr = entry.bufnr
      let first = 0
    endif
    if entry.bufnr != foundBufnr
      let multipleFiles = 1
      break
    endif
  endfor

  let foundMaxFilenameLength = 0
  let foundMaxTextLength = 0
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
    let text = ''
    if multipleFiles == 1
      let filename = basename
      if g:my_quickfix#showDir
        let filename = path
      endif
      let max = g:my_quickfix#maxFilenameLength
      if len(filename) > max
        let start = strcharpart(filename, 0, max - 13) 
        let end =   strcharpart(filename, len(filename) - 10, len(filename)) 
        let filename = start . '...' . end
      endif
      let entry._formattedFilename = filename
      if foundMaxFilenameLength < len(filename)
        let foundMaxFilenameLength = len(filename)
      endif
      if entry.text == path
        let entry.text = ''
      endif
    else
      let entry._formattedFilename = ''
      let text = entry.text
    endif
    if foundMaxTextLength < len(entry.text)
      let foundMaxTextLength = len(entry.text)
    endif
  endfor

  " if multipleFiles == 1
    let max = foundMaxFilenameLength
    if g:my_quickfix#maxFilenameLength == 0
      let max = 0
    endif

    for entry in qflist
      let filename = entry._formattedFilename
      let text = ''
      if foundMaxTextLength > 0
        let text =  substitute(entry.text, '\v[\n\r]', '', 'g')
        let filename = printf("%-" . max . "s", filename) . ' │ '
      endif
      if max == 0
        let filename = ''
      endif
      let text = filename . text
      call add(texts, text)
    endfor
  " endif

  " a lot faster to add all lines in a list sometimes (umlauts problem?)
  call append(line('$'), texts)
  keepjumps normal! "_dd
  setlocal nomodifiable
  setlocal nomodified
endfunction

function! my_quickfix#toggle(...) abort
  if g:my_quickfix#maxFilenameLength == 50
    let g:my_quickfix#showDir = 1
    let g:my_quickfix#maxFilenameLength = 300
  elseif g:my_quickfix#maxFilenameLength == 300
    let g:my_quickfix#showDir = 0
    let g:my_quickfix#maxFilenameLength = 0
  else
    let g:my_quickfix#showDir = 0
    let g:my_quickfix#maxFilenameLength = 50
  endif
  call MyQuickfixFormat()
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
  Redir set include? define? includeexpr? suffixesadd?
endfunction

function! my_quickfix#runContext() abort
	let context = getqflist({'context' : 1}).context
  if !exists('context.qftype')
    return
  endif
  let Qftype = function(context.qftype)
  call Qftype()
endfunction

