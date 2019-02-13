" Intellisense engine for neovim, featured language server support as VSCode
" TAGS: completion
" See also: ./coc-settings.json

MyInstall yarn !npm install -g yarn

call minpac#add('neoclide/coc.nvim', {'type': 'opt',
      \ 'do': {-> coc#util#install()}})

packadd coc.nvim
" CocInstall coc-ultisnips

" :CocInstall coc-java
" :CocInstall coc-tsserver
" :CocInstall coc-json

nmap <leader>ld <Plug>(coc-definition)
nmap <leader>lt <Plug>(coc-type-definition)
nmap <leader>li <Plug>(coc-implementation)
nmap <leader>lD <Plug>(coc-diagnostic-info)
nmap <leader>lr <Plug>(coc-references)
nmap <leader>lp <Plug>(coc-diagnostic-prev)
nmap <leader>ln <Plug>(coc-diagnostic-next)
nmap <leader>lR <Plug>(coc-rename)
vmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>lF :call CocAction('format')<cr>
vmap <leader>la <Plug>(coc-codeaction-selected)
nmap <leader>la <Plug>(coc-codeaction-selected)
nmap <leader>lA <Plug>(coc-codeaction)
nmap <leader>lD :call CocAction('fold', <f-args>)<cr>
nnoremap <silent> <leader>lh :call CocAction('doHover')<cr>
inoremap <silent> <expr> <c-space> coc#refresh()

" Show signature help while editing
autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'
