" Intellisense engine for neovim, featured language server support as VSCode
" TAGS: completion
"
" SEE ALSO: ./coc-settings.json
" SEE ALSO: ./pack/minpac/opt/coc.nvim/data/schema.json
"
" SEE ALSO: https://github.com/neoclide/coc-sources
" SEE ALSO: https://www.npmjs.com/search?q=coc-

function! MyCocInstall(...) abort
  MyInstall yarn !npm install -g yarn
  !yarn install --frozen-lockfile
endfunction

call PackAdd('neoclide/coc.nvim', {'do': {-> MyCocInstall()}})
call coc#add_extension('coc-tsserver')
call coc#add_extension('coc-ultisnips')

nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>lt <Plug>(coc-type-definition)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>lD <Plug>(coc-diagnostic-info)
nmap <silent> <leader>lr <Plug>(coc-references)
nmap <silent> <leader>lp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>ln <Plug>(coc-diagnostic-next)
nmap <silent> <leader>lR <Plug>(coc-rename)
vmap <silent> <leader>lF <Plug>(coc-format-selected)
nmap <silent> <leader>lf :call CocAction('format')<cr>
vmap <silent> <leader>lA <Plug>(coc-codeaction-selected)
nmap <silent> <leader>la <Plug>(coc-codeaction)
nmap <silent> <leader>lO :call CocAction('fold', <f-args>)<cr>
nnoremap <silent> <leader>lK :call CocAction('doHover')<cr>

" inoremap <silent> <expr> <c-space> coc#refresh()

" Show signature help while editing
augroup MyCocAugroupCoc
  autocmd!
  autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

augroup MyCocAugroupFixColors
  autocmd!
  autocmd ColorScheme,Syntax,FileType * call MyCocFixColors()
augroup END

function! MyCocFixColors() abort
  highlight link CocWarningHighlight normal
  highlight link CocWarningVirtualText normal
  highlight link CocErrorVirtualText normal
  highlight link CocWarningVirtualText normal
  highlight link CocInfoVirtualText normal
  highlight link CocHintVirtualText normal
  highlight link CocErrorHighlight normal
  highlight link CocWarningHighlight normal
  highlight link CocInfoHighlight normal
  highlight link CocHintHighlight normal
  highlight link CocHighlightRead normal
  highlight link CocHighlightWrite normal
  highlight link CocErrorFloat normal
  highlight link CocWarningFloat normal
  highlight link CocInfoFloat normal
  highlight link CocHintFloat normal
  highlight link CocCursorRange normal
  highlight link CocHoverRange normal
endfunction
