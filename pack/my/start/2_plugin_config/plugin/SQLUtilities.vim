finish
" Various SQL Utilities.
PackAdd SQLUtilities, {
            \ 'depends': 'align'
            \ }

vmap <silent>sf :SQLU_Formatter<CR>

