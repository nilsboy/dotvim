finish
" vim plugin to interact with tmux
PackAdd benmills/vimux

" Note: destination (runner) panel selection is annoying

let g:VimuxUseNearest = 1
let g:VimuxPromptString = "vimux> "

nnoremap <leader>ss yip:call VimuxSendText(@")<cr>
vnoremap <leader>ss y:call VimuxSendText(@")<cr>

" map <Leader>x :call VimuxRunCommand("ls")<CR>
