finish
" does not work and overwrites mappings
" web browser plugin
NeoBundle 'browser.vim', {
    \ 'build': {
    \ 'unix': 'cpanm LWP::UserAgent HTML::TreeBuilder',
    \ }
\ }
