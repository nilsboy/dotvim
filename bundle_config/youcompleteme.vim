" A code-completion engine for Vim
NeoBundle 'Valloric/YouCompleteMe', {
    \ 'build': {
    \ 'unix': './install.py --tern-completer'
    \ }
\ }

" sudo does not seem to work with NeoBundle
    " \ 'unix': 'sudo apt-get install cmake python-dev && ./install.py --tern-completer'
