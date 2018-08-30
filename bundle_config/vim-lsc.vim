" A vim plugin for communicating with a language server
NeoBundle 'natebosch/vim-lsc'

let g:lsc_server_commands = {
    \ 'java': {
    \   'name': 'javac lsp',
    \   'command': 'tee /tmp/vim-lsc.in.log | java -cp /home/nilsb/.vim/var/vscode-javac/out/fat-jar.jar org.javacs.Main | tee /tmp/vim-lsc.out.log',
    \ },
    \}

    " \   'command': 'tee /tmp/vim-lsc.in.log | java -cp /home/nilsb/.vim/var/vscode-javac/out/fat-jar.jar org.javacs.Main | tee /tmp/vim-lsc.out.log',
