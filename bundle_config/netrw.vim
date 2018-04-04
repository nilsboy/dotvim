" NetRW
" Detail View
let g:netrw_liststyle = 1
" Human-readable file sizes
let g:netrw_sizestyle = "H"
" hide dotfiles
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" hide dotfiles by default
let g:netrw_hide = 1
" Turn off banner
" let g:netrw_banner = 0
" Prevent creation of .netrwhist file
let g:netrw_dirhistmax = 0
" Use gx to open any file under cursor in appropriate app
let g:netrw_browsex_viewer="xdg-open"
nnoremap <leader>E :Explore<cr>

