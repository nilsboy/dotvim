finish
" A handy buffer switcher
NeoBundle 'bsdelf/bufferhint'

let g:bufferhint_SortMode = 0
let g:bufferhint_KeepWindow = 1

nnoremap <leader>c :call bufferhint#Popup()<CR>
