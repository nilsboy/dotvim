finish
" A tree explorer plugin for vim.
NeoBundle 'scrooloose/nerdtree'

" nnoremap <silent><leader>t :NERDTree %:h<CR>
" nnoremap <silent><leader>t :NERDTreeFind<CR>

" |'NERDTreeAutoCenter'|          Controls whether the NERD tree window centers
let g:NERDTreeAutoCenter = 1

" |'NERDTreeCaseSensitiveSort'|   Tells the NERD tree whether to be case
let g:NERDTreeCaseSensitiveSort = 0

" |'NERDTreeQuitOnOpen'|          Closes the tree window after opening a file.
let g:NERDTreeQuitOnOpen = 0

let g:NERDTreeShowHidden = 0

let g:NERDTreeCascadeOpenSingleChildDir = 1

" |'NERDTreeHighlightCursorline'| Tell the NERD tree whether to highlight the
let g:NERDTreeHighlightCursorline = 1

" |'NERDTreeChDirMode'|           Tells the NERD tree if/when it should change

" |'NERDTreeIgnore'|              Tells the NERD tree which files to ignore.
let NERDTreeIgnore=['/node_modules/']

"|'NERDTreeRespectWildIgnore'|   Tells the NERD tree to respect |'wildignore'|.

"|'NERDTreeShowBookmarks'|       Tells the NERD tree whether to display the

"|'NERDTreeShowFiles'|           Tells the NERD tree whether to display files
let g:NERDTreeShowFiles = 1

" |'NERDTreeSortOrder'|           Tell the NERD tree how to sort the nodes in

"|'NERDTreeStatusline'|          Set a statusline for NERD tree windows.
let g:NERDTreeStatusline = -1

"|'NERDTreeWinSize'|             Sets the window size when the NERD tree is

"|'NERDTreeMinimalUI'|           Disables display of the 'Bookmarks' label and 
let g:NERDTreeMinimalUI = 1

" |'NERDTreeDirArrows'|           Tells the NERD tree to use arrows instead of

"|'NERDTreeAutoDeleteBuffer'|    Tells the NERD tree to automatically remove 
