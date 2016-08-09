" The ultimate snippet solution for Vim.
NeoBundle 'SirVer/ultisnips'

" vim-snipmate default snippets
NeoBundle 'honza/vim-snippets'

let g:UltiSnipsExpandTrigger=",s"
let g:UltiSnipsJumpForwardTrigger=",,"
let g:UltiSnipsJumpBackwardTrigger=",p"
" let g:UltiSnipsListSnippets = ',sl'

inoremap ,, <esc>}2o
inoremap ,p <esc>

" Edit snippets for current file type
" :UltiSnipsEdit has weird suggestions
nnoremap ,ls :execute ":e " . g:vim.etc.dir . "UltiSnips/" . &filetype
            \ . ".snippets"<cr>
