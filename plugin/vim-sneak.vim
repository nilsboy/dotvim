" The missing motion for Vim
" TAGS: motion search

let g:sneak#prompt = 'sneak> '

" let g:sneak#absolute_dir = 0
let g:sneak#use_ic_scs = 1
let g:sneak#s_next = 0

" exclude R as target label:
let g:sneak#target_labels = ";sftunq/SFGHLTUNMQZ?0"

" " 1-character enhanced 'f'
" nmap f <Plug>Sneak_f
" nmap F <Plug>Sneak_F
" " visual-mode
" xmap f <Plug>Sneak_f
" xmap F <Plug>Sneak_F
" " operator-pending-mode
" omap f <Plug>Sneak_f
" omap F <Plug>Sneak_F

" 1-character enhanced 't'
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
" visual-mode
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
" operator-pending-mode
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

autocmd ColorScheme * hi! link Sneak TabLineSel
" autocmd ColorScheme * hi! link SneakLabel TabLineSel

let g:sneak#label = 1
nmap s <Plug>SneakLabel_s
nmap S <Plug>SneakLabel_S

" let g:sneak#label = 1
" nmap s <Plug>Sneak_s
" nmap S <Plug>Sneak_S

" Configure "f" to trigger label-mode:
nnoremap <silent> f :<C-U>call sneak#wrap('',           1, 0, 1, 1)<CR>
nnoremap <silent> F :<C-U>call sneak#wrap('',           1, 1, 1, 1)<CR>
xnoremap <silent> f :<C-U>call sneak#wrap(visualmode(), 1, 0, 1, 1)<CR>
xnoremap <silent> F :<C-U>call sneak#wrap(visualmode(), 1, 1, 1, 1)<CR>
onoremap <silent> f :<C-U>call sneak#wrap(v:operator,   1, 0, 1, 1)<CR>
onoremap <silent> F :<C-U>call sneak#wrap(v:operator,   1, 1, 1, 1)<CR>

" Configure "s" to wait for 3 characters:
nnoremap <silent> s :<C-U>call sneak#wrap('',           3, 0, 2, 1)<CR>
nnoremap <silent> S :<C-U>call sneak#wrap('',           3, 1, 2, 1)<CR>
xnoremap <silent> s :<C-U>call sneak#wrap(visualmode(), 3, 0, 2, 1)<CR>
xnoremap <silent> S :<C-U>call sneak#wrap(visualmode(), 3, 1, 2, 1)<CR>
onoremap <silent> s :<C-U>call sneak#wrap(v:operator,   3, 0, 2, 1)<CR>
onoremap <silent> S :<C-U>call sneak#wrap(v:operator,   3, 1, 2, 1)<CR>

PackAdd justinmk/vim-sneak
