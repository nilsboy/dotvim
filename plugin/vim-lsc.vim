finish
" A vim plugin for communicating with a language server
" NOTE: Does support Neovim: https://github.com/natebosch/vim-lsc/issues/52#issuecomment-383341285
" TAGS: lsp
PackAdd natebosch/vim-lsc

" NOTE: Does not work with javacs - the rootPath does not seem to be set: 
"   https://github.com/georgewfraser/vscode-javac/issues/45
"   https://github.com/georgewfraser/vscode-javac/issues/51
"   Caused by: java.lang.NullPointerException
"     at org.javacs.JavaLanguageServer.initialize(JavaLanguageServer.java:136)
" NOTE: eclipse.jdt.ls: https://github.com/natebosch/vim-lsc/issues/56

let g:lsc_server_commands = {
      \ 'java': 'javacs'
      \ }
