" silent !firefox -P nvim -search nvim &
" !firefox --window-size 100,100 --display :0.0+100x100 -search 'site:stackoverflow.com nvim'  &
" !firefox --window-size 100,100 --display :0.0+100x100 -search 'site:stackoverflow.com x display option'  &
" !firefox -search 'site:stackoverflow.com x display option'  &

command! -nargs=* Web call Web (<f-args>)
command! -nargs=* WebWithFiletype call Web (&filetype, <f-args>)
function! Web(...) abort
  let query = join(a:000, ' ')
  silent execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(query)
endfunction
" SEE ALSO: https://github.com/kabbamine/zeavim.vim
" Search the web by default instead of manpages

let &keywordprg = ':WebWithFiletype'
nnoremap <silent> gK :execute 'WebWithFiletype '
      \ . expand('<cword>')<cr>

nnoremap <silent><leader>ii :call Web(&filetype, expand('<cword>'))<cr>
vnoremap <silent><leader>ii "zy:call Web(&filetype, @z)<cr>
nnoremap <silent><leader>iI :call Web(expand('<cword>'))<cr>
vnoremap <silent><leader>iI "zy:call Web(@z)<cr>

nnoremap <silent><leader>ig "zyiw:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&l=' . &filetype . '&q=' . @z)<cr>
vnoremap <silent><leader>ig "zy:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&l=' . &filetype . '&q=' . @z)<cr>

nnoremap <silent><leader>iG "zyiw:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&q=' . @z)<cr>
vnoremap <silent><leader>iG "zy:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&q=' . @z)<cr>

nnoremap <silent><leader>it "zyiw:silent execute '!xdg-open https://dict.leo.org/englisch-deutsch/' . shellescape(@z)<cr>
vnoremap <silent><leader>it "zy:silent execute '!xdg-open https://dict.leo.org/englisch-deutsch/' . shellescape(@z)<cr>

nnoremap <silent><leader>ic "zyiw:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>
vnoremap <silent><leader>ic "zy:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>

nnoremap <silent><leader>iC "zyiW:silent execute '!xdg-open https://grep.app/search?' . shellescape('filter[lang][0]=' . &filetype . '&q=' . @z)<cr>

nnoremap <silent><leader>Ic "zyiW:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>

nnoremap <silent><leader>is "zyiw:call Web(
      \ 'site:stackoverflow.com',
      \ @z . ' ' . &filetype)<cr>
vnoremap <silent><leader>is "zy:call Web(
      \ 'site:stackoverflow.com',
      \ @z . ' ' . &filetype)<cr>

nnoremap <silent><leader>iS :call Web(
      \ 'site:stackoverflow.com',
      \ expand('<cword>'))<cr>
vnoremap <silent><leader>iS "zy:call Web(
      \ 'site:stackoverflow.com', @z)<cr>
