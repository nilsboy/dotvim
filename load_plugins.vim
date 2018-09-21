function! IsPluginInstalled(path)
    let l:basename = fnamemodify(a:path,':t:h')
    if isdirectory(g:vim.bundle.dir . l:basename)
        return 1
    endif
    return 0
endfunction

let g:neobundle#types#git#clone_depth = 1

if !IsPluginInstalled("neobundle.vim")
    echo "Installing NeoBundle..."
    echo ""
    call Mkdir(g:vim.bundle.dir, "p")
    execute "!git clone https://github.com/Shougo/neobundle.vim " .
                \ g:vim.bundle.dir . "/neobundle.vim"
endif
execute "set runtimepath+=" . g:vim.bundle.dir . "/neobundle.vim/"

call neobundle#begin(g:vim.bundle.dir)

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

runtime! bundle_config/**/*.vim
call neobundle#end()

NeoBundleCheck

if IsNeoVim()
  " Provides Neovim's UpdateRemotePlugins but does not seem to be sourced jet:
  source /usr/share/nvim/runtime/plugin/rplugin.vim
  " Calls UpdateRemotePlugins the NeoBundle way
  silent! NeoBundleRemotePlugins
endif
