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
" TODO
let g:EasyGrepJumpToMatch=0

" Specifies the mode in which to start.
" 0 - All files
" 1 - Open Buffers
" 2 - Track the current extension
" 3 - User mode -- Use a custom, on demand set of extensions
let g:EasyGrepMode=2

" disable default mappings
let g:EasyGrepOptionPrefix=''

" Grep for the word under the cursor, match all occurences,
" like 'g*'.  See ":help gstar".
nnoremap <Leader>gg :Grep <cword><cr>

" Grep for the word under the cursor, match whole word, like
" '*'.  See ":help star".
nnoremap <Leader>gG :Grep! <cword><cr>

" Like vv, but add to existing list.
nnoremap <Leader>ga :GrepAdd <cword><cr>

" Like vV, but add to existing list.
nnoremap <Leader>gA :GrepAdd! <cword><cr>

" Perform a global search on the word under the cursor
" and prompt for a pattern with which to replace it.
" TODO
nnoremap <Leader>gr :Replace <cword> 

" Like vr, but match whole word.
" TODO
nnoremap <Leader>gR :Replace! <cword> 

" Open an options explorer to select the files to search in and
" set grep options.
nnoremap <Leader>go :GrepOptions<cr>
