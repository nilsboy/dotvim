" The ultimate snippet solution for Vim.
PackAdd SirVer/ultisnips

nnoremap <silent><leader>se :execute ":edit "
      \ . g:vim.etc.dir . "UltiSnips/" . &filetype
      \ . ".snippets"<cr>
nnoremap <leader>sa :execute ":edit " . g:vim.etc.dir .
      \ "UltiSnips/all.snippets"<cr>

let g:UltiSnipsEnableSnipMate = 0
finish

" The expand trigger has to be mapped for $VISUAL to work.
" This mappes the key globally for insert mode.
" These have to be diffent otherwise UltiSnips maps a different function and
" $VISUAL does not work.
let g:UltiSnipsExpandTrigger = "<NOP>x"
let g:UltiSnipsJumpForwardTrigger = "<NOP>y"

inoremap <c-space> <c-r>=UltiSnips#ExpandSnippet()<cr>
inoremap <tab> <c-r>=MyUltisnipsJump()<cr>
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
execute 'vmap <silent> <tab> ' . g:UltiSnipsExpandTrigger

function! MyUltisnipsJump() abort
  call UltiSnips#JumpForwards()
  if g:ulti_jump_forwards_res == 1
    return ''
  endif
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res == 1
    return ''
  endif
  " Return an actual tab key if current position is preceeded
  " by nothing or whitespace only.
  let [bufnum, lnum, col, off] = getpos('.')
  let prefix = getline('.')[0 : col - 2]
  if col == 1 || prefix =~ '\v^\s*$'
    return "\<tab>"
  endif
  return "\<esc>"
endfunction

