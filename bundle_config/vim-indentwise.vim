finish

" indent-level based motion
NeoBundle 'jeetsukumaran/vim-indentwise'

nmap { <Plug>(IndentWisePreviousLesserIndent)
nmap } <Plug>(IndentWiseNextGreaterIndent)

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

