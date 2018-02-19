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

execute "source " . g:vim.after.dir . '/plugin/helpers.vim'

call Mkdir(g:vim.dir, "p")
call Mkdir(g:vim.etc.dir, "p")
call Mkdir(g:vim.var.dir, "p")

" Remove all existing autocommands on vimrc reload
autocmd!

" reset everything to their defaults
set all&

"### Plugin manager

function! IsPluginInstalled(path)
    let l:basename = fnamemodify(a:path,':t:h')
    if isdirectory(g:vim.bundle.dir . l:basename)
        return 1
    endif
    return 0
endfunction

if !IsPluginInstalled("neobundle.vim")
    echo "Installing NeoBundle..."
    echo ""
    call Mkdir(g:vim.bundle.dir, "p")
    execute "!git clone https://github.com/Shougo/neobundle.vim " .
                \ g:vim.bundle.dir . "/neobundle.vim"
endif
execute "set runtimepath+=" . g:vim.bundle.dir . "/neobundle.vim/"

" Required:
call neobundle#begin(g:vim.bundle.dir)

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" TODO checkout runtime! *.vim
" execute "runtime! " . g:vim.bundle.settings.dir . "/*.vim"
for fpath in split(globpath(g:vim.bundle.settings.dir, '*.vim'), '\n')
    execute 'source' fpath
endfor

call neobundle#end()

NeoBundleCheck

if IsNeoVim()
  " Provides Neovim's UpdateRemotePlugins but does not seem to be sourced jet:
  source /usr/share/nvim/runtime/plugin/rplugin.vim
  " Calls UpdateRemotePlugins the NeoBundle way
  silent! NeoBundleRemotePlugins
endif

" Remove installed plugins that are not configured anymore
" :NeoBundleClean!

execute "source " . g:vim.after.dir . '/vimrc'

if filereadable(g:vim.rc_local)
    execute "source " . g:vim.rc_local
endif

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

"### Debugging

" NOTE: Neobundle unsets these
" set verbosefile=/tmp/vim-debug.log
" set verbose=15

" TODO: move
command! -nargs=* EditInBufferDir
      \ :execute 'edit ' . expand('%:p:h') . '/' . expand('<args>')

