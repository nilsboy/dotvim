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
