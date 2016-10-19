" Simplified clipboard functionality for Vim
NeoBundle 'svermeulen/vim-easyclip'

" Needs to be loaded after vim-sneak to not clobber s-mappings:
" https://github.com/svermeulen/vim-easyclip/issues/60

" Does not seam to have an effect
let g:EasyClipUseSubstituteDefaults = 0

let g:EasyClipAutoFormat = 0

" let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
let g:EasyClipPreserveCursorPositionAfterYank = 1

" Store yanks to file
let g:EasyClipShareYanksDirectory = g:vim.var.dir . "/easyclip"
let g:EasyClipShareYanksFile = "shared-yanks"
call _mkdir(g:EasyClipShareYanksDirectory)
let g:EasyClipShareYanks = 1
