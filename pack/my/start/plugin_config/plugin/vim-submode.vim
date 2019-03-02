finish
" Create your own submodes

let g:submode_always_show_submode	= 1
let g:submode_timeout = 0
" let g:submode_timeoutlen = 0
let g:submode_keep_leaving_key = 1
let g:submode_keyseqs_to_leave = ['q']

PackAdd kana/vim-submode

" call submode#enter_with('move', 'n', '', '<bs>')
call submode#enter_with('move', 'n', '', '<leader>m')
call submode#map('move', 'n', '', 'j', '<c-f>')
call submode#map('move', 'n', '', 'k', '<c-b>')
call submode#map('move', 'n', '', 'J', '7j')
call submode#map('move', 'n', '', 'K', '7k')
" call submode#map('move', 'n', '', 'h', 'B')
" call submode#map('move', 'n', '', 'l', 'W')
