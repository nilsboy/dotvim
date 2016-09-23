" Changes Vim working directory to project root
NeoBundle 'airblade/vim-rooter'

" To prevent vim-rooter from creating a mapping, do this:
let g:rooter_disable_map = 1

" If you don't want vim-rooter to echo the project directory, try this:
let g:rooter_silent_chdir = 1

let g:rooter_patterns = ['package.json', '.git/']
