setlocal cursorline
setlocal nowrap
setlocal winheight=20

nmap <buffer><silent> f :QFilter<space>

" TODO previewwindow
nmap <buffer><silent> p :pedit! <cfile><cr>

if g:quickfix_mode == 'quickfix'
    nmap <buffer><silent> <tab> :cclose<cr>
    nmap <buffer><silent> L :silent! cnewer<cr>
    nmap <buffer><silent> H :silent! colder<cr>

    if ! exists('b:quickfix_action')
      " let b:quickfix_action = ":.cc \| :cclose"
      let b:quickfix_action = ":.cc"
    endif

    nmap <buffer><silent> <cr> :execute b:quickfix_action \| :cclose<cr>
else
    nmap <buffer><silent> <tab> :lclose<cr>
    nmap <buffer><silent> L :silent! lnewer<cr>
    nmap <buffer><silent> H :silent! lolder<cr>

    nmap <buffer><silent> <cr> :.ll \| :lclose<cr>
endif

