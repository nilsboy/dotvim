finish

" Shim for the language server protocol
" TAGS: lsp
PackAdd tjdevries/nvim-langserver-shim

let g:langserver_executables = {
      \ 'javascript': {
        \ 'name': 'javascript-lsp',
        \ 'cmd': ['javascript-typescript-langserver'],
        \ },
      \ }
