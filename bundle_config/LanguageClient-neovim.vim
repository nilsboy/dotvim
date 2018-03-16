finish
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ }

let g:LanguageClient_autoStart = 1
let g:LanguageClient_trace = 'verbose'

" Language Server Protocol (LSP) support
NeoBundle 'autozimu/LanguageClient-neovim' , {
      \ 'build': { 'unix': 'npm install -g javascript-typescript-langserver ; bash install.sh' }
      \}

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <leader>lR :call LanguageClient_textDocument_rename()<CR>
