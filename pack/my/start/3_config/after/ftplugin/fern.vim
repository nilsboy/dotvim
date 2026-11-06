" TBD: mapping help page in buffer
" TBD: nowait?
" TBD: add git plugin?

" nmap <buffer><nowait> l <Plug>(fern-action-expand)
nmap <buffer><expr> <Plug>(fern-my-open-or-expand)
      \ fern#smart#leaf(
      \   "<Plug>(fern-action-open)",
      \   "<Plug>(fern-action-expand)",
      \ )
nmap <buffer><nowait> l <Plug>(fern-my-open-or-expand)
nmap <buffer><nowait> h <Plug>(fern-action-collapse)
nmap <buffer><nowait> < <Plug>(fern-action-leave)
nmap <buffer><nowait> > <Plug>(fern-action-enter)
nmap <buffer><nowait> <localleader>, <Plug>(fern-action-open)
nmap <buffer><nowait> <localleader>e <Plug>(fern-action-expand-tree:stay) 

nmap <buffer><nowait> <localleader>. <Plug>(fern-action-ex=)!
nmap <buffer><nowait> <localleader>S <Plug>(fern-action-ex=)!see
nmap <buffer><nowait> <localleader>b <Plug>(fern-action-ex=)!bak
nmap <buffer><nowait> { <Plug>(fern-action-focus:parent) 
nmap <buffer> <localleader><space> <Plug>(fern-action-mark:toggle)j
nmap <buffer> <localleader>M <Plug>(fern-action-mark:clear)
nmap <buffer> <localleader>c <Plug>(fern-action-new-path)
nmap <buffer> <nowait><localleader>r <Plug>(fern-action-remove)
nmap <buffer> <localleader>m <Plug>(fern-action-move)
nmap <buffer> <localleader>n <Plug>(fern-action-rename)
nmap <buffer> <localleader>s <Plug>(fern-action-open:split)
nmap <buffer> <localleader>v <Plug>(fern-action-open:vsplit)
nmap <buffer> <localleader>R <Plug>(fern-action-reload)
nmap <buffer> <localleader>h <Plug>(fern-action-hidden:toggle)

nmap <buffer> <localleader>y <Plug>(fern-action-clipboard-move)
nmap <buffer> <localleader>p <Plug>(fern-action-clipboard-paste)

augroup fern#augroupSetListed
  autocmd!
  autocmd  BufWinEnter <buffer> setlocal buflisted
augroup END
