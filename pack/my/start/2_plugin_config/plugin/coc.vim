" Intellisense engine for neovim, featured language server support as VSCode
" TAGS: completion
" SEE ALSO: ./coc-settings.json
" SEE ALSO: Additional sources: https://github.com/neoclide/coc-sources
" SEE ALSO: ./pack/minpac/opt/coc.nvim/data/schema.json
" SEE ALSO: https://www.npmjs.com/search?q=keywords%3Acoc.nvim

function! MyCocInstall(...) abort
  MyInstall yarn !npm install -g yarn
  !yarn install
  " !yarn add coc-ultisnips coc-tsserver coc-json coc-java coc-yaml --ignore-engines
  !yarn add coc-tsserver coc-json coc-java coc-yaml --ignore-engines
endfunction

call PackAdd('neoclide/coc.nvim', {'do': {-> MyCocInstall()}})

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

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'
