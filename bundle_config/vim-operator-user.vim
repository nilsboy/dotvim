" Define your own operator easily
NeoBundle 'kana/vim-operator-user', { 'name': 'vim-operator-user' }

finish

if neobundle#tap('vim-operator-user') 
  function! neobundle#hooks.on_post_source(bundle) abort

    map _  <Plug>(operator-adjust)
    call operator#user#define('adjust', 'Op_adjust_window_height')
    function! Op_adjust_window_height(motion_wiseness)
      execute (line("']") - line("'[") + 1) 'wincmd' '_'
      normal! `[zt
    endfunction

  endfunction
  call neobundle#untap()
endif

