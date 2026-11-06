" Remove all existing autocommands on vimrc reload
autocmd!

" Causes neovim to fallback to default terminal size and not respect the
" actual size (2020-04-02 - neovim 0.5.0. 0.2.2 the ubuntu 18.04 default does
" not seem to bei affected):
" Reset all settings to their defaults
" set all&

let mapleader = " "

" " Map space to leader instead of the other way around to keep the original
" " leader in insert mode - because space does not work well there.
" nmap <space> <leader>
" vmap <space> <leader>

" " Ignore the leader if the following key is not mapped
" NOTE: using map makes localleader shadow leader?!?
" nmap <leader> <nop>
" vmap <leader> <nop>

let maplocalleader = ","
" nmap , <localleader>
" vmap , <localleader>

" Ignore the localleader if the following key is not mapped
" nmap <nowait> <localleader> <nop>
" vmap <nowait> <localleader> <nop>

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

" " debug performance problems
" " look at the stats at the end of the file to see what takes long
" profile start /tmp/profile.log
" profile func *
" profile file *
" echohl WarningMsg | unsilent echom 'profiling to log.' | echohl None

