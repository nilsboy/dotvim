" The ultimate snippet solution for Vim.
NeoBundle 'SirVer/ultisnips'

nnoremap <silent><leader>se :execute ":edit " 
      \ . g:vim.etc.dir . "UltiSnips/" . &filetype
      \ . ".snippets"<cr>
nnoremap <leader>sE :UltiSnipsEdit!<cr>
nnoremap <leader>sa :execute ":edit " . g:vim.etc.dir . 
      \ "UltiSnips/all.snippets"<cr>
nnoremap <leader>sf :execute ":Explore " . g:vim.etc.dir . "UltiSnips/"<cr>

let g:UltiSnipsEnableSnipMate = 0

" The expand trigger has to be mapped for $VISUAL to work
let g:UltiSnipsExpandTrigger = "<c-b>!s"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Inside a snippet jump to the next stop. Expand only on expand trigger.
" Based on: https://github.com/SirVer/ultisnips/issues/784
let g:ulti_jump_forwards_res = 0
let g:ulti_expand_res = 0
function s:jumpOrExpand() abort
    call UltiSnips#JumpForwards()
    if g:ulti_jump_forwards_res == 0
      call UltiSnips#ExpandSnippet()
      if g:ulti_expand_res == 0

        " Return an actual tab key if current position is preceeded
        " by nothing or whitespace only
		    let [bufnum, lnum, col, off] = getpos('.')
        let prefix = getline('.')[0 : col - 2]
        if col == 1 || prefix =~ '\v^\s*$'
          return "\<tab>"
        endif
        return "\<esc>"

      endif
    endif
    return ""
endfunction

" Show all snippets when cursor resides on whitespce
let g:ulti_expand_res = 0
function s:expandOrAll() abort
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res == 0
    call cm#sources#ultisnips#trigger_or_popup(
          \ "\<Plug>(ultisnips_expand)")
  endif
  return ""
endfunction

" execute 'inoremap <silent> <expr>'
"       \ . ' <c-space>'
"       \ . ' "\<C-R>=<sid>expandOrAll()\<CR>"'

execute 'inoremap <silent> <expr> '
      \ . g:UltiSnipsJumpForwardTrigger
      \ . ' "\<C-R>=<sid>jumpOrExpand()\<CR>"'
execute 'vmap <silent>'
      \ . ' ' . g:UltiSnipsJumpForwardTrigger
      \ . ' ' . g:UltiSnipsExpandTrigger
