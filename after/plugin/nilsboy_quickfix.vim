" Use for: linting, makeing, testing, formatting, finding stuff
"
" Async plugins:
" - neomake
"   - stdin possible with neomake-autolint?
" - vim-dispatch
"   - no job-api support
" - vim-makejob
"   - no stdin support - add maybe?
" - vim-test
"   - uses vim-dispatch
" - ale
" - asyncrun
" - autoformat
"   - does not have a lot of preconfigured formatters
" - neomake-multiprocess
" see also:
" - vim-qf
" detect quickfix:
" https://www.reddit.com/r/vim/comments/5ulthc/how_would_i_detect_whether_quickfix_window_is_open/
"
" TODO include search for related snail-, camel-, etc, case
" TODO format quickfix output: https://github.com/MarcWeber/vim-addon-qf-layout
" TODO checkout quickfixsigns for resetting the signes on :colder etc
" TODO use winsaveview to prevent window resizing on copen
" TODO always close buffer of preview window - is there a plugin for that?
" TODO checkout https://github.com/stefandtw/quickfix-reflector.vim
" TODO add description to quickfix window title

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
autocmd BufEnter * execute 'sign define nilsboy_quickfixEmpty'
autocmd BufEnter * execute 'execute ":sign place 9999 line=1
     \ name=nilsboy_quickfixEmpty buffer=".bufnr("")'

let g:quickfix_mode = ''
function! s:toggleNavigationType() abort
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
      nnoremap <tab> :copen<cr>
      nnoremap <silent> <c-n> :silent! cnext<cr>
      nnoremap <silent> <c-p> :silent! cprevious<cr>
    else
      let g:quickfix_mode = 'locationlist'
      nnoremap <tab> :lopen<cr>
      nnoremap <silent> <c-n> :silent! lnext<cr>
      nnoremap <silent> <c-p> :silent! lprevious<cr>
    endif
endfunction

call nilsboy_quickfix#setNavigationType('quickfix')
nnoremap <leader>ll :call <SID>toggleNavigationType()<cr>

function! s:bufferDir() abort
  return expand("%:p:h")
endfunction

let s:ignore_file = g:vim.contrib.dir . 'ignore-files'
let s:grep_command = 'grep -inHR --exclude-from ' . s:ignore_file
if executable('ag')
  let s:grep_command = 'ag --nogroup --nocolor --column '
        \ . ' --ignore-case --all-text'
        \ . ' -p ' . s:ignore_file
endif

nnoremap <silent> <leader>ff :call <SID>search({})<cr>
vnoremap <silent> <leader>ff y:call <SID>search({
      \ 'term': @"})<cr>
nnoremap <silent> <leader>fB :call <SID>search({
      \ 'term': input('Search: '),
      \ 'matchBasenameOnly': 1})<cr>

nnoremap <silent> <leader>fw yiw:call <SID>search({
      \ 'term': @" })<cr>
nnoremap <silent> <leader>fr yiw:call <SID>search({
      \ 'term': '\b' . @" . '\b'})<cr>
nnoremap <silent> <leader>fW yiW:call <SID>search({
      \ 'term': @"})<cr>
nnoremap <silent> <leader>fi :call <SID>search({
      \ 'term': input('Search: ')})<cr>

nnoremap <silent> <leader>fsf yiw:call <SID>search({
      \ 'term': @",
      \ 'path': '~/src/'})<cr>
vnoremap <silent> <leader>fsf y:call <SID>search({
      \ 'term': @", 
      \ 'path': '~/src/'})<cr>
nnoremap <silent> <leader>fsW yiW:call <SID>search({
      \ 'term': @", 
      \ 'path': '~/src/'})<cr>
nnoremap <silent> <leader>fsi :call <SID>search({
      \ 'term': input('Search: '), 
      \ 'path': '~/src/'})<cr>

nnoremap <silent> <leader>fd :call <SID>search({
      \ 'path': <SID>bufferDir()})<cr>
nnoremap <silent> <leader>fdi :call <SID>search({
      \ 'term': input('Search: '),
      \ 'path': <SID>bufferDir()})<cr>
nnoremap <silent> <leader>ft :call <SID>search({
      \ 'term': 'todo'})<cr>

" nnoremap <silent> <leader>fb yiw:call <SID>search({
"       \ 'term': @", 
"       \ 'path': expand('%:p'),
"       \ 'find': 0})<cr>

" Search for keyword under cursor
nmap <silent> <leader>fb [I

nnoremap <silent> <leader>fvf yiw:call <SID>search({
      \ 'path': g:vim.etc.dir})<cr>
nnoremap <silent> <leader>fvw yiw:call <SID>search({
      \ 'term': @", 
      \ 'path': g:vim.etc.dir})<cr>
nnoremap <silent> <leader>fvi :call <SID>search({
      \ 'term': input('Search: '), 
      \ 'path': g:vim.etc.dir})<cr>

nnoremap <silent> <leader>fvpf yiw:call <SID>search({
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>fvpw yiw:call <SID>search({
      \ 'term': @", 
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>fvpi :call <SID>search({
      \ 'term': input('Search: '), 
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>fvpt :call <SID>search({
      \ 'term': expand('%:t:r'),
      \ 'path': g:vim.bundle.dir})<cr>

nnoremap <silent> <leader>df :call <SID>search({
      \ 'path': $HOME . '/src/sql/'})<cr>

let s:searchType = 'all'
let s:searchLimit = '500'
nnoremap <leader>fSS :call <SID>setVar('searchType', 'all')<cr>
nnoremap <leader>fSf :call <SID>setVar('searchType', 'files')<cr>
nnoremap <leader>fSg :call <SID>setVar('searchType', 'grep')<cr>
nnoremap <leader>fSl :call <SID>toggleVar('searchLimit', '500', '')<cr>

function! s:toggleVar(var, value1, value2) abort
  execute 'let current = s:' . a:var
  let next = a:value1
  if current == a:value1
    let next = a:value2
  endif
  execute 'let s:' . a:var . ' = "' . next . '"'
  call INFO('Setting ' . a:var . ' to: ' . next)
endfunction

function! s:setVar(var, value) abort
  execute 'let s:' . a:var . ' = "' . a:value . '"'
  call INFO('Setting ' . a:var . ' to: ' . a:value)
endfunction

command! -bang -nargs=1 Search call <SID>search({'term': <q-args>})
function! s:search(options) abort
  let term = get(a:options, 'term', '')
  let find = get(a:options, 'find', '1')
  let grep = get(a:options, 'grep', '1')
  let matchBasenameOnly = get(a:options, 'matchBasenameOnly', '0')

  let findTerm = term
  if matchBasenameOnly
    let findTerm = '\/.*' . term . '[^/]*$'
  endif

  let project_dir = FindRootDirectory()
  if project_dir == ''
    let project_dir = s:bufferDir()
  endif
  let path = get(a:options, 'path', project_dir)
  let path = fnamemodify(path, ':p')

  if term != ''
    call INFO('Searching for ' . term . ' in ' . path)
  endif

  let grepprg = s:grep_command

  let limit = ''
  if s:searchLimit
    let limit = ' -' . s:searchLimit
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

  " TODO: check if add to qf can be intercepted and input stopped 
  " after a certain amount of lines

  call nilsboy_quickfix#setNavigationType('quickfix')
  let &l:errorformat="%f:%l:%m,%f:%l%m,%f  %l%m,%f"

  let &l:makeprg = ''

  if find
    if s:searchType =~ '\v(files|all)'
      let &l:makeprg .= findprg
    endif
  endif

  if grep
    if s:searchType =~ '\v(grep|all)'
      if term != ''
        let &l:makeprg .= ' ; ' . grepprg
      endif
    endif
  endif

  Neomake!
  copen
  if term != ''
    execute 'match Todo /\c\v' . term . '/'
  endif
endfunction

nnoremap <leader>o :call <SID>outline()<cr>
function! s:outline() abort
  let l:filetype = &filetype
  if exists("b:filetype")
    let l:filetype = b:filetype
  endif
  setlocal errorformat=%f:%l:%c:%m
  wall
  let &l:makeprg='outline --filename ' . expand('%:p') 
        \ . ' --filetype ' . l:filetype . ' 2>/dev/null'
  :Neomake!
  copen
endfunction

" TODO
" Populate qf with open buffers:
" from https://vi.stackexchange.com/questions/2121/how-do-i-have-buffers-listed-in-a-quickfix-window-in-vim
nnoremap <silent><leader>vb :call <SID>buffers('')<cr>
nnoremap <silent><leader>vB :call <SID>buffers('!')<cr>
function! s:buffers(hidden) abort
    call nilsboy_quickfix#setNavigationType('quickfix')
    setlocal errorformat=%s"%f"%s
    cexpr execute(':buffers' . a:hidden)
    copen
endfunction

" http://dhruvasagar.com/2013/12/17/vim-filter-quickfix-list
function! s:FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~?' : '=~?'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) "
        \ . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file QFilter call s:FilterQuickfixList(<bang>0, <q-args>)

" TODO nnoremap <silent><leader>vh :call _Denite('vim_help', 'help', '', '')<cr>
function! s:help(term) abort
    call nilsboy_quickfix#setNavigationType('locationlist')
    help
    silent! execute 'ltag /' . a:term
    silent! lopen
endfunction
command! -bang -nargs=1 -complete=file H call s:help(<q-args>)

function! nilsboy_quickfix#removeInvalid() abort
    call setqflist(filter(copy(getqflist()), 'v:val.valid == 1'))
endfunction

finish

augroup s:quickfix
    " QuickFixCmd* Does not match :ltag
    autocmd QuickFixCmdPost [^l]* nnoremap <tab> :copen<cr>
    autocmd QuickFixCmdPost [^l]* botright copen
    autocmd QuickFixCmdPost [^l]* let b:isQuickfix = 1
    autocmd QuickFixCmdPost    l* nnoremap <tab> :lopen<cr>
    autocmd QuickFixCmdPost    l* botright lopen
augroup END

" augroup my_qf_autoformat
"   autocmd!
"   autocmd InsertLeave *.js :call FFormat()
" augroup END

" TODO
nnoremap <silent> <leader>fp :call <SID>findInPath('')<cr>
function! s:findInPath(term) abort
    call nilsboy_quickfix#setNavigationType('quickfix')

    " Make sure the quickfix cwd isn't used as starting directory
    cclose

    let &l:makeprg="compgen -c \| sort -u"
    setlocal errorformat=%f
    Neomake!
    copen
    let b:quickfix_action = ':echo "haha"'
endfunction

finish

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
"       call <SID>grep({'term': @x})
"     endfunction

"   endfunction
"   call neobundle#untap()
" endif

" map <leader>g  <Plug>(operator-grep)
" map <leader>gs  <Plug>(operator-grep)

" function! s:find(term, directory) abort
"     call nilsboy_quickfix#setNavigationType('quickfix')

"     " Make sure the quickfix cwd isn't used as starting directory
"     cclose

"     call s:Cd(a:directory)
"     let &l:makeprg="find-and-limit\ " . shellescape(a:term)
"     setlocal errorformat=%f
"     Neomake!
"     copen
" endfunction

" TODO: does not work?
"       nnoremap <silent> <c-;> :silent! lnext<cr>
"       nnoremap <silent> <c-,> :silent! lprevious<cr>

function! AfterFormat(...) abort
    " does not reload otherwise
    silent! edit
endfunction

" nnoremap <silent> <leader>x :call FFormat()<cr>
function! FFormat() abort
    if ! exists('b:formatprg')
        return
    endif
    write
    call neomake#Sh(b:formatprg, 'AfterFormat')
endfunction

command! -bang -nargs=1 FormatterSet call <SID>FormatterSet(<q-args>)
function! s:FormatterSet(formatterName) abort
    execute 'compiler ' . a:formatterName
endfunction

function! s:Cd(directory) abort
    if a:directory == ''
    elseif a:directory == 'project'
      call CdProjectRoot()
    elseif a:directory == 'project/..'
      call CdProjectRoot()
      lcd ..
    elseif a:directory == 'buffer_dir'
      execute "lcd" expand("%:p:h")
    else
      execute "lcd" a:directory
    endif
endfunction

