" Directory viewer for Vim
" NOTE: gets rid of netrw and its quirks
" TAGS: file manager netrw
PackAdd justinmk/vim-dirvish

" disable netrw
" see init.vim for these:
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1

" TODO: test
augroup vim-dirvish#augroupFixBrokenSearchMapping
  autocmd!
  autocmd FileType dirvish nmap <silent> <buffer> / <Plug>(incsearch-forward)
augroup END

