finish
" Tern plugin for Vim
NeoBundleLazy 'marijnh/tern_for_vim', {
  \ 'autoload': { 'filetypes': ['javascript'] },
  \ 'build': {
    \ 'unix': 'npm install',
  \ },
\ }

let g:tern_map_keys=1

" also see updatetime
let g:tern_show_argument_hints='on_move'

let g:tern_show_signature_in_pum=1

autocmd FileType javascript nmap <buffer> gd :TernDef<cr>
autocmd FileType javascript nmap <buffer> ,c :TernRefs<cr>
" autocmd FileType javascript nmap <buffer> <leader>rr :TernRename<cr>
