" async language server protocol plugin
NeoBundle 'prabirshrestha/async.vim'
NeoBundle 'prabirshrestha/vim-lsp'

MyInstall javascript-typescript-stdio !npm install -g javascript-typescript-langserver

" let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_signs_enabled = 1
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/tmp/vim-lsp.log')
" let g:lsp_async_completion = 1

augroup MyLspAugroupInitJavasciptServer
  autocmd!
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'javascript-typescript-stdio',
    \ 'cmd': {server_info->['javascript-typescript-stdio']},
    \ 'whitelist': ['javascript'],
    \ 'config': {},
    \ })
augroup END
