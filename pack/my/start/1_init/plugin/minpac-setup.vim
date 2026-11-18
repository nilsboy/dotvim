if exists("g:MyMinpacSetupPluginLoaded")
  finish
endif
let g:MyMinpacSetupPluginLoaded = 1

" Load a plugin from a standalone directory, bypassing minpac: runs a given
" post hook, prepends the directory to 'runtimepath' and sources its plugin
" and ftdetect scripts the same way :packadd would do for an optional plugin.
" The other runtime directories (autoload, ftplugin, after, ... and doc for
" :help) are resolved automatically through 'runtimepath'.
function! s:PackLoadLocal(dir, options) abort
  let cdcmd = haslocaldir() ? 'lcd' : 'cd'
  if type(get(a:options, 'do', '')) == v:t_func
    call nb#info('Running post hook for local checkout ' . a:dir)
    let pwd = getcwd()
    noautocmd execute cdcmd fnameescape(a:dir)
    call call(a:options['do'], [])
    noautocmd execute cdcmd fnameescape(pwd)
  endif

  execute 'set runtimepath^=' . escape(a:dir, ' ,\\')
  let file_list = glob(a:dir . '/plugin/**/*.vim', 0, 1)
        \ + glob(a:dir . '/plugin/**/*.lua', 0, 1)
        \ + glob(a:dir . '/ftdetect/*.vim', 0, 1)
  for file in file_list
    execute 'source ' . fnameescape(file)
  endfor

  if isdirectory(a:dir . '/doc')
    " echom 'Generating help tags for ' . a:dir
    execute 'helptags ' . fnameescape(a:dir . '/doc')
  endif
endfunction

" Install a plugin as optional and load it directly.
" This allows before and after configs for a plugin in the same contained
" config file.
" This also prevents plugins to be loaded implicitly just by being installed.
function! PackAdd(...) abort
  let url = get(a:000, '0')
  let options = get(a:000, '1', {})
  let package = substitute(url, '.*/', '', 'g')

  " Prefer a source checkout with the same name in ~/src-ai or ~/src over the
  " copy managed by minpac. Load it directly and never clone it. It is not
  " registered with minpac, so PluginsUpdate does not touch the checkout
  " and PluginsStatus does not list it.
  for parent_dir in [$HOME . '/src-ai', $HOME . '/src']
    let local_dir = parent_dir . '/' . package
    if isdirectory(local_dir)
      call s:PackLoadLocal(local_dir, options)
      return
    endif
  endfor

  call extend(options, {'type': 'opt'})
  call minpac#add(url, options)
  let pluginfo = g:minpac#pluglist[package]
  let dir = pluginfo.dir
  if ! isdirectory(dir)
    echom 'Installing missing plugin: ' . package

    " this is async so does not work with my sequential plugin config files
    " system:
    " call minpac#update(package, {'do': 'packadd ' . package})
    " Synchronous version of minpac#update:
    execute '!git clone --quiet ' . pluginfo.url . ' ' . pluginfo.dir
          \ . ' --no-single-branch --depth=1'
    if type(pluginfo.do) == v:t_func
      call nb#info('Running post hook for ' . package)
      let pwd = getcwd()
      let cdcmd = haslocaldir() ? 'lcd' : 'cd'
      noautocmd execute cdcmd fnameescape(pluginfo.dir)
      call call(pluginfo.do, [])
      noautocmd execute cdcmd fnameescape(pwd)
    endif
    if isdirectory(pluginfo.dir . '/doc')
      " echom 'Generating help tags for ' . package
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
