" Intellisense engine for neovim, featured language server support as VSCode
" TAGS: completion
"
" SEE ALSO: ./coc-settings.json
" SEE ALSO: ./pack/minpac/opt/coc.nvim/data/schema.json
"
" SEE ALSO: https://github.com/neoclide/coc-sources
" SEE ALSO: https://www.npmjs.com/search?q=coc-
"
" NOTE: When reinstalling also run:
"   rm ~/.config/coc/ -rf

function! MyCocInstall(...) abort
  MyInstall yarn npm install -g yarn
  !yarn install --frozen-lockfile
endfunction

" For tsserver:
" > Note: for rename import on file rename, you have to install watchman in your $PATH.
MyInstall watchman pkexec apt install watchman

call PackAdd('neoclide/coc.nvim', {'do': {-> MyCocInstall()}})
call coc#add_extension('coc-tsserver')
call coc#add_extension('coc-ultisnips')
call coc#add_extension('coc-json')
call coc#add_extension('coc-java')
call coc#add_extension('coc-phpls')
call coc#add_extension('coc-yaml')
" TODO: test
" call coc#add_extension('coc-sql')
" TODO: test
" call coc#add_extension('coc-sqlfluff')

nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>lt <Plug>(coc-type-definition)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>lD <Plug>(coc-diagnostic-info)
nmap <silent> <leader>lr <Plug>(coc-references)
nmap <silent> <leader>lp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>ln <Plug>(coc-diagnostic-next)
nmap <silent> <leader>lR <Plug>(coc-rename)
nmap <silent> <leader>lF :CocCommand workspace.renameCurrentFile<cr>
vmap <silent> <leader>lf <Plug>(coc-format-selected)
nmap <silent> <leader>lf :call CocAction('format')<cr>
vmap <silent> <leader>lA <Plug>(coc-codeaction-selected)
nmap <silent> <leader>la <Plug>(coc-codeaction)
nmap <silent> <leader>lc :CocList commands<cr>
nmap <silent> <leader>lO :call CocAction('fold', <f-args>)<cr>
nnoremap <silent> <leader>lK :call CocAction('doHover preview')<cr>
nnoremap <silent> <leader>l? :CocCommand workspace.showOutput<cr>

" workspace errors - i.e. (see filetype file):
" nnoremap <silent> <leader>lw :silent call MakeWith({'name': 'tsc', 'compiler': 'tsc'})<cr>

" nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
" inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
" vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nmap <silent> <leader>lL <Plug>(coc-float-jump)
" nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"  *coc#float#has_float()* 
" nmap <silent> <leader>lL <Plug>(coc-float-hide)

" Preview instead of float not supported everywhere (2021-03-23):
" https://github.com/neoclide/coc.nvim/issues/2233
"
" Workaround attempt:
" - can not hide the float reliably
" - does not update when new entry in popup is selected
"
" augroup coc#augroupHideFloat
"   autocmd!
"   autocmd User CocOpenFloat call coc#myHideFloat()
" augroup END
" function! coc#myHideFloat() abort
"   " call nvim_win_set_config(g:coc_last_float_win, {'relative': 'cursor', 'row': 2, 'col': 70, 'height': 1, 'width': 9999})
"   call nvim_win_set_config(g:coc_last_float_win, {'height': 3, 'width': 9999})
"   " let floatBuffer = nvim_win_get_buf(g:coc_last_float_win)
"   " let lines = nvim_buf_get_lines(floatBuffer, 0, -1, 1)
"   " silent pedit myCocPreview
"   " silent wincmd P
"   " call nvim_buf_set_lines(0, 0, -1, 1, lines)
"   " silent wincmd p
"   " call coc#float#close_all() 
" endfunction

" TODO:
" call coc#config('coc.preferences', {
" 		\ 'timeout': 1000,
" 		\})

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
  highlight link CocErrorHighlight Error
  highlight link CocErrorVirtualText Normal
  highlight link CocErrorFloat Normal

  highlight link CocWarningHighlight WarningMsg
  highlight link CocWarningVirtualText WarningMsg
  highlight link CocWarningFloat Normal

  highlight link CocInfoHighlight SpellBad
  highlight link CocInfoVirtualText MoreMsg
  highlight link CocInfoFloat Normal

  highlight link CocHintHighlight SpellBad
  highlight link CocHintVirtualText MoreMsg
  highlight link CocHintFloat Normal

  highlight link CocHighlightRead Normal
  highlight link CocHighlightWrite Normal

  highlight link CocCursorRange Normal
  highlight link CocHoverRange Normal

  sign define CocError text=\ ┃ texthl=ErrorSign
  sign define CocWarning text=\ ┃ texthl=WarningSign
  sign define CocInfo text=\ ┃ texthl=InfoSign
  sign define CocHint text=\ ┃ texthl=InfoSign
endfunction
