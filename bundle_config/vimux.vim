" vim plugin to interact with tmux
NeoBundle 'benmills/vimux'

let g:VimuxUseNearest = 1
let g:VimuxPromptString = "vimux> "

nnoremap <leader>ss yip:call VimuxSendText(@")<cr>
vnoremap <leader>ss y:call VimuxSendText(@")<cr>
