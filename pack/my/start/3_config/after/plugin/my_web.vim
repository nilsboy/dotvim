" SEE ALSO: https://github.com/kabbamine/zeavim.vim
" Search the web by default instead of manpages

command! -nargs=* Web call Web (<f-args>)
command! -nargs=* WebWithFiletype call Web (&filetype, <f-args>)
function! Web(...) abort
  let query = join(a:000, ' ')
  silent execute '!xdg-open https://phind.com/search?q=' . shellescape(query)
endfunction

let &keywordprg = ':WebWithFiletype'
nnoremap <silent> gK :execute 'WebWithFiletype ' . expand('<cword>')<cr>

nnoremap <leader>II :Web<space>
nnoremap <leader>IT :WebWithFiletype<space>
nnoremap <silent><leader>ii "zyiw:call Web(@z)<cr>
vnoremap <silent><leader>ii "zy:call Web(@z)<cr>
nnoremap <silent><leader>it "zyviw:call Web(&filetype . ' ' . @z)<cr>
vnoremap <silent><leader>it "zy:call Web(&filetype . ' ' . @z)<cr>

nnoremap <silent><leader>id "zyiw:silent execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(&filetype . ' ' . @z)<cr>
vnoremap <silent><leader>id "zy:silent execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(&filetype . ' ' . @z)<cr>
nnoremap <silent><leader>iD "zyiw:silent execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(@z)<cr>
vnoremap <silent><leader>iD "zy:silent execute '!xdg-open https://duckduckgo.com/?q=' . shellescape(@z)<cr>

nnoremap <silent><leader>ig "zyiw:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&l=' . &filetype . '&q=' . @z)<cr>
vnoremap <silent><leader>ig "zy:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&l=' . &filetype . '&q=' . @z)<cr>
nnoremap <silent><leader>iG "zyiw:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&q=' . @z)<cr>
vnoremap <silent><leader>iG "zy:silent execute '!xdg-open https://github.com/search?type=code' . shellescape('&q=' . @z)<cr>

nnoremap <silent><leader>il "zyiw:silent execute '!xdg-open https://dict.leo.org/englisch-deutsch/' . shellescape(@z)<cr>
vnoremap <silent><leader>il "zy:silent execute '!xdg-open https://dict.leo.org/englisch-deutsch/' . shellescape(@z)<cr>

nnoremap <silent><leader>if "zyiw:silent execute '!xdg-open https://www.phind.com/search?q=' . shellescape(@z)<cr>
vnoremap <silent><leader>if "zy:silent execute '!xdg-open https://www.phind.com/search?q=' . shellescape(@z)<cr>
nnoremap <silent><leader>iF "zyiw:silent execute '!xdg-open https://www.phind.com/search?q=' . shellescape(&filetype . ' ' . @z)<cr>
vnoremap <silent><leader>iF "zy:silent execute '!xdg-open https://www.phind.com/search?q=' . shellescape(&filetype . ' ' . @z)<cr>

nnoremap <silent><leader>ic "zyiw:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>
vnoremap <silent><leader>ic "zy:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>
nnoremap <silent><leader>iC "zyiW:silent execute '!xdg-open https://grep.app/search?' . shellescape('filter[lang][0]=' . &filetype . '&q=' . @z)<cr>
nnoremap <silent><leader>Ic "zyiW:silent execute '!xdg-open https://grep.app/search?q=' . shellescape(@z)<cr>

nnoremap <silent><leader>is "zyiw:call Web( 'site:stackoverflow.com', @z . ' ' . &filetype)<cr>
vnoremap <silent><leader>is "zy:call Web( 'site:stackoverflow.com', @z . ' ' . &filetype)<cr>

nnoremap <silent><leader>iS :call Web( 'site:stackoverflow.com', expand('<cword>'))<cr>
vnoremap <silent><leader>iS "zy:call Web( 'site:stackoverflow.com', @z)<cr>

