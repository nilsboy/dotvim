finish
" let g:LanguageClient_serverCommands = {
"     \ 'javascript': ['javascript-typescript-stdio'],
"     \ }

" NOTE: make sure to include the shebang if using scripts here!
let g:LanguageClient_serverCommands = {
    \ 'java': ['javacs']
    \ }

" call LanguageClient#debugInfo()

let g:LanguageClient_autoStart = 1
" TODO: checkout using verbose why the plugin listens to keypresses if
" filetype is not supported.
" let g:LanguageClient_trace = 'verbose'
let g:LanguageClient_trace = 'messages'
let g:LanguageClient_trace = 'off'

let g:LanguageClient_loggingLevel = 'WARN'
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'

nnoremap <silent> <leader>lm :call LanguageClient_contextMenu()<cr>
nnoremap <silent> <leader>lK :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> <leader>ld :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <leader>lR :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> <leader>lr :call LanguageClient_textDocument_references()<cr>
nnoremap <silent> <leader>la :call LanguageClient_textDocument_codeAction()<cr>
" TODO: nnoremap <silent> <leader>lc :call LanguageClient_textDocument_completion()<cr>
nnoremap <silent> <leader>lf :call LanguageClient_textDocument_formatting()<cr>
nnoremap <silent> <leader>lh :call LanguageClient_textDocument_documentHighlight()<cr>
nnoremap <silent> <leader>le :call LanguageClient_explainErrorAtPoint()<cr>
" TODO:
" *LanguageClient_workspace_symbol()*
" *LanguageClient_workspace_applyEdit()*
" Example status line making use of |LanguageClient_serverStatusMessage|.

nnoremap <silent> <leader>ls :%s/:/\\r/g<cr>

" Language Server Protocol (LSP) support
" NOTE: The Neobundle install fails without error message because the repo is
" too big - make sure to set:
" let g:neobundle#types#git#clone_depth = 1
NeoBundle 'autozimu/LanguageClient-neovim', 'next', { 'build': 'bash install.sh' }
" NeoBundle 'autozimu/LanguageClient-neovim', { 'build': ':UpdateRemotePlugins' }

" https://old.reddit.com/r/vim/comments/9dg60x/cclsnavigate_semantic_navigation_for_cc/
" nn <silent> xh :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'L'})<cr>
" nn <silent> xj :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'D'})<cr>
" nn <silent> xk :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'U'})<cr>
" nn <silent> xl :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'R'})<cr>

" Support multi projects - by default it seems to stop searching for the
" project root at the first build.gradle.
" TODO: create ticket to fix this
let g:LanguageClient_rootMarkers = {
  \ 'java': ['settings.gradle'],
  \ }

