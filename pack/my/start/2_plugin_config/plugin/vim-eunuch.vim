" Vim sugar for the UNIX shell commands
PackAdd tpope/vim-eunuch

" eunich does a reload which recreates the file in my setup
delcommand Remove
command! -nargs=* Remove echohl WarningMsg | echom "Warning: :Remove is disabled. Use \<leader\>rm instead." | echohl None

nnoremap <leader>rm :Delete!

command! -nargs=* W :SudoWrite
