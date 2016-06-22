" Syntax and errors highlighter
NeoBundle 'scrooloose/syntastic'

let g:syntastic_error_symbol = '✗'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_warning_symbol = '≈'

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" jump to first error
let g:syntastic_auto_jump = 1

" to mark lines with errors and warnings
let g:syntastic_enable_signs = 1

" ignore unused variables in js
" let g:syntastic_quiet_messages = {
"     \ "regex":   '\((no-unused-vars\|space-before-function-paren\|comma-dangle)\)' }

