finish
" This plugin provides mappings to jump to the borders and next [count] occurrences of text parsed as the same syntax as under the cursor.

" dependency
PackAdd inkarkat/vim-ingo-library 

" complains if it does not exist
let g:CountJump_TextObjectContext = {}

" dependency
PackAdd vim-scripts/CountJump

let g:SameSyntaxMotion_BeginMapping = 'x'
let g:SameSyntaxMotion_EndMapping = 'X'

let g:SameSyntaxMotion_TextObjectMapping = 'x'

PackAdd inkarkat/vim-SameSyntaxMotion

