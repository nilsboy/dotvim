finish
" Provide easy code formatting in Vim by integrating existing code formatters.
NeoBundle 'Chiel92/vim-autoformat', {
    \ 'build': 'npm install -g eslint remark-cli'
    \ }

" Show current formatter:
" :CurrentFormatter

let g:autoformat_verbosemode=1

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

" augroup my_autoformat
"   autocmd!
"   autocmd InsertLeave * :Autoformat
" augroup END

finish

let g:formatdef_my_custom_cs = '"astyle --mode=cs --style=ansi -pcHs4"'
let g:formatters_cs = ['my_custom_cs']

" :Verbose echo g:formatdef_eslint
"
" :NeomakeSh! eslint --no-eslintrc /home/nilsb/src/md-frameworx-resource-service/test/express.test.js
" :NeomakeSh! eslint --no-eslintrc /home/nilsb/src/md-frameworx-resource-service/test/express.test.js

