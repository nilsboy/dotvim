finish
" indent-level based motion
PackAdd jeetsukumaran/vim-indentwise

let g:indentwise_equal_indent_skips_contiguous = 1
let g:indentwise_skip_blanks = 1
let g:indentwise_blanks_have_null_indentation = 0
let g:indentwise_treat_whitespace_as_blank = 0
let g:indentwise_suppress_keymaps = 1
let g:indentwise_preserve_col_pos = 0
map { <Plug>(IndentWisePreviousEqualIndent)
map } <Plug>(IndentWiseNextEqualIndent)
map ( <Plug>(IndentWisePreviousLesserIndent)
map ) <Plug>(IndentWiseNextLesserIndent)

" nmap { <Plug>(IndentWisePreviousLesserIndent)
" nmap } <Plug>(IndentWiseNextGreaterIndent)

finish

nmap [- <Plug>(IndentWisePreviousLesserIndent)
nmap ]- <Plug>(IndentWiseNextLesserIndent)

nmap [= <Plug>(IndentWisePreviousEqualIndent)
nmap ]= <Plug>(IndentWiseNextEqualIndent)

nmap [+ <Plug>(IndentWisePreviousGreaterIndent)
nmap ]+ <Plug>(IndentWiseNextGreaterIndent)

nmap [_ <Plug>(IndentWisePreviousAbsoluteIndent)
nmap ]_ <Plug>(IndentWiseNextAbsoluteIndent)

nmap [% <Plug>(IndentWiseBlockScopeBoundaryBegin)
nmap ]% <Plug>(IndentWiseBlockScopeBoundaryEnd)

