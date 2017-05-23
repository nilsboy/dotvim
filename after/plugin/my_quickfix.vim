" Use for: linting, makeing, testing, formatting, finding stuff

" Related plugins:
" - make (builtin)
"   - synchronous
"   - TODO: set makeef
" - neomake
"   - stdin possible with neomake-autolint?
"   - does mess with &makeprg / &errorformat and not respect buffer local
"   - only used it as regular make - makes no difference to buildin :make
"   versions of those?
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
" - detect quickfix:
"   https://www.reddit.com/r/vim/comments/5ulthc/how_would_i_detect_whether_quickfix_window_is_open/
" - async.vim:
"   https://github.com/prabirshrestha/async.vim

" See also: 
" :Man scanf
" :h quickfix
" :h errorformat
" - For errorformat debugging see:
" :h neomake
" section: 6.3 How to develop/debug the errorformat setting?
" To send to stdin see:
" :h jobsend()

" Note: :compiler is only meant to be used for one tool/buffer at a time - 
" is not possible to have several commands e.g. linter, finder, formatter
" see also: https://github.com/LucHermitte/vim-build-tools-wrapper/blob/master/doc/filter.md
" Note: makeprg and errorformat are ether local or global but if you want to
" run something different than the default with make those vars have to be
" saved and restored
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
" TODO: add error count to statusline (see neomake)

" Always show signs column
augroup My_quickfix_augroup_signs_column
  autocmd!
  autocmd BufEnter * execute 'sign define My_quickfix_empty'
  autocmd BufEnter * execute 'execute ":sign place 9999 line=1
      \ name=My_quickfix_empty buffer=".bufnr("")'
augroup END

let g:My_quickfix_mode = ''

" TODO make mappings move through lists by history
function! My_quickfix_setNavigationType(type) abort
    if a:type == 'quickfix'
      call INFO("Quickfix navigation activated")
      let g:My_quickfix_mode = 'quickfix'
      nnoremap <silent> <tab> :copen<cr>
      nnoremap <silent> <c-n> :silent! cnext<cr>
      nnoremap <silent> <c-p> :silent! cprevious<cr>
    else
      call INFO("Locationlist navigation activated")
      let g:My_quickfix_mode = 'locationlist'
      nnoremap <silent> <tab> :lopen<cr>
      nnoremap <silent> <c-n> :silent! lnext<cr>
      nnoremap <silent> <c-p> :silent! lprevious<cr>
    endif
endfunction

function! My_quickfix_toggleNavigationType() abort
    if g:My_quickfix_mode != 'quickfix'
      silent! lclose
      silent call My_quickfix_setNavigationType('quickfix')
    else
      silent! cclose
      silent call My_quickfix_setNavigationType('locationlist')
    endif
endfunction

" TODO: call My_quickfix_setNavigationType('quickfix')
nnoremap <leader>gl :call My_quickfix_toggleNavigationType()<cr>

function! My_quickfix_bufferDir() abort
  return expand("%:p:h")
endfunction

let g:My_quickfix_ignore_file = g:vim.contrib.etc.dir . 'ignore-files'
let g:My_quickfix_grep_command = 'grep -inHR --exclude-from ' . g:My_quickfix_ignore_file
if executable('ag')
  let g:My_quickfix_grep_command = 'ag --nogroup --nocolor --column '
        \ . ' --ignore-case --all-text'
        \ . ' -p ' . g:My_quickfix_ignore_file
  " TODO: add --smart-case option?
  " TODO: --word-regexp:
endif

let g:My_quickfix_searchLimit = '500'

command! -bang -nargs=1 Search call My_quickfix_search({'term': <q-args>})
function! My_quickfix_search(options) abort
  let term = get(a:options, 'term', '')
  let find = get(a:options, 'find', '1')
  let grep = get(a:options, 'grep', '1')
  let matchBasenameOnly = get(a:options, 'matchBasenameOnly', '0')

  let findTerm = term

  let project_dir = FindRootDirectory()
  if project_dir == ''
    let project_dir = My_quickfix_bufferDir()
  endif
  let path = get(a:options, 'path', project_dir)
  let path = fnamemodify(path, ':p')

  if matchBasenameOnly
    let findTerm = '\/.*' . term . '[^/]*$'
  else
    " exclude current path from file match
    let findTerm = '\Q' . fnameescape(path) . '\E' . '.*' . findTerm
  endif

  let grepprg = g:My_quickfix_grep_command

  let limit = ''
  if g:My_quickfix_searchLimit
    let limit = ' -' . g:My_quickfix_searchLimit
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

  call My_quickfix_setNavigationType('quickfix')

  let makers = 'find'
  if term != ''
    let makers .= ' delimiter grep'
  endif

  let my_errorformat = '%f:%l:%m,%f:%l%m,%f  %l%m,%f'
  let g:neomake_delimiter_maker = My_quickfix_toMaker('echo',
        \ my_errorformat)
  let g:neomake_find_maker = My_quickfix_toMaker(findprg,
        \ my_errorformat)
  let g:neomake_grep_maker = My_quickfix_toMaker(grepprg,
        \ my_errorformat)

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
function! My_quickfix_toMaker(cmd, errorformat) abort
  let cmd = a:cmd
  let exe = substitute(cmd, '\s.*', '', 'g')
  let args = substitute(cmd, '^\w\+\s*', '', 'g')
  return {
      \ 'exe' : exe,
      \ 'args': args,
      \ 'errorformat': a:errorformat 
      \ }
endfunction

nnoremap <silent><leader>o :call My_quickfix_outline()<cr>
function! My_quickfix_outline() abort
  let l:filetype = &filetype
  if exists("b:filetype")
    let l:filetype = b:filetype
  endif
  let my_errorformat = '%f:%l:%c:%m'
  let cmd = 'outline --filename ' . expand('%:p') 
        \ . ' --filetype ' . l:filetype . ' 2>/dev/null'
  let g:neomake_outline_maker = My_quickfix_toMaker(cmd, my_errorformat)
  silent wall
  Neomake! outline
  copen
endfunction

" TODO: Populate qf with open buffers:
" from https://vi.stackexchange.com/questions/2121/how-do-i-have-buffers-listed-in-a-quickfix-window-in-vim
nnoremap <silent><leader>vb :call My_quickfix_buffers('')<cr>
nnoremap <silent><leader>vB :call My_quickfix_buffers('!')<cr>
function! My_quickfix_buffers(hidden) abort
    call My_quickfix_setNavigationType('quickfix')
    let my_errorformat  = '%s"%f"%s'
    cexpr execute(':buffers' . a:hidden)
    copen
endfunction

" http://dhruvasagar.com/2013/12/17/vim-filter-quickfix-list
function! My_quickfix_FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~?' : '=~?'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) "
        \ . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file QFilter call My_quickfix_FilterQuickfixList(<bang>0, <q-args>)

" TODO nnoremap <silent><leader>vh :call _Denite('vim_help', 'help', '', '')<cr>
function! My_quickfix_help(term) abort
    call My_quickfix_setNavigationType('quickfix')
    silent! execute 'helpgrep ' . a:term
    " silent! execute 'tag /' . a:term
    silent! copen
endfunction
command! -bang -nargs=1 -complete=file H call My_quickfix_help(<q-args>)

function! My_quickfix_removeInvalid() abort
    call setqflist(filter(copy(getqflist()), 'v:val.valid == 1'))
endfunction

nnoremap <silent> <leader>f <nop>
nnoremap <silent> <leader>ff :call My_quickfix_search({})<cr>
vnoremap <silent> <leader>ff y:call My_quickfix_search({
      \ 'term': @"})<cr>
nnoremap <silent> <leader>fB :call My_quickfix_search({
      \ 'term': input('Search: '),
      \ 'matchBasenameOnly': 1})<cr>

nnoremap <silent> <leader>fw yiw:call My_quickfix_search({
      \ 'term': @" })<cr>
nnoremap <silent> <leader>fr yiw:call My_quickfix_search({
      \ 'term': '\b' . @" . '\b'})<cr>
nnoremap <silent> <leader>fW yiW:call My_quickfix_search({
      \ 'term': @"})<cr>
nnoremap <silent> <leader>fi :call My_quickfix_search({
      \ 'term': input('Search: ')})<cr>

nnoremap <silent> <leader>fsf yiw:call My_quickfix_search({
      \ 'term': @",
      \ 'path': '~/src/'})<cr>
vnoremap <silent> <leader>fsf y:call My_quickfix_search({
      \ 'term': @", 
      \ 'path': '~/src/'})<cr>
nnoremap <silent> <leader>fsW yiW:call My_quickfix_search({
      \ 'term': @", 
      \ 'path': '~/src/'})<cr>
nnoremap <silent> <leader>fsi :call My_quickfix_search({
      \ 'term': input('Search: '), 
      \ 'path': '~/src/'})<cr>

nnoremap <silent> <leader>fd :call My_quickfix_search({
      \ 'path': My_quickfix_bufferDir()})<cr>
nnoremap <silent> <leader>fdi :call My_quickfix_search({
      \ 'term': input('Search: '),
      \ 'path': My_quickfix_bufferDir()})<cr>
nnoremap <silent> <leader>ft :call My_quickfix_search({
      \ 'term': 'todo'})<cr>

" Search for keyword under cursor
nmap <silent> <leader>fb [I

nnoremap <silent> <leader>fvf yiw:call My_quickfix_search({
      \ 'path': g:vim.etc.dir})<cr>
nnoremap <silent> <leader>fvw yiw:call My_quickfix_search({
      \ 'term': @", 
      \ 'path': g:vim.etc.dir})<cr>
nnoremap <silent> <leader>fvi :call My_quickfix_search({
      \ 'term': input('Search: '), 
      \ 'path': g:vim.etc.dir})<cr>

nnoremap <silent> <leader>fvpf yiw:call My_quickfix_search({
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>fvpw yiw:call My_quickfix_search({
      \ 'term': @", 
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>fvpi :call My_quickfix_search({
      \ 'term': input('Search: '), 
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>vpf :call My_quickfix_search({
      \ 'term': expand('%:t:r'),
      \ 'path': g:vim.bundle.dir})<cr>
nnoremap <silent> <leader>vph :execute 'Help ' . expand('%:t:r')<cr>

nnoremap <silent> <leader>df :call My_quickfix_search({
      \ 'path': $HOME . '/src/sql/'})<cr>

finish " #######################################################################

augroup My_quickfix_augroup_todo
    " QuickFixCmd* Does not match :ltag
    autocmd QuickFixCmdPost [^l]* nnoremap <tab> :copen<cr>
    autocmd QuickFixCmdPost [^l]* botright copen
    autocmd QuickFixCmdPost [^l]* let b:isQuickfix = 1
    autocmd QuickFixCmdPost    l* nnoremap <tab> :lopen<cr>
    autocmd QuickFixCmdPost    l* botright lopen
augroup END

" if neobundle#tap('vim-operator-user') 
"   function! neobundle#hooks.on_post_source(bundle) abort

"     call operator#user#define('grep', 'OpGrep')
"     function! OpGrep(motion_wise)
" 	    let v = operator#user#visual_command_from_wise_name(a:motion_wise)
" 	    execute 'normal!' '`[' . v . '`]"xy'
"       " call INFO('X: ', getreg(operator#user#register()))
"       call My_quickfix_search({'term': @x})
"     endfunction

"   endfunction
"   call neobundle#untap()
" endif

" map <leader>g  <Plug>(operator-grep)
" map <leader>gs  <Plug>(operator-grep)

