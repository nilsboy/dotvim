finish
" let g:LanguageClient_serverCommands = {
"     \ 'javascript': ['javascript-typescript-stdio'],
"     \ }

let g:LanguageClient_serverCommands = {
    \ 'java': ['java', '-cp', '/home/nilsb/.vim/var/vscode-javac/out/fat-jar.jar', 'org.javacs.Main' ]
    \ }

" let g:LanguageClient_autoStart = 1
let g:LanguageClient_trace = 'verbose'

" Language Server Protocol (LSP) support
NeoBundle 'autozimu/LanguageClient-neovim', 'next', { 'build': 'bash install.sh' }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <leader>lR :call LanguageClient_textDocument_rename()<CR>
