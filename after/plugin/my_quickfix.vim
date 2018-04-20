" Use for: linting, makeing, testing, formatting, finding stuff

" Always show signs column
sign define MyQuickfixSignEmpty
augroup MyQuickfixAugroupPersistentSignsColumn
  autocmd!
  autocmd BufEnter * execute 'execute ":sign place 9999 line=1
      \ name=MyQuickfixSignEmpty buffer=".bufnr("")'
augroup END

nnoremap <silent> <tab> :copen<cr>
nnoremap <silent> <s-tab> :lopen<cr>

function! MyQuickfixBufferDir() abort
  return expand("%:p:h")
endfunction

" NOTE: to ignore files but not .gitignore use a .agignore file
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
  let term = get(a:options, 'term', '')
  let find = get(a:options, 'find', '1')
  let grep = get(a:options, 'grep', '1')
  let matchBasenameOnly = get(a:options, 'matchBasenameOnly', '0')
  let orderBy = get(a:options, 'orderBy', '')
  let useIgnoreFile = get(a:options, 'useIgnoreFile', 1)

  " TODO: use some other mark
  silent! normal `a

  let term = substitute(term, '\v\..*', '.*', 'ig')
  let term = substitute(term, '\v[-_ ]+id$', '(.*id){0,1}', 'ig')

  " fuzzy search for most case variants
  let term = substitute(term, '\v[-_ ]+', '.*', 'g')
  let term = substitute(term, '\(\<\u\l\+\|\l\+\)\(\u\)', '\l\1.*\l\2', 'g')

  " call INFO('term:', term)

  let filenameTerm = term

  let project_dir = FindRootDirectory()
  if project_dir == ''
    let project_dir = MyQuickfixBufferDir()
  endif
  let path = get(a:options, 'path', project_dir)
  let path = fnamemodify(path, ':p')

  " force path to be ralative in quickfix display
  execute 'lcd' path

  if matchBasenameOnly
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

  let MyErrorformat = '%f:%l:%m,%f:%l%m,%f  %l%m,%f'
  let g:neomake_delimiter_maker = MyQuickfixToMaker('echo',
        \ MyErrorformat)
  let g:neomake_find_maker = MyQuickfixToMaker(findprg,
        \ MyErrorformat)
  let g:neomake_grep_maker = MyQuickfixToMaker(grepprg,
        \ MyErrorformat)

  execute 'Neomake! ' . makers
  " copen

  return
  if term != ''
    execute 'match Todo /\c\v' . term . '/'
  endif
  normal! j
endfunction

" TODO: use this to create a maker?:
" function! s:Rg(file_mode, args)
"   let cmd = "rg --vimgrep ".a:args
"   let custom_maker = neomake#utils#MakerFromCommand(cmd)
"   let custom_maker.name = cmd
"   let custom_maker.remove_invalid_entries = 0
"   let custom_maker.errorformat = "%f:%l:%c:%m"
"   let enabled_makers =  [custom_maker]
"   call neomake#Make(a:file_mode, enabled_makers) | echo "running: " . cmd
" endfunction
" command! -bang -nargs=* -complete=file G call s:Rg(<bang>0, <q-args>)
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
  let MyErrorformat = '%f:%l:%c:%m'
  let cmd = 'outline --filename ' . expand('%:p')
        \ . ' --filetype ' . l:filetype . ' 2>/dev/null'
  let g:neomake_outline_maker = MyQuickfixToMaker(cmd, MyErrorformat)
  silent wall
  Neomake! outline
  copen
endfunction

command! -nargs=* MyQuickfixDump call MyQuickfixDump (<f-args>)
function! MyQuickfixDump(...) abort
  call DUMP(getqflist())
endfunction

command! -nargs=* MyLoclistDump call MyLoclistDump (<f-args>)
function! MyLoclistDump(...) abort
  call DUMP(getloclist(0))
endfunction

" TODO: Populate qf with open buffers:
" from https://vi.stackexchange.com/questions/2121/how-do-i-have-buffers-listed-in-a-quickfix-window-in-vim
nnoremap <silent><leader>vb :call MyQuickfixBuffers('')<cr>
nnoremap <silent><leader>vB :call MyQuickfixBuffers('!')<cr>
function! MyQuickfixBuffers(hidden) abort
    let MyErrorformat  = '%s"%f"%s'
    cexpr execute(':buffers' . a:hidden)
    copen
endfunction

" TODO nnoremap <silent><leader>vh :call _Denite('vim_help', 'help', '', '')<cr>
function! MyQuickfixHelp(term) abort
    silent! execute 'helpgrep ' . a:term
    " silent! execute 'tag /' . a:term
    silent! copen
endfunction
command! -bang -nargs=1 -complete=file H call MyQuickfixHelp(<q-args>)

" TODO:
" TODO: screws with the buffer position
" augroup MyQuickfixAugroupTodo
"     autocmd QuickFixCmdPost * call MyQuickfixCleanQickfixlist()<cr>
" augroup END

" TODO: has to be specific to quickfix content
function! MyQuickfixCleanQickfixlist() abort
  " call MyQuickfixRemoveWhitspace()
  call MyQuickfixRemoveInvalidFiles()
  " call MyQuickfixRemoveInvalid()
  " call DUMP(getqflist())
  call MyQuickfixRemoveSomeLibs()
endfunction

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

function! MyQuickfixRemoveWhitspace() abort
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

" auto filetype qf call MyQuickfixFormat()
" TODO:
function! MyQuickfixFormat() abort
  let qflist = getqflist()
  setlocal modifiable
  %delete
  let i = -1
  for entry in qflist
    let i = i + 1
    call append(i, entry.text)
  endfor
  setlocal nomodifiable
  setlocal nomodified
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

nnoremap <silent> <leader>f <nop>
nnoremap <silent> <leader>fr :call MyQuickfixSearch({'orderBy': 'recent'})<cr>
nnoremap <silent> <leader>ff :call MyQuickfixSearch({})<cr>
vnoremap <silent> <leader>ff y:call MyQuickfixSearch({
      \ 'term': @"})<cr>
nnoremap <silent> <leader>fB :call MyQuickfixSearch({
      \ 'term': input('Search: '),
      \ 'matchBasenameOnly': 1})<cr>
nnoremap <silent> <leader>fi :call MyQuickfixSearch({
      \ 'term': input('Search: ')})<cr>
nnoremap <silent> <leader>fF :call MyQuickfixSearch({
      \ 'term': expand('%:t') })<cr>
nnoremap <silent> <leader>fai :call MyQuickfixSearch({
      \ 'useIgnoreFile': 0,
      \ 'term': input('Search: ')})<cr>
nnoremap <silent> <leader>faa yiw:call MyQuickfixSearch({
      \ 'useIgnoreFile': 0,
      \ 'term': @" })<cr>
vnoremap <silent> <leader>faa y:call MyQuickfixSearch({
      \ 'useIgnoreFile': 0,
      \ 'term': @" })<cr>

nnoremap <silent> <leader>fw mayiw:call MyQuickfixSearch({
      \ 'term': @" })<cr>
nnoremap <silent> <leader>fW mayiW:call MyQuickfixSearch({
      \ 'term': @"})<cr>
nnoremap <silent> <leader>fR yiw:call MyQuickfixSearch({
      \ 'term': '\b' . @" . '\b'})<cr>
nnoremap <silent> <leader>fRi yiw:call MyQuickfixSearch({
      \ 'term': '\b' . input('Word to search for: ') . '\b'})<cr>

nnoremap <silent> <leader>fsf yiw:call MyQuickfixSearch({
      \ 'term': @",
      \ 'path': '~/src/'})<cr>
vnoremap <silent> <leader>fsf y:call MyQuickfixSearch({
      \ 'term': @",
      \ 'path': '~/src/'})<cr>
nnoremap <silent> <leader>fsW yiW:call MyQuickfixSearch({
      \ 'term': @",
      \ 'path': '~/src/'})<cr>
nnoremap <silent> <leader>fsi :call MyQuickfixSearch({
      \ 'term': input('Search: '),
      \ 'path': '~/src/'})<cr>

nnoremap <silent> <leader>fbff :call MyQuickfixSearch({
      \ 'path': MyQuickfixBufferDir()})<cr>
nnoremap <silent> <leader>fbfi :call MyQuickfixSearch({
      \ 'term': input('Search: '),
      \ 'path': MyQuickfixBufferDir()})<cr>
nnoremap <silent> <leader>ft :call MyQuickfixSearch({
      \ 'term': 'todo'})<cr>

nnoremap <silent> <leader>fbb yiw:call MyQuickfixSearch({
      \ 'term': @",
      \ 'path': expand('%')})<cr>

nnoremap <silent> <leader>vff yiw:call MyQuickfixSearch({
      \ 'path': g:vim.etc.dir})<cr>
nnoremap <silent> <leader>vfw yiw:call MyQuickfixSearch({
      \ 'term': @",
      \ 'path': g:vim.etc.dir})<cr>
nnoremap <silent> <leader>vfi :call MyQuickfixSearch({
      \ 'term': input('Search: '),
      \ 'path': g:vim.etc.dir})<cr>

nnoremap <silent> <leader>vpff yiw:call MyQuickfixSearch({
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>vpfw yiw:call MyQuickfixSearch({
      \ 'term': @",
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>vpfi :call MyQuickfixSearch({
      \ 'term': input('Search: '),
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>vpfF :call MyQuickfixSearch({
      \ 'term': expand('%:t:r'),
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>vph :execute 'Help ' . expand('%:t:r')<cr>

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
