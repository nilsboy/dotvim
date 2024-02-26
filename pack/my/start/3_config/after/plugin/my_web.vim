" Search the web
" SEE ALSO: https://github.com/kabbamine/zeavim.vim

command! -nargs=* WebWithFiletype call Web (&filetype, <f-args>)

command! -nargs=* Web call Web (<f-args>)
function! Web(...) abort
  let withType = a:000[0]
  let query = join(a:000[1:], ' ')
  let filetype = ''
  if withType == 1
    let filetype = &filetype .. ' '
  endif
  let query = input(':Web: ', filetype .. query) 
  silent execute '!xdg-open https://phind.com/search?q=' . shellescape(query)
endfunction

" default keywordprg
let &keywordprg = ':Web'

nnoremap <leader>ii :call Web(0)<cr>
vnoremap <leader>ii "zy:call Web(0, @z)<cr>
nnoremap <leader>iw "zyiw:call Web(0, @z)<cr>
nnoremap <leader>iW "zyiW:call Web(0, @z)<cr>

nnoremap <leader>iti :call Web(1)<cr>
vnoremap <leader>iti "zy:call Web(1, @z)<cr>
nnoremap <leader>itw "zyiw:call Web(1, @z)<cr>
nnoremap <leader>itW "zyiW:call Web(1, @z)<cr>

nnoremap <leader>idi  "zyiw:silent execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(&filetype . ' ' . @z)<cr>
vnoremap <leader>idi  "zy:silent   execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(&filetype . ' ' . @z)<cr>
nnoremap <leader>idti "zyiw:silent execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(@z)<cr>
vnoremap <leader>idti "zy:silent   execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(@z)<cr>

nnoremap <leader>ig "zyiw:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&l=' . &filetype . '&q=' . @z)<cr>
vnoremap <leader>ig "zy:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&l=' . &filetype . '&q=' . @z)<cr>
nnoremap <leader>iG "zyiw:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&q=' . @z)<cr>
vnoremap <leader>iG "zy:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&q=' . @z)<cr>

nnoremap <leader>il "zyiw:silent execute '!xdg-open https://dict.leo.org/englisch-deutsch/' . shellescape(@z)<cr>
vnoremap <leader>il "zy:silent execute '!xdg-open https://dict.leo.org/englisch-deutsch/' . shellescape(@z)<cr>

nnoremap <leader>ic "zyiw:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>
vnoremap <leader>ic "zy:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>
nnoremap <leader>iC "zyiW:silent execute '!xdg-open https://grep.app/search?' . shellescape('filter[lang][0]=' . &filetype . '&q=' . @z)<cr>
nnoremap <leader>Ic "zyiW:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>

nnoremap <leader>is "zyiw:call Web( 'site:stackoverflow.com', @z . ' ' . &filetype)<cr>
vnoremap <leader>is "zy:call Web( 'site:stackoverflow.com', @z . ' ' . &filetype)<cr>

nnoremap <leader>iS :call Web( 'site:stackoverflow.com', expand('<cword>'))<cr>
vnoremap <leader>iS "zy:call Web( 'site:stackoverflow.com', @z)<cr>

