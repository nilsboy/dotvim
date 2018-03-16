" async language server protocol plugin
NeoBundle 'prabirshrestha/async.vim'
NeoBundle 'prabirshrestha/vim-lsp' , {
      \ 'build': { 'unix': 'npm install -g javascript-typescript-langserver' }
      \}

" let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_signs_enabled = 1
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/tmp/vim-lsp.log')

if (executable('javascript-typescript-stdio'))
    au User lsp_setup call lsp#register_server({
  \ 'name': 'javascript-typescript-stdio',
  \ 'cmd': {server_info->['javascript-typescript-stdio']},
  \ 'whitelist': ['javascript']
  \ })
endif
