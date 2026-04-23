finish
" NOTE: adds scroll lag at least near the end of the file
PackAdd Aasim-A/scrollEOF.nvim

let scrolloff = 3
lua require('scrollEOF').setup()
