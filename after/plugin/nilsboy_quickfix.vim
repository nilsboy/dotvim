" TODO use winsaveview to prevent window resizing on copen
" Clear quickfix: :cex[]
" TODO always close buffer of preview window - is there a plugin for that?
" TODO checkout https://github.com/stefandtw/quickfix-reflector.vim
" checkout asyncrun / despatch
" Format quickfix output: https://github.com/MarcWeber/vim-addon-qf-layout
" checkout: https://github.com/djmoch/vim-makejob
" Populate qf with open buffers:
" from https://vi.stackexchange.com/questions/2121/how-do-i-have-buffers-listed-in-a-quickfix-window-in-vim
" call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr": v:val}'))
" TODO maybe replace locationlist with quickfix?

" augroup s:quickfix
"     " QuickFixCmd* Does not match :ltag
"     autocmd QuickFixCmdPost [^l]* nnoremap <tab> :copen<cr>
"     autocmd QuickFixCmdPost [^l]* botright copen
"     autocmd QuickFixCmdPost [^l]* let b:isQuickfix = 1
"     autocmd QuickFixCmdPost    l* nnoremap <tab> :lopen<cr>
"     autocmd QuickFixCmdPost    l* botright lopen
" augroup END

let g:quickfix_mode = ''
function! s:toggleNavigationType() abort
    if g:quickfix_mode == 'quickfix'
      call s:setNavigationType('locationlist')
    else
      call s:setNavigationType('quickfix')
    endif
endfunction

function! s:setNavigationType(type) abort
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

call s:setNavigationType('quickfix')
nnoremap <leader>ll :call <SID>toggleNavigationType()<cr>

nnoremap <silent> <leader>ff :call <SID>find('', 'project')<cr>
nnoremap <silent> <leader>fd :call <SID>find('', 'buffer_dir')<cr>
nnoremap <silent> <leader>fw yiw:call <SID>find(@", 'project')<cr>
nnoremap <silent> <leader>fW yiW:call <SID>find(@", 'project')<cr>
nnoremap <silent> <leader>fi :call <SID>find(input('File name: '), 'project')<cr>
nnoremap <silent> <leader>fs :call <SID>find(input('File name: '), '~/src')<cr>
nnoremap <silent> <leader>vp :call <SID>find('', $_VIM_BUNDLE_DIR)<cr>
function! s:find(term, directory) abort
    call s:setNavigationType('quickfix')

    " Make sure the quickfix cwd isn't used as starting directory
    cclose

    call s:Cd(a:directory)
    let &l:makeprg="find-and-limit\ " . escape(a:term, '$ "')
    setlocal errorformat=%f
    Neomake!
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
vnoremap <leader>gg y:call <SID>grep(@", '')<cr>
nnoremap <leader>gW yiW:call <SID>grep(@", '')<cr>
nnoremap <leader>gi :call <SID>grep(input('Grep for: '), '')<cr>
nnoremap <leader>gs :call <SID>grep(input('Grep for: '), '~/src/')<cr>
command! -bang -nargs=1 Grep call <SID>grep(<q-args>, '')
function! s:grep(term, directory) abort
    call s:setNavigationType('quickfix')
    call s:Cd(a:directory)
    let &l:makeprg=s:grep_command . ' ' . escape(a:term, '$ "')
    echom &l:makeprg
    let &l:errorformat="%f:%l:%m,%f:%l%m,%f  %l%m"
    Neomake!
    copen
		" TODO execute 'match Search /' . a:term . '/'
endfunction

nnoremap <leader>o :call <SID>outline()<cr>
function! s:outline() abort
    call s:setNavigationType('quickfix')
    let &l:makeprg='ctags -f - --fields=n % | vim-errorformat-cleaner'
    setlocal errorformat=%f:%l:%c:%m
    Neomake!
    copen
endfunction

" TODO
nnoremap <silent><leader>vb :call <SID>buffers('')<cr>
nnoremap <silent><leader>vB :call <SID>buffers('!')<cr>
function! s:buffers(hidden) abort
    call s:setNavigationType('quickfix')
    setlocal errorformat=%s"%f"%s
    cexpr execute(':buffers' . a:hidden)
    copen
endfunction

nmap <silent> <leader>/ [I

" http://dhruvasagar.com/2013/12/17/vim-filter-quickfix-list
function! s:FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~?' : '=~?'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file QFilter call s:FilterQuickfixList(<bang>0, <q-args>)

" TODO nnoremap <silent><leader>vh :call _Denite('vim_help', 'help', '', '')<cr>
function s:help(term) abort
    call s:setNavigationType('locationlist')
    help
    silent! execute 'ltag /' . a:term
    silent! lopen
endfunction
command! -bang -nargs=1 -complete=file H call s:help(<q-args>)

