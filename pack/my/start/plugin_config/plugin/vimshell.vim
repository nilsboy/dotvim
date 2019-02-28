finish
" Powerful shell implemented by vim
NeoBundleLazy 'Shougo/vimshell.vim',
    \ {'autoload':{'commands':[ 'VimShell', 'VimShellInteractive' ]}}

let g:vimshell_editor_command='vim'
let g:vimshell_right_prompt='getcwd()'
let g:vimshell_data_directory=stdpath("cache") . '/vimshell'
let g:vimshell_vimshrc_path=g:vim.dir . 'vimshrc'

" nnoremap <leader>c  :VimShell -split<cr>
" nnoremap <leader>cc :VimShell -split<cr>
" nnoremap <leader>cn :VimShellInteractive node<cr>
" nnoremap <leader>cl :VimShellInteractive lua<cr>
" nnoremap <leader>cr :VimShellInteractive irb<cr>
" nnoremap <leader>cp :VimShellInteractive python<cr>
