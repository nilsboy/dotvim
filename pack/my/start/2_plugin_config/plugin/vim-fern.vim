" Fern (furn) is a general purpose asynchronous tree viewer written in pure Vim script.
PackAdd lambdalisue/vim-fern

" A plugin for fern.vim to make the fern.vim as a default file explorer instead of Netrw. 
PackAdd lambdalisue/vim-fern-hijack

let g:fern#disable_default_mappings   = 1
" let g:fern#disable_viewer_hide_cursor = 1

" let g:fern#renderer#default#leading = " "
" let g:fern#renderer#default#root_symbol = ""
" let g:fern#renderer#default#leaf_symbol = "|  "
" let g:fern#renderer#default#collapsed_symbol = "|+ "
" let g:fern#renderer#default#expanded_symbol = "|- "

" noremap <silent> <Leader>d :Fern . -drawer -width=35 -toggle<CR><C-w>=
" noremap <silent> <Leader>f :Fern . -drawer -reveal=% -width=35<CR><C-w>=
" noremap <silent> <Leader>. :Fern %:h -drawer -width=35<CR><C-w>=
noremap <silent> <Leader>. :Fern . -reveal=%<CR>



