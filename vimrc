set nocompatible

" Remove all existing autocommands on vimrc reload
autocmd!

" reset everything to their defaults
set all&

" TODO: replace with stdpath()
let g:vim           = {}
let g:vim.dir       = $HOME . "/.vim/"
let g:vim['etc']    = { 'dir' : g:vim.dir }
" g:vim.after.dir

let $CONTRIB = g:vim.etc.dir . '/contrib/'
let $CONTRIB_ETC = g:vim.etc.dir . '/contrib/etc'

let $HOME = $REMOTE_HOME

" Make sure configs are not source twice due to links between .vim and
" .config/nvim dirs
execute 'set runtimepath-=$HOME/.config/nvim'
execute 'set runtimepath-=$HOME/.config/nvim/after'

call mkdir(stdpath("data"), "p")

set packpath^=~/.vim

" Search the web by default instead of manpages
let &keywordprg = ':WebWithFiletype'
nnoremap <silent> <leader>gK :execute 'WebWithFiletype ' . expand('<cword>')<cr>

" Keep undo history after closing a file
set undofile
let &undodir = stdpath("data") . "/undo"
call mkdir(&undodir, "p")

set path=.,,
let $PATH = $PATH . ':' . $CONTRIB

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

"### Debugging

" set verbosefile=/tmp/vim-debug.log
" set verbose=13
