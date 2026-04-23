finish
" Directory viewer for Vim
" NOTE: gets rid of netrw and its quirks
" TAGS: file manager netrw
" NOTE: switched to fern
PackAdd justinmk/vim-dirvish

" disable netrw
" see init.vim for these:
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1

" let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

" debugging
" let g:dirvish_dbg=1
