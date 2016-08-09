" Provide easy code formatting in Vim by integrating existing code formatters.
NeoBundle 'Chiel92/vim-autoformat', {
    \ 'build': 'npm install -g jslint js-beautify remark typescript-formatter'
    \ }

let g:autoformat_verbosemode=1

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
