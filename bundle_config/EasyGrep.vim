finish
" Fast and Easy Find and Replace Across Multiple Files

" NeoBundleLazy 'EasyGrep', {'autoload':{'commands':'GrepOptions'}}
NeoBundle 'EasyGrep'
let g:EasyGrepRecursive=1
let g:EasyGrepAllOptionsInExplorer=1
let g:EasyGrepCommand=1
let g:EasyGrepIgnoreCase=1
let g:EasyGrepFilesToExclude=".git"
let g:EasyGrepFileAssociationsInExplorer=1
let g:EasyGrepSearchCurrentBufferDir=1
let g:EasyGrepFileAssociations= g:vim.config.dir . "EasyGrepFileAssociations"

" TODO
let g:EasyGrepJumpToMatch=0

" 0 - vimgrep
" 1 - grep (follows grepprg)
let g:EasyGrepCommand=1

" Specifies the mode in which to start.
" 0 - All files
" 1 - Open Buffers
" 2 - Track the current extension
" 3 - User mode -- Use a custom, on demand set of extensions
let g:EasyGrepMode=2

" disable default mappings
" let g:EasyGrepOptionPrefix=''

vmap <silent> <leader>gR <Plug>EgMapReplaceSelection_R
nmap <silent> <leader>gR <Plug>EgMapReplaceCurrentWord_R
omap <silent> <leader>gR <Plug>EgMapReplaceCurrentWord_R
vmap <silent> <leader>gr <Plug>EgMapReplaceSelection_r
nmap <silent> <leader>gr <Plug>EgMapReplaceCurrentWord_r
omap <silent> <leader>gr <Plug>EgMapReplaceCurrentWord_r
vmap <silent> <leader>gA <Plug>EgMapGrepSelection_A
nmap <silent> <leader>gA <Plug>EgMapGrepCurrentWord_A
omap <silent> <leader>gA <Plug>EgMapGrepCurrentWord_A
vmap <silent> <leader>ga <Plug>EgMapGrepSelection_a
nmap <silent> <leader>ga <Plug>EgMapGrepCurrentWord_a
omap <silent> <leader>ga <Plug>EgMapGrepCurrentWord_a
vmap <silent> <leader>gG <Plug>EgMapGrepSelection_V
nmap <silent> <leader>gG <Plug>EgMapGrepCurrentWord_V
omap <silent> <leader>gg <Plug>EgMapGrepCurrentWord_V
vmap <silent> <leader>gg <Plug>EgMapGrepSelection_v
nmap <silent> <leader>gg <Plug>EgMapGrepCurrentWord_v
omap <silent> <leader>gg <Plug>EgMapGrepCurrentWord_v
map  <silent> <leader>go <Plug>EgMapGrepOptions
