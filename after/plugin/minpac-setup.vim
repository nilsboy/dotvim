if exists("g:MyMinpacSetupPluginLoaded")
    finish
endif
let g:MyMinpacSetupPluginLoaded = 1

let g:MyMinpacSetupMissingPlugin = 0

" Install a plugin as optional and load it directly.
" This allows before and after configs for a plugin in the same contained config file.
" This also prevents plugins to be loadded implicitly just by being installed.
function! PackAdd(...) abort
  let url = get(a:000, '0')
  let options = get(a:000, '1', {})
  let package = substitute(url, '.*/', '', 'g')
  call extend(options, {'type': 'opt'})
  call minpac#add(url, options)
  let dir = $HOME . '/.vim/pack/minpac/opt/' . package
  if ! isdirectory(dir)
    " echo 'Missing plugin: ' . package . ' - install with :PluginsUpdate'
    let g:MyMinpacSetupMissingPlugin = 1
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
call minpac#init({'status_open': 'horizontal'})

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

command! -nargs=* PluginsUpdate call minpac#update()
command! -nargs=* PluginsStatus call minpac#status()

nnoremap <silent> <leader>vps :PluginsStatus \| only<cr>
nnoremap <silent> <leader>vpu :PluginsUpdate<cr>
