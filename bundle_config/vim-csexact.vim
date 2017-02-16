finish
" Use GUI Color Schemes in Supported Terminals
NeoBundle 'KevinGoodsell/vim-csexact'

" NOTE: Seems to be unnecessary when using Neovim

" Prevent CSExact from resetting the colors to the normal palette to avoid
" disturbing other vims in the same terminal window (when using tmux etc)
" This overwrites CSExacts reset function with a dummy function.
command! -bar CSExactResetColors echo "Avoiding CSExact reset"
