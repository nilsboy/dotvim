let s:localrc  = $HOME . "/.vimlocal/vimrc"
if filereadable(s:localrc)
  execute "source " . s:localrc
endif

