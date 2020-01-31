finish
" The missing motion for Vim
" TAGS: motion search

let g:sneak#prompt = 'sneak> '

let g:sneak#use_ic_scs = 1
let g:sneak#s_next = 0

" exclude R as target label:
let g:sneak#target_labels = ";sftunq/SFGHLTUNMQZ?0"

let g:sneak#label = 1
autocmd ColorScheme * hi! link Sneak TabLineSel
autocmd ColorScheme * hi! link SneakScope TabLineSel

" " Configure "f" to trigger label-mode:
" nnoremap <silent> f :<C-U>call sneak#wrap('',           1, 0, 1, 1)<CR>
" nnoremap <silent> F :<C-U>call sneak#wrap('',           1, 1, 1, 1)<CR>
" xnoremap <silent> f :<C-U>call sneak#wrap(visualmode(), 1, 0, 1, 1)<CR>
" xnoremap <silent> F :<C-U>call sneak#wrap(visualmode(), 1, 1, 1, 1)<CR>
" onoremap <silent> f :<C-U>call sneak#wrap(v:operator,   1, 0, 1, 1)<CR>
" onoremap <silent> F :<C-U>call sneak#wrap(v:operator,   1, 1, 1, 1)<CR>

" " Configure "t" to trigger label-mode:
" nnoremap <silent> t :<C-U>call sneak#wrap('',           1, 0, 0, 1)<CR>
" nnoremap <silent> T :<C-U>call sneak#wrap('',           1, 1, 0, 1)<CR>
" xnoremap <silent> t :<C-U>call sneak#wrap(visualmode(), 1, 0, 0, 1)<CR>
" xnoremap <silent> T :<C-U>call sneak#wrap(visualmode(), 1, 1, 0, 1)<CR>
" onoremap <silent> t :<C-U>call sneak#wrap(v:operator,   1, 0, 0, 1)<CR>
" onoremap <silent> T :<C-U>call sneak#wrap(v:operator,   1, 1, 0, 1)<CR>

" " Configure "s" to wait for 3 characters:
" nnoremap <silent> s :<C-U>call sneak#wrap('',           3, 0, 2, 0)<CR>
" nnoremap <silent> S :<C-U>call sneak#wrap('',           3, 1, 2, 0)<CR>
" xnoremap <silent> s :<C-U>call sneak#wrap(visualmode(), 3, 0, 2, 0)<CR>
" xnoremap <silent> S :<C-U>call sneak#wrap(visualmode(), 3, 1, 2, 0)<CR>
" onoremap <silent> s :<C-U>call sneak#wrap(v:operator,   3, 0, 2, 0)<CR>
" onoremap <silent> S :<C-U>call sneak#wrap(v:operator,   3, 1, 2, 0)<CR>

PackAdd justinmk/vim-sneak
