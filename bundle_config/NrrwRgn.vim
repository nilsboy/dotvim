" To focus on a selected region while making the rest inaccessible
NeoBundle 'chrisbra/NrrwRgn'

" See also:
" - https://github.com/vim-scripts/OnSyntaxChange
" - https://github.com/vim-scripts/SyntaxRange
" - https://www.reddit.com/r/vim/comments/2x5yav/markdown_with_fenced_code_blocks_is_great/

let g:nrrw_rgn_nohl = 1
let g:nrrw_rgn_protect = 'n'
let g:nrrw_rgn_update_orig_win = 1

" autocmd BufCreate,BufAdd,BufEnter * set buflisted

" Disable default mapping
xmap <NOP> <Plug>NrrwrgnDo

nnoremap <leader>nr :call MyNarrow()<cr>

function! MyNarrow() abort

  " set buflisted does not take effect here
  " let b:nrrw_aucmd_create = "setlocal ft=javascript|setlocal buflisted"
  
  let b:nrrw_aucmd_create = "setlocal ft=javascript"
  " let b:nrrw_aucmd_close  = "%UnArrangeColumn"

  " When the data is written back in the original window
  " let b:nrrw_aucmd_written = ':update'

  normal vit
  normal :<c-u>
  call nrrwrgn#NrrwRgn(visualmode(),'!')

endfunction
