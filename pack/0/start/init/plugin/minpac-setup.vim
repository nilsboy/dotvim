if exists("g:MyMinpacSetupPluginLoaded")
  finish
endif
let g:MyMinpacSetupPluginLoaded = 1

" Install a plugin as optional and load it directly.
" This allows before and after configs for a plugin in the same contained
" config file.
" This also prevents plugins to be loadded implicitly just by being installed.
function! PackAdd(...) abort
  let url = get(a:000, '0')
  let options = get(a:000, '1', {})
  let package = substitute(url, '.*/', '', 'g')
  call extend(options, {'type': 'opt'})
  call minpac#add(url, options)
  let pluginfo = g:minpac#pluglist[package]
  let dir = pluginfo.dir
  if ! isdirectory(dir)
    echom 'Installing missing plugin: ' . package
    " this is async so does not work with my sequential plugin config files
    " system:
    " call minpac#update(package, {'do': 'packadd ' . package})
    execute '!git clone --quiet ' . pluginfo.url . ' ' . pluginfo.dir
          \ . ' --no-single-branch --depth=1'
    if type(pluginfo.do) == v:t_func
      call INFO('Running post hook for ' . package)
      let pwd = getcwd()
      let cdcmd = haslocaldir() ? 'lcd' : 'cd'
      noautocmd execute cdcmd fnameescape(pluginfo.dir)
      call call(pluginfo.do, [])
      noautocmd execute cdcmd fnameescape(pwd)
    endif
    if isdirectory(pluginfo.dir . '/doc')
      echom 'Generating help tags for ' . package
      execute 'helptags ' . pluginfo.dir . '/doc'
    endif
  endif
    execute 'packadd ' . package
endfunction
command! -nargs=* PackAdd call PackAdd(<f-args>)

" Bootstrap minpac
if ! len(glob(stdpath('config') . '/pack/minpac/opt/minpac/README.md')) > 0
  echo "Installing plugin manager minpac..."
  echo ""
  execute "!git clone --depth=1 https://github.com/k-takata/minpac.git "
        \ stdpath('config') . "/pack/minpac/opt/minpac"
endif

packadd minpac
call minpac#init({'status_open': 'horizontal'})

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

command! -nargs=* PluginsUpdate call minpac#update()
command! -nargs=* PluginsStatus call minpac#status()
