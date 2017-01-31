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
"
" TODO checkout quickfixsigns for resetting the signes on :colder etc
" TODO use winsaveview to prevent window resizing on copen
" TODO always close buffer of preview window - is there a plugin for that?
" TODO checkout https://github.com/stefandtw/quickfix-reflector.vim

" See also: 
" :Man scanf
" :h quickfix
" :h errorformat
" - For errorformat debugging see:
" :h neomake
" section: 6.3 How to develop/debug the errorformat setting?
" TODO Format quickfix output: https://github.com/MarcWeber/vim-addon-qf-layout
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
      echo "Locationlist navigation activated"
    else
      silent call nilsboy_quickfix#setNavigationType('quickfix')
      echo "Quickfix navigation activated"
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

" augroup my_qf_autoformat
"   autocmd!
"   autocmd InsertLeave *.js :call FFormat()
" augroup END

call nilsboy_quickfix#setNavigationType('quickfix')
nnoremap <leader>ll :call <SID>toggleNavigationType()<cr>

nnoremap <silent> <leader>ff :call <SID>find('', 'project')<cr>
vnoremap <silent> <leader>ff y:call <SID>find(@", 'project')<cr>
nnoremap <silent> <leader>fd :call <SID>find('', 'buffer_dir')<cr>
nnoremap <silent> <leader>fw yiw:call <SID>find(@", 'project')<cr>
nnoremap <silent> <leader>fW yiW:call <SID>find(@", 'project')<cr>
nnoremap <silent> <leader>fi :call <SID>find(input('File name: '), 'project')<cr>
nnoremap <silent> <leader>fs :call <SID>find(input('File name: '), '~/src')<cr>

nnoremap <silent> <leader>vff :call <SID>find('', g:vim.etc.dir)<cr>
nnoremap <silent> <leader>vfi :call <SID>find(input('File name in vim config: '), g:vim.etc.dir)<cr>

nnoremap <silent> <leader>vpff :call <SID>find('', g:vim.bundle.dir)<cr>
nnoremap <silent> <leader>vpfi :call <SID>find(input('File name in plugins: '), g:vim.bundle.dir)<cr>

function! s:find(term, directory) abort
    call nilsboy_quickfix#setNavigationType('quickfix')

    " Make sure the quickfix cwd isn't used as starting directory
    cclose

    call s:Cd(a:directory)
    let &l:makeprg="find-and-limit\ " . escape(a:term, '<>$ "')
    setlocal errorformat=%f
    Neomake!
    copen
endfunction

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

let s:grep_command = 'grep -inHR'
if executable('ag')
  let s:grep_command = 'ag --nogroup --nocolor --column --ignore-case --all-text'
endif

nnoremap <leader>gg yiw:call <SID>grep(@", '')<cr>
vnoremap <leader>gg y:call <SID>grep(@", '')<cr>
nnoremap <leader>gW yiW:call <SID>grep(@", '')<cr>
nnoremap <leader>gi :call <SID>grep(input('Grep for: '), '')<cr>
nnoremap <leader>gpi :call <SID>grep(input('Grep for: '), 'project/..')<cr>
nnoremap <leader>gpg yiw:call <SID>grep(@", 'project/..')<cr>
nnoremap <leader>gs :call <SID>grep(input('Grep for: '), '~/src/')<cr>
nnoremap <leader>gf yiw:call <SID>grep(@", '', expand('%'))<cr>

nnoremap <leader>vgi :call <SID>grep(input('Grep vim for: '), g:vim.etc.dir)<cr>
nnoremap <leader>vgg yiw:call <SID>grep(@", g:vim.etc.dir)<cr>

nnoremap <leader>vpgi :call <SID>grep(input('Grep for: '), g:vim.bundle.dir)<cr>
nnoremap <leader>vpgg yiw:call <SID>grep(@", g:vim.bundle.dir)<cr>

command! -bang -nargs=1 Grep call <SID>grep(<q-args>, '')
function! s:grep(term, directory, ...) abort
    let l:path = ''
    if exists('a:1')
        " add /dev/null to force result with filename
        let l:path = ' /dev/null ' . a:1
    endif
    call nilsboy_quickfix#setNavigationType('quickfix')
    call s:Cd(a:directory)
    let &l:makeprg=s:grep_command . ' ' . escape(a:term, '<>$ "')
    if !empty(l:path)
        let &l:makeprg=&l:makeprg . l:path
    endif
    let &l:errorformat="%f:%l:%m,%f:%l%m,%f  %l%m"
    Neomake!
    copen
		" TODO execute 'match Search /' . a:term . '/'
endfunction

nnoremap <leader>o :call <SID>outline()<cr>
function! s:outline() abort
  let l:filetype = &filetype
  if exists("b:filetype")
    let l:filetype = b:filetype
  endif
  setlocal errorformat=%f:%l:%c:%m
  let &l:makeprg='outline --filename ' . expand('%') 
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

" augroup s:quickfix
"     " QuickFixCmd* Does not match :ltag
"     autocmd QuickFixCmdPost [^l]* nnoremap <tab> :copen<cr>
"     autocmd QuickFixCmdPost [^l]* botright copen
"     autocmd QuickFixCmdPost [^l]* let b:isQuickfix = 1
"     autocmd QuickFixCmdPost    l* nnoremap <tab> :lopen<cr>
"     autocmd QuickFixCmdPost    l* botright lopen
" augroup END

