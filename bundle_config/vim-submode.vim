" Create your own submodes
NeoBundle 'kana/vim-submode'

let g:submode_always_show_submode	= 1
let g:submode_timeout = 0
let g:submode_timeoutlen = 0
let g:submode_keep_leaving_key = 1
" let g:submode_keyseqs_to_leave = ['q']

if neobundle#tap('vim-submode') 
    function! neobundle#hooks.on_post_source(bundle)

" call submode#enter_with('move', 'n', '', '<bs>')
call submode#enter_with('move', 'n', '', '<leader>m')
call submode#map('move', 'n', '', 'j', '<c-f>')
call submode#map('move', 'n', '', 'k', '<c-b>')
" call submode#map('move', 'n', '', 'J', '7j')
" call submode#map('move', 'n', '', 'K', '7k')
" call submode#map('move', 'n', '', 'h', 'B')
" call submode#map('move', 'n', '', 'l', 'W')

  endfunction
  call neobundle#untap()
endif

