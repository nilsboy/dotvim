" Remove all existing autocommands on vimrc reload
autocmd!

" Reset all settings to their defaults
set all&

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
