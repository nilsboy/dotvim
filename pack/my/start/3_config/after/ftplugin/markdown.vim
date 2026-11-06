setlocal formatoptions=
" setlocal formatoptions=tacqwn

setlocal conceallevel=0
let &l:tabstop = 2
let &l:softtabstop = &l:tabstop
let &l:shiftwidth = &l:tabstop

let &l:define = '\v#+\s+'
let b:outline = '^#+\s+'

let b:formatter = 'prettier-markdown'

setlocal nowrap

nmap <silent> <buffer> ,nr m`viC:call my_narrow#narrow({})<cr>
nmap <silent> <buffer> ,nRs m`viC:call my_narrow#narrow({'filetype': 'sql'})<cr>
nmap <silent> <buffer> ,nRt m`viC:call ky_narrow#narrow({'filetype': 'text'})<cr>

function! MyMarkdownToHtml(...) abort
  let file = nb#createTempFile("pandoc", "pandoc", "html")
  silent execute '!pandoc --from markdown % -o ' . file
  execute 'edit ' . file
endfunction
nmap <silent> <buffer> <leader>nh :call MyMarkdownToHtml()<cr>

nnoremap <silent> <buffer> <leader>lw :silent call MakeWith({'name': 'tsc', 'compiler': 'tsc'})<cr>

" nnoremap <silent> <buffer> <cr> vi[gf
