finish
" async language server protocol plugin
" NOTE: ~/.vim/bundle/vim-lsp/minimal.vimrc
" NOTE: normal mode changes are only refreshed on LSP side when buffer is saved manually.
" (https://github.com/prabirshrestha/vim-lsp/issues/125)
" NOTE: due to missing refresh all actions after a change of the buffer have
" the wrong line and column and thus working with the wrong code.
" PackAdd prabirshrestha/vim-lsp
PackAdd nilsboy/vim-lsp

MyInstall javascript-typescript-stdio npm install -g javascript-typescript-langserver

let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_signs_enabled = 1
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')

nnoremap <silent> <leader>ld :LspDefinition<cr>
nnoremap <silent> <leader>lf :LspDocumentFormat<cr>
nnoremap <silent> <leader>ls :LspDocumentSymbol<cr>
nnoremap <silent> <leader>li :LspImplementation<cr>
nnoremap <silent> <leader>lR :LspRename<cr>
nnoremap <silent> <leader>lt :LspTypeDefinition<cr>
nnoremap <silent> <leader>le :LspDocumentDiagnostics<cr>
nnoremap <silent> <leader>lF :LspDocumentRangeFormat<cr>
nnoremap <silent> <leader>lk :LspHover<cr>
nnoremap <silent> <leader>lp :LspPreviousError<cr>
nnoremap <silent> <leader>ln :LspNextError<cr>
nnoremap <silent> <leader>lr :LspReferences<cr>
nnoremap <silent> <leader>lS :LspStatus<cr>
nnoremap <silent> <leader>lw :LspWorkspaceSymbol<cr>

" NOTE: not implemented jet:
" https://github.com/prabirshrestha/vim-lsp/pull/162
nnoremap <silent> <leader>la :LspCodeAction<cr>

augroup MyLspAugroupInitJavasciptServer
  autocmd!
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'javacs',
    \ 'cmd': {server_info->['javacs']},
    \ 'whitelist': ['java'],
    \ 'config': {},
    \ })
augroup END
