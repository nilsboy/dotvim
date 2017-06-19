" Tern plugin for Vim
NeoBundleLazy 'marijnh/tern_for_vim', {
  \ 'autoload': { 'filetypes': ['javascript', 'html'] },
  \ 'build': {
    \ 'unix': 'npm install',
  \ },
\ }

" see also file: ~/.tern-project

" For deoplete?
let g:tern_request_timeout = 1

let g:tern_show_signature_in_pum = 1

autocmd FileType javascript nmap <buffer> gd :TernDef<cr>
autocmd FileType javascript nmap <buffer> <leader>lr  :TernRefs<cr>
autocmd FileType javascript nmap <buffer> <leader>lR :TernRename<cr>
