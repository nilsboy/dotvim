" The ultimate snippet solution for Vim.

" Setup:
" apt install python3-pynvim
" python3 -m pip install --user --upgrade pynvim

nnoremap <silent><leader>js :execute ":edit "
      \ . stdpath('config') . "/UltiSnips/" . &filetype
      \ . ".snippets"<cr>
nnoremap <leader>jS :execute ":edit " . stdpath('config') .
      \ "/UltiSnips/all.snippets"<cr>

let g:UltiSnipsEnableSnipMate = 0

inoremap <silent> <tab> <c-r>=MyUltisnipsJump()<cr>
let g:UltiSnipsExpandTrigger = '<c-space>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" inoremap <c-space> <c-r>=UltiSnips#ExpandSnippet()<cr>
vnoremap <tab> <c-r>=UltiSnips#JumpForwards()<cr>
vnoremap <s-tab> <c-r>=UltiSnips#JumpBackwards()<cr>

PackAdd SirVer/ultisnips

function! MyUltisnipsJump() abort
  " if coc#pum#visible()
  if pumvisible()
    call coc#pum#confirm()
    return "\<C-y>"
  endif

  " " if not using coc:
  " if pumvisible()
  "   call UltiSnips#ExpandSnippet()
  "   if g:ulti_expand_res == 1
  "     return ''
  "   endif
  "   return "\<C-y>"
  " endif

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
  " return ''

endfunction

if exists("b:my_ultisnips_ftPluginLoaded")
  finish
endif
let b:my_ultisnips_ftPluginLoaded = 1

augroup ultisnips#augroupExistSnippet
  autocmd!
  autocmd User UltiSnipsEnterFirstSnippet set cursorline!
  autocmd User UltiSnipsExitLastSnippet   set cursorline!
augroup END

augroup MyUltisnipsColorFix
  autocmd!
  autocmd ColorScheme,Syntax,FileType * highlight! link snipLeadingSpaces normal
augroup END
