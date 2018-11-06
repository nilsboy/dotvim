" Intellisense engine for neovim, featured language server support as VSCode
" TAGS: completion

MyInstall yarn !npm install -g yarn

" call PackAdd('neoclide/coc.nvim', {'do': { -> coc#util#install()}})
call minpac#add('neoclide/coc.nvim', {'type': 'opt', 'do': {-> coc#util#install()}})
packadd coc.nvim

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
nmap <leader>lF :call CocAction('format')
vmap <leader>la <Plug>(coc-codeaction-selected)
nmap <leader>la <Plug>(coc-codeaction-selected)
nmap <leader>lA <Plug>(coc-codeaction)
nmap <leader>lD :call CocAction('fold', <f-args>)
inoremap <expr> <c-space> coc#refresh()
nnoremap K :call CocAction('doHover')<cr>

" Use <C-x><C-o> to complete 'word', 'emoji' and 'include' sources
" imap <silent> <C-x><C-o> <Plug>(coc-complete-custom)

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> for confirm completion.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Show signature help while editing
autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
