set nocompatible

if empty($XDG_CONFIG_HOME)
  let $XDG_CONFIG_HOME = $REMOTE_HOME . "/.config"
endif

if empty($XDG_DATA_HOME)
  let $XDG_DATA_HOME = $REMOTE_HOME . "/.local/share"
endif

if empty($XDG_CACHE_DIR)
  let $XDG_CACHE_DIR = $REMOTE_HOME . "/.cache"
endif

" vars
let g:vim           = {}
let g:vim.dir       = $REMOTE_HOME . "/.vim/"
let g:vim['etc']    = { 'dir' : g:vim.dir . "etc/" }
let g:vim['after']  = { 'dir' : g:vim.etc.dir . "after/" }
let g:vim.rc        = g:vim.etc.dir . "vimrc"
let g:vim.rc_local  = $REMOTE_HOME . "/.vimrc.local"
let g:vim['var']    = { 'dir' : $XDG_DATA_HOME . '/vim/' }
let g:vim['plugin'] = { 'dir' : g:vim.etc.dir . "plugin/" }
let g:vim['cache']  = { 'dir' : $XDG_CACHE_DIR . '/vim/' }

let g:vim['contrib']  = { 'dir' : g:vim.etc.dir . '/contrib/' }
let g:vim.contrib['etc']  = { 'dir' : g:vim.contrib.dir . '/etc/' }
let g:vim.contrib['bin']  = { 'dir' : g:vim.contrib.dir . '/bin/' }

let $MYVIMRC = g:vim.rc

let g:vim.bundle = {}
let g:vim.bundle.dir =  g:vim.dir . "bundle/"
let g:vim.bundle.settings = {}
let g:vim.bundle.settings.dir = g:vim.etc.dir . "bundle_config/"
let $_VIM_BUNDLE_DIR = g:vim.bundle.dir

let g:vim.config = {}
let g:vim.config.dir = g:vim.etc.dir . "config/"

execute "source " . g:vim.etc.dir . '/helpers.vim'

call Mkdir(g:vim.dir, "p")
call Mkdir(g:vim.etc.dir, "p")
call Mkdir(g:vim.var.dir, "p")

" Remove all existing autocommands on vimrc reload
autocmd!

" reset everything to their defaults
set all&

" Search the web by default instead of manpages
let &keywordprg = ':WebWithFiletype'

" Keep undo history after closing a file
set undofile
let &undodir = g:vim.var.dir . "undo"
call Mkdir(&undodir, "p")

augroup MyVimrcAugroupOnlySetCurrentDirAsPath
  autocmd!
  autocmd VimEnter * set path=,,
augroup END

" Make helpgrep find vim's own help files before plugin help files
let &runtimepath = '/usr/share/nvim/runtime,'
      \ . &runtimepath

execute "set runtimepath+=" . g:vim.etc.dir
execute "set runtimepath+=" . g:vim.after.dir

let $PATH = $PATH . ':' . g:vim.etc.dir . '/contrib/bin'
let $MY_VIM_DIR = g:vim.etc.dir

execute "source " . g:vim.etc.dir . '/load_plugins.vim'

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

"### Debugging

" " NOTE: Neobundle unsets these
" set verbosefile=/tmp/vim-debug.log
" set verbose=13

