" Needs to be loaded after vim-sneak to not clobber s-mappings:
" https://github.com/svermeulen/vim-easyclip/issues/60

" Simplified clipboard functionality for Vim
NeoBundle 'svermeulen/vim-easyclip'

let g:EasyClipUseSubstituteDefaults = 0

" let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
let g:EasyClipAutoFormat = 0
" nmap <leader>cf <plug>EasyClipToggleFormattedPaste
" let g:EasyClipAlwaysMoveCursorToEndOfPaste

nnoremap <silent> gs <plug>SubstituteOverMotionMap
nnoremap gss <plug>SubstituteLine
xnoremap gs  <plug>XEasyClipPaste

" Store yanks to file
" let g:EasyClipShareYanks = 1
" let g:EasyClipShareYanksFile = ...
