" Changes Vim working directory to project root
NeoBundle 'airblade/vim-rooter'

" To prevent vim-rooter from creating a mapping, do this:
let g:rooter_disable_map = 1

" Don't echo the project directory
let g:rooter_silent_chdir = 1

let g:rooter_patterns = ['package.json', '.git', '.git/']

let g:rooter_change_directory_for_non_project_files = 'current'

" Needed otherwise the preview window changes the pwd of the current buffer
let g:rooter_use_lcd = 1

" let g:rooter_manual_only = 1

" augroup augroup_vim-rooter
"   autocmd!
"   autocmd User RooterChDir execute 'setlocal path=' . getcwd()
" augroup END

" default version of vim-rooter:
" augroup augroup_vim-rooter
"   autocmd!
"   autocmd VimEnter,BufEnter * :Rooter
" augroup END

" function! MyVimRooter_chdir() abort
"   let dir = expand('%:h')
"   call INFO('dir:', dir)
"   if dir =~ "notes/"
"     return
"   endif
"   Rooter
" endfunction
