" tbone.vim: tmux basics
PackAdd tpope/vim-tbone
" TAGS: tmux shell command line

" make previous visited pane the tbone target pane
function! tbone#setTargetPane() abort
  " NOTE: tbone#pane_id leaves zoom state of current window
  let g:my_tbone_pane = tbone#pane_id('.last')
  let g:my_tbone_target = ' -t ' . g:my_tbone_pane . ' '
  let g:tbone_write_pane = g:my_tbone_pane
endfunction
nnoremap <silent> <leader>mt :call tbone#setTargetPane() \
  \| Tmux display-panes <cr>

let g:my_tbone_last_command = ''

function! tbone#myClear() abort
  " NOTE: keep spaces in front of these shell commands to keep them out
  " of the history if $HISTCONTROL is set accordingly
  call tbone#send_keys(g:my_tbone_pane, 'C-c')
  call tbone#send_keys(g:my_tbone_pane, ' ####################')
  call tbone#send_keys(g:my_tbone_pane, 'C-c')
  call tbone#send_keys(g:my_tbone_pane, 'C-m')
  " clear screen and add terminal scrollback gap
  call tbone#send_keys(g:my_tbone_pane, ' printf "\33[2J"')
  call tbone#send_keys(g:my_tbone_pane, 'C-m')
endfunction

function! tbone#myRun() abort
  if get(b:, 'my_tbone_clear', '')
    call tbone#myClear()
  endif
  let cmd = getreg('z')
  let g:my_tbone_last_command = cmd
  if cmd !~ '\n$'
    let cmd = cmd .. "\r"
  endif
  call tbone#send_keys(g:my_tbone_pane, cmd)
  silent! normal! `z
endfunction

nnoremap <silent> <leader>mm mz"zyip:call tbone#myRun()<cr>
vnoremap <silent> <leader>mm mz"zy:call tbone#myRun()<cr>
nnoremap <silent> <leader>mM mz"zyy:call tbone#myRun()<cr>

nnoremap <silent> <leader>ml :call setreg('z', g:my_tbone_last_command) \| :call tbone#myRun()<cr>

nnoremap <silent> <leader>mc :call tbone#myClear()<cr>

" open new shell in current buffer's directory
nnoremap <silent> <leader>md :execute ":Tmux split-window -v 'cd " . expand('%:h') . " && bash -i'"<cr>

function! tbone#mySendRaw() abort
  let g:my_tbone_last_command = getreg('z')
  call tbone#send_keys(g:my_tbone_pane, g:my_tbone_last_command)
endfunction
nnoremap <silent> <leader>mr "zyip:call tbone#mySendRaw()<cr>
nnoremap <silent> <leader>mR "zyy:call tbone#mySendRaw()<cr>
" nmap to keep pos on yip
" nmap <silent> <leader>mp "zyip:let @z .= "\r" \| call tbone#mySendRaw()<cr>
" nmap <silent> <cr> "zyip:call tbone#mySendRaw()<cr>
" nnoremap <silent> <leader>mw "zyiW: let @z .= ' ' \| call tbone#mySendRaw()<cr>
" vnoremap <silent> <leader>mw "zy:call tbone#mySendRaw()<cr>

