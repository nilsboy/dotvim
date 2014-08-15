call unite#custom#source('neomru/file', 'converters', ['converter_file_directory'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>r :<C-u>Unite
            \ -buffer-name=mru
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ neomru/file<cr>

call unite#custom#source('neomru/directory', 'converters', ['converter_full_path'])
call unite#custom#source('neomru/directory', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>d :<C-u>Unite
            \ -buffer-name=mru
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ neomru/directory<cr>

autocmd StdinReadPre * let s:std_in=1
augroup vimEnter_mru
    autocmd!
    autocmd VimEnter * if argc() == 0 && exists("s:std_in") == 0 && empty($VIM_HAS_ARGS) == 1
        \ | :exe 'Unite -start-insert neomru/file' 
        \ | endif
augroup END

call unite#custom#source('directory_file_rec', 'converters', ['converter_nothing'])
call unite#custom#source('directory_file_rec', 'sorters', ['sorter_word'])

let g:unite_source_alias_aliases = {
      \   'directory_file_rec' : {
      \     'source': 'file_rec',
      \   },
      \   'b' : 'buffer',
      \ }

let directory_file_rec = {
  \ 'is_selectable': 0,
  \}
function! directory_file_rec.func(candidate)
    execute ':Unite directory_file_rec:' . a:candidate.word
endfunction

call unite#custom#action('directory', 'directory_file_rec', directory_file_rec)
call unite#custom#default_action('directory', 'directory_file_rec')
