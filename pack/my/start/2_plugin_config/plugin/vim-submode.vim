finish
" Create your own submodes

let g:submode_always_show_submode	= 1
let g:submode_timeout = 0
" let g:submode_timeoutlen = 0
let g:submode_keep_leaving_key = 0
" let g:submode_keyseqs_to_leave = ['q']

PackAdd kana/vim-submode

call submode#enter_with('indent-move', 'n', '', '<leader>z')
call submode#map('indent-move', 'n', '', 'j', '<Plug>(IndentWiseBlockScopeBoundaryEnd)')
call submode#map('indent-move', 'n', '', 'k', '<Plug>(IndentWiseBlockScopeBoundaryBegin)')
call submode#map('indent-move', 'n', '', 'h', '<Plug>(IndentWisePreviousLesserIndent)')
call submode#map('indent-move', 'n', '', 'l', '<Plug>(IndentWiseNextGreaterIndent)')

call submode#enter_with('move', 'n', '', '<leader>3')
call submode#map('move', 'n', '', 'j', '19j')
call submode#map('move', 'n', '', 'k', '19k')
call submode#map('move', 'n', '', 'h', '46h')
call submode#map('move', 'n', '', 'l', '46l')
