" Run your tests at the speed of thought
NeoBundle 'janko-m/vim-test'

" make test commands execute using dispatch.vim
" let test#strategy = "dispatch"

nmap <silent> <leader>tt :TestLast<CR>
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tT :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tg :TestVisit<CR>

nmap <silent> <leader>en :cnext<CR>
nmap <silent> <leader>ep :cprevious<CR>

" TODO checkout :Cucumber

" cmd is i.e. node_modules/.bin/mocha
function! VimTestStrategyFixedDispatch2(cmd)
    " vim-test prepends makeprg to own command so have to remove it first
    set makeprg=
    " Dispatch does not seem to have an &errorformat!?!
    execute 'Make' a:cmd
endfunction

function! VimTestStrategyMake(cmd)
    let &makeprg=a:cmd
    " Dispatch does not seem to have an &errorformat!?!
    " execute 'Make' a:cmd
    silent make
    cwindow
endfunction

function! VimTestStrategyMakeUnite(cmd)
    let &makeprg=a:cmd
    " Dispatch does not seem to have an &errorformat!?!
    " execute 'Make' a:cmd
    silent! make
    Unite -no-empty qf
    stopinsert
    redraw!
endfunction

let g:test#custom_strategies = {
    \ 'VimTestStrategyMakeUnite': function('VimTestStrategyMakeUnite')
\}
let g:test#strategy = 'VimTestStrategyMakeUnite'
