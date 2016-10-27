" Dark powered asynchronous completion framework for neovim 
NeoBundle 'Shougo/deoplete.nvim'

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_refresh_always = 1

let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 0

" deprecated
let g:deoplete#auto_complete_start_length = 1

" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

" autocmd CompleteDone * pclose!
