" tbone.vim: tmux basics
NeoBundle 'tpope/vim-tbone'
" TAGS: tmux shell command line

" SEE ALSO: https://github.com/idanarye/vim-terminalogy
" SEE ALSO: https://github.com/kassio/neoterm
" SEE ALSO: https://github.com/hkupty/nvimux
" SEE ALSO: https://github.com/kabbamine/zeavim.vim

" Note: can only send via range not via motion

" Note: To send one line plus additional enter to pane 3:
" :'<,'>Tyank 3
" :Tmux send-keys -t 3 enter

" default to paste to pane 3 for now
let g:tbone_write_pane = 3

vnoremap <silent> <leader><cr> y:silent call tbone#write_command2(@")<cr>
nnoremap <silent> <leader><cr> yip:silent call tbone#write_command2(@")<cr>
nnoremap <silent> <leader><cr> yy:silent call tbone#write_command2(@")<cr>

command! -nargs=* ExecuteOnInsertEnter call ExecuteOnInsertEnter(<f-args>)
function! ExecuteOnInsertEnter(...) abort
  inoremap <silent> <buffer> <cr> <esc>yy:call tbone#executeOnInsertEnter(@")<cr>
endfunction

function! tbone#executeOnInsertEnter(line) abort
  call tbone#write_command2(a:line)
  normal! o
  startinsert!
endfunction

" simplified version of the included write_command that just takes a value
" instead of a range
function! tbone#write_command2(value) abort
  let keys = join(split(a:value, "\n"), "\r") . "\r"
  try
    let pane_id = tbone#send_keys(g:tbone_write_pane, keys)
    let g:tbone_write_pane = pane_id
    echo len(keys).' keys sent to '.pane_id
    return ''
  catch /.*/
    return 'echoerr '.string(v:exception)
  endtry
endfunction
