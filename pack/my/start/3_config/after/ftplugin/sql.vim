setlocal nowrap

" let s:new_title = 'Srvr: ' . DB_listOption('profile')
" exec 'DBSetOption custom_title=' . s:new_title

" let &l:commentstring = '# %s'

" TODO:
" TODO npm sqlite3 seems to have a good formatter
function! MySqlFormat() abort
  let t = MyHelpersGetVisualSelection()
  let t = substitute(t, '\n', ' ', 'g')
  " s/inner join/\rinner join/g
endfunction
vnoremap <silent> <buffer> <leader>x :call MySqlFormat()<cr>

" let b:outline = '\v^(##+\ .+|select|insert).+$'
let b:outline = '^(##+\ ).+$'

let g:formatters_sql = ['sqlformatter']
let g:formatdef_sqlformatter = '"sql-format"'

