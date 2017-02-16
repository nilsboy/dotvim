" The ultimate snippet solution for Vim.
NeoBundle 'SirVer/ultisnips'

" Example snippet files:
" https://github.com/honza/vim-snippets/tree/master/UltiSnips

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" let g:UltiSnipsListSnippets = "<c-space>"

nnoremap <silent><leader>se :execute ":e " 
      \ . g:vim.etc.dir . "UltiSnips/" . &filetype
      \ . ".snippets"<cr>
nnoremap <leader>sE :UltiSnipsEdit!<cr>
nnoremap <leader>sa :execute ":e " . g:vim.etc.dir . 
      \ "UltiSnips/all.snippets"<cr>
nnoremap <leader>sf :execute ":Explore " . g:vim.etc.dir . "UltiSnips/"<cr>

finish

" This seems to mess up completion in i.e. the command window
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

