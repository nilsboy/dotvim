" The ultimate snippet solution for Vim.
PackAdd SirVer/ultisnips

nnoremap <silent><leader>se :execute ":edit "
      \ . stdpath('config') . "UltiSnips/" . &filetype
      \ . ".snippets"<cr>
nnoremap <leader>sa :execute ":edit " . stdpath('config') .
      \ "UltiSnips/all.snippets"<cr>

let g:UltiSnipsEnableSnipMate = 0

" The expand trigger has to be mapped for $VISUAL to work.
" This mappes the key globally for insert mode.
" These have to be diffent otherwise UltiSnips maps a different function and
" $VISUAL does not work.
" let g:UltiSnipsExpandTrigger = "<NOP>x"
" let g:UltiSnipsJumpForwardTrigger = "<NOP>y"

" inoremap <c-space> <c-r>=UltiSnips#ExpandSnippet()<cr>
inoremap silent <tab> <c-r>=MyUltisnipsJump()<cr>
let g:UltiSnipsExpandTrigger = '<c-space>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" let g:UltiSnipsListSnippets = '<c-space>'

" vnoremap <silent> <tab> <c-r>=UltiSnips#JumpForwards()<cr>
" vnoremap <silent> <s-tab> <c-r>=UltiSnips#JumpBackwards()<cr>

function! MyUltisnipsJump() abort
  if pumvisible()
    return "\<C-y>"
  endif
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

