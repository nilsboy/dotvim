PackAdd kana/vim-textobj-user

" Text objects for the current line
PackAdd kana/vim-textobj-line

finish

" let g:textobj_line_no_default_key_mappings = 1

call textobj#user#plugin('line', {
\      '-': {
\        'select-a': 'a<space>l', 'select-a-function': 'textobj#line#select_a',
\        'select-i': 'i<space>l', 'select-i-function': 'textobj#line#select_i',
\      },
\    })
