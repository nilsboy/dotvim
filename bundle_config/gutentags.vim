finish
" manages your tag files
NeoBundle 'ludovicchabant/vim-gutentags'

let g:gutentags_ctags_tagfile = '.git/tags'
let g:gutentags_project_root = ['package.json']
let g:gutentags_ctags_executable = 'ctags-gutentags'
