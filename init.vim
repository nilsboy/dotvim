" Remove all existing autocommands on vimrc reload
autocmd!

" Reset all settings to their defaults
set all&

" prevent some builtin plugins from loading
" see vim-dirvish
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
" see vim-matchup
let g:loaded_matchit = 1
" let g:loaded_matchparen = 1

let $CONTRIB = stdpath('config') . '/contrib/etc'
let $PATH = $PATH . ':' . stdpath('config') . '/contrib/bin'
set path=.,,
execute 'set packpath^=' . stdpath('config')

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

" set verbosefile=/tmp/vim-debug.log
" set verbose=13
