finish
" Next generation completion framework
PackAdd Shougo/neocomplete.vim

" https://www.reddit.com/r/vim/comments/50rjde/finally_i_got_neocomplete_and_ultisnips_to_play/

" TODO https://github.com/Shougo/context_filetype.vim

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 0
let g:neocomplete#min_keyword_length = 0
let g:neocomplete#auto_completion_start_length = 0
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#enable_refresh_always = 1
let g:neocomplete#skip_auto_completion_time = ''
let g:neocomplete#enable_auto_close_preview = 1
" g:neocomplete#fallback_mappings
" g:neocomplete#sources#buffer#disabled_pattern


" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions',
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
" inoremap <expr><esc>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" " More convenient popup menu keys
" inoremap <esc> <C-R>=pumvisible() ? "\<lt>c-e>" : "\<lt>esc>"<CR>
" inoremap J <C-R>=pumvisible() ? "\<lt>c-n>" : "j"<CR>
" inoremap K <C-R>=pumvisible() ? "\<lt>c-p>" : "k"<CR>

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><leader>,  neocomplete#start_manual_complete()
inoremap <expr><bs> pumvisible() ? "\<c-e><bs>" : "\<bs>"
" inoremap <expr><CR> pumvisible()? "\<C-y>" : "\<CR>"

" Don't close popup on backspace
" inoremap <bs> <bs>

" let g:neocomplete#enable_auto_select = 1
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" " Enable omni completion.
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


if neobundle#tap('neocomplete.vim')
  function! neobundle#hooks.on_post_source(bundle)

    " call neocomplete#custom#source('_', 'disabled', 1)

  endfunction
  call neobundle#untap()
endif
