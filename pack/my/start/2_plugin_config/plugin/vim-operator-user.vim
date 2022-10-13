finish
" Define your own operator easily
PackAdd kana/vim-operator-user

map L <Plug>(operator-echo)
call operator#user#define('echo', 'Op_command_right')
function! Op_command_right(motion_wiseness)
  normal! `[,`]"zy
  execute 'echo "hahah - ' . getreg("z") . '"'
endfunction
