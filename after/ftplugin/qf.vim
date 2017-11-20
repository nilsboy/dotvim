" setlocal cursorline
setlocal nowrap
let &l:winheight = &lines / 3

" nmap <buffer><silent> f :QFilter<space>

" TODO previewwindow
" nmap <buffer><silent> p :pedit! <cfile><cr>

if BufferIsQuickfix()
  nnoremap <silent> <c-n> :silent! cnext<cr>
  nnoremap <silent> <c-p> :silent! cprevious<cr>
  nmap <buffer><silent> <tab> :cclose<cr>
  nmap <buffer><silent> L :silent! cnewer<cr>
  nmap <buffer><silent> H :silent! colder<cr>
  nmap <buffer><silent> <cr> :.cc \| :cclose<cr>
else
  nnoremap <silent> <c-n> :silent! lnext<cr>
  nnoremap <silent> <c-p> :silent! lprevious<cr>
  nmap <buffer><silent> <tab> :lclose<cr>
  nmap <buffer><silent> L :silent! lnewer<cr>
  nmap <buffer><silent> H :silent! lolder<cr>
  nmap <buffer><silent> <cr> :.ll \| :lclose<cr>
endif
