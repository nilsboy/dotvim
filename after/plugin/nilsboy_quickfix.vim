" Use for: linting, makeing, testing, formatting, finding stuff

" TODO: word with boundaries search
" TODO: and search
" TODO include search for related snail-, camel-, etc, case
" TODO: highlight lines with errors: https://github.com/mh21/errormarker.vim
" TODO format quickfix output: https://github.com/MarcWeber/vim-addon-qf-layout
" TODO checkout quickfixsigns for resetting the signes on :colder etc
" TODO use winsaveview to prevent window resizing on copen
" TODO always close buffer of preview window - is there a plugin for that?
" TODO checkout https://github.com/stefandtw/quickfix-reflector.vim
" TODO add description to quickfix window title

" TODO: desc naming conventions

" See also: 
" :Man scanf
" :h quickfix
" :h errorformat
" - For errorformat debugging see:
" :h neomake
" section: 6.3 How to develop/debug the errorformat setting?
" To send to stdin see:
" :h jobsend()

" Notes
" - every line of output from makeprg is listed as an error
" - lines that match errorformat get a valid = 1 in the getqflist()
" - get count of actual errors: len(filter(getqflist(), 'v:val.valid'))
" - see h :signs for the gutter
" - List all defined signs and their attributes:
" :sign list
" - List placed signs in all files:
" :sign place
" Clear quickfix: :cex[]

" Always show signs column
augroup augroup_nilsboy_quickfix
  autocmd!
  autocmd BufEnter * execute 'sign define nilsboy_quickfixEmpty'
  autocmd BufEnter * execute 'execute ":sign place 9999 line=1
      \ name=nilsboy_quickfixEmpty buffer=".bufnr("")'
augroup END

let g:quickfix_mode = ''
function! nilsboy_quickfix#toggleNavigationType() abort
    if g:quickfix_mode == 'quickfix'
      silent call nilsboy_quickfix#setNavigationType('locationlist')
      call INFO("Locationlist navigation activated")
    else
      silent call nilsboy_quickfix#setNavigationType('quickfix')
      call INFO("Quickfix navigation activated")
    endif
endfunction

" TODO make mappings move through lists by history
function! nilsboy_quickfix#setNavigationType(type) abort
    if a:type == 'quickfix'
      let g:quickfix_mode = 'quickfix'
      nnoremap <silent> <tab> :copen<cr>
      nnoremap <silent> <c-n> :silent! cnext<cr>
      nnoremap <silent> <c-p> :silent! cprevious<cr>
    else
      let g:quickfix_mode = 'locationlist'
      nnoremap <silent> <tab> :lopen<cr>
      nnoremap <silent> <c-n> :silent! lnext<cr>
      nnoremap <silent> <c-p> :silent! lprevious<cr>
    endif
endfunction

call nilsboy_quickfix#setNavigationType('quickfix')
nnoremap <leader>gl :call nilsboy_quickfix#toggleNavigationType()<cr>

function! nilsboy_quickfix#bufferDir() abort
  return expand("%:p:h")
endfunction

let g:nilsboy_quickfix_ignore_file = g:vim.contrib.etc.dir . 'ignore-files'
let g:nilsboy_quickfix_grep_command = 'grep -inHR --exclude-from ' . g:nilsboy_quickfix_ignore_file
if executable('ag')
  let g:nilsboy_quickfix_grep_command = 'ag --nogroup --nocolor --column '
        \ . ' --ignore-case --all-text'
        \ . ' -p ' . g:nilsboy_quickfix_ignore_file
  " TODO: add --smart-case option?
  " TODO: --word-regexp:
endif

let g:nilsboy_quickfix_searchLimit = '500'

command! -bang -nargs=1 Search call nilsboy_quickfix#search({'term': <q-args>})
function! nilsboy_quickfix#search(options) abort
  let term = get(a:options, 'term', '')
  let find = get(a:options, 'find', '1')
  let grep = get(a:options, 'grep', '1')
  let matchBasenameOnly = get(a:options, 'matchBasenameOnly', '0')

  let findTerm = term

  let project_dir = FindRootDirectory()
  if project_dir == ''
    let project_dir = nilsboy_quickfix#bufferDir()
  endif
  let path = get(a:options, 'path', project_dir)
  let path = fnamemodify(path, ':p')

  if matchBasenameOnly
    let findTerm = '\/.*' . term . '[^/]*$'
  else
    " exclude current path from file match
    let findTerm = '\Q' . fnameescape(path) . '\E' . '.*' . findTerm
  endif

  let grepprg = g:nilsboy_quickfix_grep_command

  let limit = ''
  if g:nilsboy_quickfix_searchLimit
    let limit = ' -' . g:nilsboy_quickfix_searchLimit
  endif

  " /dev/null forces absolute paths if greping a single file
  let findprg = grepprg
        \ . ' -g ' . shellescape(findTerm)
        \ . ' ' . fnameescape(path) 
        \ . ' /dev/null'
        \ . ' | head-warn ' . limit
        \ . ' | sort-by-path-depth'

  let grepprg .= ' ' . shellescape(term) . ' ' . fnameescape(path)
        \ . ' /dev/null'
        \ . ' | head-warn ' . limit

  call nilsboy_quickfix#setNavigationType('quickfix')
  let my_errorformat = '%f:%l:%m,%f:%l%m,%f  %l%m,%f'

  let makers = 'find'
  if term != ''
    let makers .= ' delimiter grep'
  endif

  let g:neomake_delimiter_maker = nilsboy_quickfix#toMaker('echo',
        \ my_errorformat)
  let g:neomake_find_maker = nilsboy_quickfix#toMaker(findprg,
        \ my_errorformat)
  let g:neomake_grep_maker = nilsboy_quickfix#toMaker(grepprg,
        \ my_errorformat)

  execute 'Neomake! ' . makers
  copen

  return
  if term != ''
    execute 'match Todo /\c\v' . term . '/'
  endif
  normal! j
endfunction

function! nilsboy_quickfix#toMaker(cmd, errorformat) abort
  let cmd = a:cmd
  let exe = substitute(cmd, '\s.*', '', 'g')
  let args = substitute(cmd, '^\w\+\s*', '', 'g')
  return {
      \ 'exe' : exe,
      \ 'args': args,
      \ 'errorformat': a:errorformat 
      \ }
endfunction

nnoremap <leader>o :call nilsboy_quickfix#outline()<cr>
function! nilsboy_quickfix#outline() abort
  let l:filetype = &filetype
  if exists("b:filetype")
    let l:filetype = b:filetype
  endif
  let my_errorformat = '%f:%l:%c:%m'
  let cmd = 'outline --filename ' . expand('%:p') 
        \ . ' --filetype ' . l:filetype . ' 2>/dev/null'
  let g:neomake_outline_maker = nilsboy_quickfix#toMaker(cmd, my_errorformat)
  silent wall
  Neomake! outline
  copen
endfunction

" TODO: Populate qf with open buffers:
" from https://vi.stackexchange.com/questions/2121/how-do-i-have-buffers-listed-in-a-quickfix-window-in-vim
nnoremap <silent><leader>vb :call nilsboy_quickfix#buffers('')<cr>
nnoremap <silent><leader>vB :call nilsboy_quickfix#buffers('!')<cr>
function! nilsboy_quickfix#buffers(hidden) abort
    call nilsboy_quickfix#setNavigationType('quickfix')
    let my_errorformat  = '%s"%f"%s'
    cexpr execute(':buffers' . a:hidden)
    copen
endfunction

" http://dhruvasagar.com/2013/12/17/vim-filter-quickfix-list
function! nilsboy_quickfix#FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~?' : '=~?'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) "
        \ . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file QFilter call nilsboy_quickfix#FilterQuickfixList(<bang>0, <q-args>)

" TODO nnoremap <silent><leader>vh :call _Denite('vim_help', 'help', '', '')<cr>
function! nilsboy_quickfix#help(term) abort
    call nilsboy_quickfix#setNavigationType('quickfix')
    silent! execute 'helpgrep ' . a:term
    " silent! execute 'tag /' . a:term
    silent! copen
endfunction
command! -bang -nargs=1 -complete=file H call nilsboy_quickfix#help(<q-args>)

function! nilsboy_quickfix#removeInvalid() abort
    call setqflist(filter(copy(getqflist()), 'v:val.valid == 1'))
endfunction

nnoremap <silent> <leader>f <nop>
nnoremap <silent> <leader>ff :call nilsboy_quickfix#search({})<cr>
vnoremap <silent> <leader>ff y:call nilsboy_quickfix#search({
      \ 'term': @"})<cr>
nnoremap <silent> <leader>fB :call nilsboy_quickfix#search({
      \ 'term': input('Search: '),
      \ 'matchBasenameOnly': 1})<cr>

nnoremap <silent> <leader>fw yiw:call nilsboy_quickfix#search({
      \ 'term': @" })<cr>
nnoremap <silent> <leader>fr yiw:call nilsboy_quickfix#search({
      \ 'term': '\b' . @" . '\b'})<cr>
nnoremap <silent> <leader>fW yiW:call nilsboy_quickfix#search({
      \ 'term': @"})<cr>
nnoremap <silent> <leader>fi :call nilsboy_quickfix#search({
      \ 'term': input('Search: ')})<cr>

nnoremap <silent> <leader>fsf yiw:call nilsboy_quickfix#search({
      \ 'term': @",
      \ 'path': '~/src/'})<cr>
vnoremap <silent> <leader>fsf y:call nilsboy_quickfix#search({
      \ 'term': @", 
      \ 'path': '~/src/'})<cr>
nnoremap <silent> <leader>fsW yiW:call nilsboy_quickfix#search({
      \ 'term': @", 
      \ 'path': '~/src/'})<cr>
nnoremap <silent> <leader>fsi :call nilsboy_quickfix#search({
      \ 'term': input('Search: '), 
      \ 'path': '~/src/'})<cr>

nnoremap <silent> <leader>fd :call nilsboy_quickfix#search({
      \ 'path': nilsboy_quickfix#bufferDir()})<cr>
nnoremap <silent> <leader>fdi :call nilsboy_quickfix#search({
      \ 'term': input('Search: '),
      \ 'path': nilsboy_quickfix#bufferDir()})<cr>
nnoremap <silent> <leader>ft :call nilsboy_quickfix#search({
      \ 'term': 'todo'})<cr>

" Search for keyword under cursor
nmap <silent> <leader>fb [I

nnoremap <silent> <leader>fvf yiw:call nilsboy_quickfix#search({
      \ 'path': g:vim.etc.dir})<cr>
nnoremap <silent> <leader>fvw yiw:call nilsboy_quickfix#search({
      \ 'term': @", 
      \ 'path': g:vim.etc.dir})<cr>
nnoremap <silent> <leader>fvi :call nilsboy_quickfix#search({
      \ 'term': input('Search: '), 
      \ 'path': g:vim.etc.dir})<cr>

nnoremap <silent> <leader>fvpf yiw:call nilsboy_quickfix#search({
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>fvpw yiw:call nilsboy_quickfix#search({
      \ 'term': @", 
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>fvpi :call nilsboy_quickfix#search({
      \ 'term': input('Search: '), 
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>vpf :call nilsboy_quickfix#search({
      \ 'term': expand('%:t:r'),
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>vph :execute 'Help ' . expand('%:t:r')<cr>

nnoremap <silent> <leader>df :call nilsboy_quickfix#search({
      \ 'path': $HOME . '/src/sql/'})<cr>

finish " #######################################################################

augroup nilsboy_quickfix_todo
    " QuickFixCmd* Does not match :ltag
    autocmd QuickFixCmdPost [^l]* nnoremap <tab> :copen<cr>
    autocmd QuickFixCmdPost [^l]* botright copen
    autocmd QuickFixCmdPost [^l]* let b:isQuickfix = 1
    autocmd QuickFixCmdPost    l* nnoremap <tab> :lopen<cr>
    autocmd QuickFixCmdPost    l* botright lopen
augroup END

" " TODO
" if len(getqflist()) > 0
"   " Quickfix error count
"   set statusline+=%{len(filter(getqflist(),'v:val.valid'))}
"   set statusline+=%{'/'}
"   set statusline+=%{len(getqflist())}
" endif

" if neobundle#tap('vim-operator-user') 
"   function! neobundle#hooks.on_post_source(bundle) abort

"     call operator#user#define('grep', 'OpGrep')
"     function! OpGrep(motion_wise)
" 	    let v = operator#user#visual_command_from_wise_name(a:motion_wise)
" 	    execute 'normal!' '`[' . v . '`]"xy'
"       " call INFO('X: ', getreg(operator#user#register()))
"       call nilsboy_quickfix#search({'term': @x})
"     endfunction

"   endfunction
"   call neobundle#untap()
" endif

" map <leader>g  <Plug>(operator-grep)
" map <leader>gs  <Plug>(operator-grep)

