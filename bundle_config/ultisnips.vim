" The ultimate snippet solution for Vim.
NeoBundle 'SirVer/ultisnips'

" vim-snipmate default snippets
NeoBundle 'honza/vim-snippets'

" let g:UltiSnipsExpandTrigger="<leader>se"
" let g:UltiSnipsJumpForwardTrigger="<space>"
let g:UltiSnipsJumpForwardTrigger="<cr>"
let g:UltiSnipsJumpBackwardTrigger="<leader>p"
let g:UltiSnipsListSnippets = "<leader>sl"

" let g:UltiSnipsUsePythonVersion = 2

" Edit snippets for current file type
" :UltiSnipsEdit
" has weird suggestions
nnoremap <leader>ss :execute ":e " . g:vim.etc.dir . "UltiSnips/" . &filetype
            \ . ".snippets"<cr>
nnoremap <leader>sa :execute ":e " . g:vim.etc.dir . "UltiSnips/all.snippets"<cr>

" https://www.reddit.com/r/vim/comments/2oeqrg
function! ExpandSnippet()
    if delimitMate#WithinEmptyPair()
        return "\<C-R>=delimitMate#ExpandReturn()\<CR>"
    else
        call UltiSnips#ExpandSnippet()
        if g:ulti_expand_res == 0
            return "\<CR>"
        endif
    endif
    return ""
endfunction
inoremap <expr> <CR> "\<C-R>=ExpandSnippet()\<CR>"
