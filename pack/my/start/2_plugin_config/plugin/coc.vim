" Intellisense engine for neovim, featured language server support as VSCode
" TAGS: completion
" SEE ALSO: ./coc-settings.json
" SEE ALSO: Additional sources: https://github.com/neoclide/coc-sources
" SEE ALSO: ./pack/minpac/opt/coc.nvim/data/schema.json
" SEE ALSO: https://www.npmjs.com/search?q=keywords%3Acoc.nvim

" TODO: use add_extension instead:
" call coc#add_extension( \ 'coc-json', \ 'coc-tsserver', \ ... \)
" (https://old.reddit.com/r/vim/comments/cde9s8/dipping_into_cocvim_and_before_i_fall_into_the/)
function! MyCocInstall(...) abort
  MyInstall yarn !npm install -g yarn
  !yarn install
  " !yarn add coc-ultisnips coc-tsserver coc-json coc-java coc-yaml --ignore-engines
  !yarn add coc-tsserver coc-json coc-java coc-yaml --ignore-engines
endfunction

" let s:nodes = sort(
"       \ map(
"       \   glob($HOME . '/.nvm/versions/node/v*', 0, 1)
"       \   , { k, v -> str2float(substitute(v, '.*v', '', 'g')) }
"       \ ), 'f')
" if len(s:nodes) > 0
"   let g:coc_node_path = $HOME . '/.nvm/versions/node/v' . string(s:nodes[-1]) . '/bin/node'
" endif

let g:coc_node_path = $HOME . '/.nvm/versions/node/v12.4.0/bin/node'

call PackAdd('neoclide/coc.nvim', {'do': {-> MyCocInstall()}})

nmap <leader>ld <Plug>(coc-definition)
nmap <leader>lt <Plug>(coc-type-definition)
nmap <leader>li <Plug>(coc-implementation)
nmap <leader>lD <Plug>(coc-diagnostic-info)
nmap <leader>lr <Plug>(coc-references)
nmap <leader>lp <Plug>(coc-diagnostic-prev)
nmap <leader>ln <Plug>(coc-diagnostic-next)
nmap <leader>lR <Plug>(coc-rename)
vmap <leader>lF <Plug>(coc-format-selected)
nmap <leader>lf :call CocAction('format')<cr>
vmap <leader>lA <Plug>(coc-codeaction-selected)
nmap <leader>la <Plug>(coc-codeaction)
nmap <leader>lO :call CocAction('fold', <f-args>)<cr>
nnoremap <silent> <leader>lK :call CocAction('doHover')<cr>
inoremap <silent> <expr> <c-space> coc#refresh()

" Show signature help while editing
augroup MyCocAugroupCoc
  autocmd!
  autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

" " Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'
