finish
" Slim, Fast and Hackable Completion Framework for Neovim
" TODO: try out - currently has errors (2018-07-12)
NeoBundle 'ncm2/ncm2'

" ncm2 requires nvim-yarp
NeoBundle 'roxma/nvim-yarp'

" enable ncm2 for all buffer
autocmd BufEnter * call ncm2#enable_for_buffer()

" note that must keep noinsert in completeopt, the others is optional
set completeopt=noinsert,menuone,noselect
