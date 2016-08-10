finish
" A secure alternative to modelines

" Needed for dbext.vim
" let g:secure_modelines_leave_modeline = 1

" let g:secure_modelines_verbose = 1

let g:secure_modelines_allowed_items = [
                \ "readonly",    "ro",
                \ ]

set modelines=5

NeoBundle 'securemodelines'
