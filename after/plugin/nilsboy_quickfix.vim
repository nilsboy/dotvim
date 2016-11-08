" TODO use winsaveview to prevent window resizing on copen
" Clear quickfix: :cex[]
" TODO always close buffer of preview window - is there a plugin for that?
" TODO checkout https://github.com/stefandtw/quickfix-reflector.vim
" checkout asyncrun / despatch
" Format quickfix output: https://github.com/MarcWeber/vim-addon-qf-layout

augroup s:my_quickfix
    autocmd QuickFixCmdPost [^l]* botright copen 15
    autocmd QuickFixCmdPost    l* botright lopen 15
augroup END

nnoremap <tab> :copen<cr>
autocmd FileType qf nmap <buffer><silent> <tab> :cclose<cr>

autocmd FileType qf nmap <buffer><silent> L :silent! cnewer<cr>
autocmd FileType qf nmap <buffer><silent> H :silent! colder<cr>
autocmd FileType qf nmap <buffer><silent> i /

autocmd FileType qf nmap <buffer><silent> f :QFilter<space>
autocmd FileType qf nmap <buffer><silent> <cr> :.cc \| :cclose<cr>

autocmd FileType qf :setlocal cursorline
autocmd FileType qf :setlocal nowrap

" TODO
autocmd FileType qf nmap <buffer><silent> p :pedit! <cfile><cr>

nnoremap <silent> <leader>ff :call <SID>find('', 'project')<cr>
nnoremap <silent> <leader>fd :call <SID>find('', 'buffer_dir')<cr>
nnoremap <silent> <leader>fw yiw:call <SID>find(@", 'project')<cr>
nnoremap <silent> <leader>fW yiW:call <SID>find(@", 'project')<cr>
nnoremap <silent> <leader>fi :call <SID>find(input('File name: '), 'project')<cr>
nnoremap <silent> <leader>fs :call <SID>find(input('File name: '), '~/src')<cr>
nnoremap <silent> <leader>vp :call <SID>find('', $_VIM_BUNDLE_DIR)<cr>
function! s:find(term, directory) abort

    " Make sure the quickfix cwd isn't used as starting directory
    cclose

    call s:Cd(a:directory)
    let &l:makeprg="find-and-limit\ " . escape(a:term, ' ')
    setlocal errorformat=%f
    silent! make!
    copen
endfunction

function! s:Cd(directory) abort
    if a:directory == ''
    elseif a:directory == 'project'
      call CdProjectRoot()
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
nnoremap <leader>gW yiW:call <SID>grep(@", '')<cr>
nnoremap <leader>gi :call <SID>grep(input('Grep for: '), '')<cr>
nnoremap <leader>gs :call <SID>grep(input('Grep for: '), '~/src/')<cr>
command! -bang -nargs=1 Grep call <SID>grep(<q-args>, '')
function! s:grep(term, directory) abort
    call s:Cd(a:directory)
    let &l:makeprg=s:grep_command . ' ' . escape(a:term, ' ')
    let &l:errorformat="%f:%l:%m,%f:%l%m,%f  %l%m"
    silent! make!
    copen
		" TODO execute 'match Search /' . a:term . '/'
endfunction

nnoremap <leader>o :call <SID>outline()<cr>
function! s:outline() abort
    let &l:makeprg='ctags -f - --fields=n % \| vim-errorformat-cleaner'
    setlocal errorformat=%f:%l:%c:%m
    silent! make!
    copen
endfunction

" TODO
nnoremap <silent><leader>vb :call <SID>buffers('')<cr>
nnoremap <silent><leader>vB :call <SID>buffers('!')<cr>
function! s:buffers(hidden) abort
    setlocal errorformat=%s"%f"%s
    cexpr execute(':buffers' . a:hidden)
    copen
endfunction

" TODO nnoremap <silent><leader>vh :call _Denite('vim_help', 'help', '', '')<cr>

nmap <silent> <leader>/ [I

" http://dhruvasagar.com/2013/12/17/vim-filter-quickfix-list
function! s:FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~?' : '=~?'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file QFilter call s:FilterQuickfixList(<bang>0, <q-args>)

