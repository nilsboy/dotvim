" Changes Vim working directory to project root
NeoBundle 'airblade/vim-rooter'

" To prevent vim-rooter from creating a mapping, do this:
let g:rooter_disable_map = 1

" Don't echo the project directory
let g:rooter_silent_chdir = 1

let g:rooter_patterns = ['package.json', '.git/']

let g:rooter_change_directory_for_non_project_files = 'current'

" Needed otherwise the preview window changes the pwd of the current buffer
let g:rooter_use_lcd = 1

" let g:rooter_manual_only = 1

finish

" Try to work around relative paths in unite
augroup VimRooterChdir
  autocmd WinEnter * call VimRooterChdir()
augroup end

function! VimRooterChdir() abort
  if &previewwindow
    return
  endif
  if !empty(&buftype)
    return
  endif
  call CdProjectRoot()
endfunction
