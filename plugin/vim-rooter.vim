" Changes Vim working directory to project root
PackAdd airblade/vim-rooter

" No default mappings
let g:rooter_disable_map = 1

" Don't echo the project directory
let g:rooter_silent_chdir = 1

let g:rooter_patterns = ['package.json', '.git', '.git/']

" let g:rooter_change_directory_for_non_project_files = 'current'

" Needed otherwise the preview window changes the pwd of the current buffer
let g:rooter_use_lcd = 1

" let g:rooter_manual_only = 1

" augroup MyRooterAugroupChdir
"   autocmd!
"   autocmd User RooterChDir call MyRooterChdir()
" augroup END

" function! MyRooterChdir() abort
"   call INFO('getcwd():', getcwd())
"   return
"   let dir = expand('%:p:h')
"   if dir =~ "/tmp"
"     return
"   endif
"   call INFO('rooting to ' . dir)
"   Rooter
" endfunction