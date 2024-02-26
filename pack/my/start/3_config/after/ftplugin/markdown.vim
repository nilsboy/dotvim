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

nmap <silent> <buffer> <leader>nrr m`viC:call my_narrow#narrow({})<cr>
nmap <silent> <buffer> <leader>nrs m`viC:call my_narrow#narrow({'filetype': 'sql'})<cr>
nmap <silent> <buffer> <leader>nrt m`viC:call my_narrow#narrow({'filetype': 'text'})<cr>


