" Changes Vim working directory to project root
PackAdd airblade/vim-rooter

let g:start_cwd = getcwd()

" No default mappings
let g:rooter_disable_map = 1

" Don't echo the project directory
let g:rooter_silent_chdir = 1
let g:rooter_use_lcd = 1

let g:rooter_patterns = ['.force-project-root', '.myroot', 'package.json', '.git', '.git/', '.project' ]

" Make parent dir the root
nnoremap <silent> <leader>vR :call MyRooterCd()<cr>
function! MyRooterCd() abort
  let rootDir = getbufvar('%', 'rootDir')
  if rootDir == ''
    let rootDir = getcwd()
  endif
  let rootDir = fnamemodify(rootDir, ':h')
  call setbufvar('%', 'rootDir', rootDir)
  Rooter
endfunction

let g:rooter_change_directory_for_non_project_files = 'current'

" " overwrite function to also change dir for help buffers
" let s:sid = nb#findScriptId('vim-rooter/plugin/rooter.vim')
" function! <SNR>{s:sid}_ChangeDirectoryForBuffer()
"   return 1
" endfunction
