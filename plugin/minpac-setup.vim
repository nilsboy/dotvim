" Install a plugin as optional and load it directly.
" This allows before and after configs for a plugin in the same contained config file.
" This also prevents plugins to be loadded implicitly just by being installed.
function! PackAdd(url) abort
  let package = substitute(a:url, '.*/', '', 'g')
  call minpac#add(a:url, {'type': 'opt'})
  let dir = $HOME . '/.vim/pack/minpac/opt/' . package
  if ! isdirectory(dir)
    echo 'Missing plugin: ' . package . ' - install with :PluginsUpdate'
  else
    execute 'packadd ' . package
  endif
endfunction
command! -nargs=* PackAdd call PackAdd(<f-args>)

" Bootstrap minpac
if ! len(glob('~/.vim/pack/minpac/opt/minpac/README.md')) > 0
  echo "Installing plugin manager minpac..."
  echo ""
  call Mkdir("~/.vim/pack/minpac/opt/minpac", "p")
  execute "!git clone --depth=1 https://github.com/k-takata/minpac.git "
        \ "~/.vim/pack/minpac/opt/minpac"
endif

packadd minpac
call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

command! -nargs=* PluginsUpdate call minpac#update()
command! -nargs=* PluginsStatus call minpac#status()
