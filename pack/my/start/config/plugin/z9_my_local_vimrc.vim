let s:localrc  = $HOME . "/.vimrc.local"
if filereadable(s:localrc)
  execute "source " . s:localrc
endif

