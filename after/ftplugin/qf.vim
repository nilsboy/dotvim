setlocal nowrap

" restore <cr> if remapped elsewhere
" nnoremap <buffer> <cr> <cr>

" nmap <buffer><silent> f :QFilter<space>

" TODO previewwindow
" nmap <buffer><silent> p :pedit! <cfile><cr>

execute &cmdwinheight . 'wincmd _'

nnoremap <silent> <buffer> <bs> :call MyQuickfixFormatToggle()<cr>

nmap <buffer> <c-u> <esc><c-u>
nmap <buffer> <c-o> <esc><c-o>

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
  nmap <buffer><silent> <s-tab> :lclose<cr>
  nmap <buffer><silent> <tab> :lclose<cr>
  nmap <buffer><silent> L :silent! lnewer<cr>
  nmap <buffer><silent> H :silent! lolder<cr>
  nmap <buffer><silent> <cr> :.ll \| :lclose<cr>
endif
