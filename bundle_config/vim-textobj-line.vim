finish
" TODO: make changed mappings work to not interfere with targets.vim
let g:textobj_line_no_default_key_mappings = 1

" Text objects for the current line
NeoBundle 'kana/vim-textobj-line'

if neobundle#tap('vim-textobj-line') 
  function! neobundle#hooks.on_post_source(bundle) abort

    call textobj#user#plugin('line', {
    \      '-': {
    \        'select-a': 'a<space>l', 'select-a-function': 'textobj#line#select_a',
    \        'select-i': 'i<space>l', 'select-i-function': 'textobj#line#select_i',
    \      },
    \    })

endfunction
  call neobundle#untap()
endif
