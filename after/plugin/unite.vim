"### general ##################################################################

let g:unite_data_directory = MY_VIM_VAR . "/unite"

" no clue - but complains if not set
let g:unite_abbr_highlight = "function"

let g:unite_source_history_yank_enable = 1

" call unite#filters#matcher_default#use(['matcher_fuzzy'])
" call unite#filters#converter_default#use(['converter_file_directory'])
" call unite#filters#sorter_default#use(['sorter_word'])

" TODO
" checkout source output:messages
" nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>
" nnoremap <leader>x :<C-u>UniteWithBufferDir -buffer-name=files file_rec<cr>
" nnoremap <leader>c :<C-u>UniteWithCursorWord -buffer-name=files -immediately file_rec<cr>
" nnoremap <leader>b :<C-u>:UniteBookmarkAdd<cr>

"### vim stuff ################################################################

call unite#custom#source('tab', 'sorters', ['sorter_nothing'])
call unite#custom#source('window', 'sorters', ['sorter_nothing'])
call unite#custom#source('buffer', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>v :<C-u>Unite
    \ -buffer-name=vimfos
    \ -no-quit
    \ -keep-focus
    \ -immediately
    \ -silent
    \ tab window buffer mapping<cr>

"### find #####################################################################

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
    execute ':Unite -buffer-name=filerec directory_file_rec:' . a:candidate.word
endfunction

call unite#custom#action('directory', 'directory_file_rec', directory_file_rec)
call unite#custom#default_action('directory', 'directory_file_rec')

call unite#custom#source('file_rec', 'converters', ['converter_default'])
call unite#custom#source('file_rec', 'sorters', ['sorter_word'])

" no file limit
" fails: call unite#custom#source('file_rec' 'max_candidates', 0)
let g:unite_source_rec_max_cache_files = 0

" nnoremap <silent> <leader>x :<C-u>Unite
"             \ -buffer-name=files
"             \ -no-quit
"             \ -keep-focus
"             \ -immediately
"             \ -silent
"             \ file_rec<cr>

"### find in default dirs #####################################################

" nnoremap <silent> <leader>ff :call Uniteff()<cr>

function! Uniteff()
    execute "Unite -silent file_rec:" . $HOME . "/src"
endfunction
call unite#custom#source('vimgrep', 'converters', ['converter_default'])
" call unite#custom#source('vimgrep', 'sorters', ['sorter_word'])

" nnoremap <silent> <Leader>g :<C-u>Unite
"             \ -buffer-name=grep
"             \ -no-quit
"             \ -keep-focus
"             \ -immediately
"             \ -silent
"             \ vimgrep:**<cr>

"### mru ######################################################################

call unite#custom#source('neomru/file', 'converters', ['converter_file_directory'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>r :MyUniteMru<cr>

command! -nargs=0 MyUniteMru call MyUniteMru()
function! MyUniteMru()
    :Unite -buffer-name=mru -default-action=open neomru/file
    :nunmap <buffer> <C-l>
    :nunmap <buffer> <C-h>
    :only
endfunction

"### mru-dir ##################################################################

call unite#custom#source('neomru/directory', 'converters', ['converter_full_path'])
call unite#custom#source('neomru/directory', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>d :<C-u>Unite
            \ -buffer-name=mrudir
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -silent
            \ neomru/directory<cr>

"### mru on vim startup if no file is opened ##################################

autocmd StdinReadPre * let s:std_in=1
" augroup vimEnter_mru
"     autocmd!
"     autocmd VimEnter *
"         \ if argc() == 0 && exists("s:std_in") == 0 && empty($VIM_HAS_ARGS) == 1
"         \ | :call MyUniteMru()
"         \ | endif
" augroup END

" augroup insertLeave_ChangeKeymap
"     autocmd!
"     autocmd InsertLeave * :set keymap=us
" augroup END

"### outline ##################################################################

nnoremap <silent> <Leader>o :<C-u>Unite
            \ -buffer-name=outline
            \ -keep-focus
            \ -immediately
            \ -silent
            \ outline<cr>

let g:unite_source_outline_filetype_options = {
      \ '*': {
      \   'auto_update': 1,
      \   'auto_update_event': 'hold',
      \ },
      \ 'java': {
      \   'ignore_types': ['package'],
      \ },
      \ 'perl': {
      \   'ignore_types': ['package'],
      \ },
      \}

"### quickfix #################################################################

" nnoremap <silent> <Leader>q :<C-u>Unite
"             \ -buffer-name=qf
"             \ -no-quit
"             \ -keep-focus
"             \ -immediately
"             \ -silent
"             \ qf<cr>
" call unite#custom#source('line', 'sorters', ['sorter_nothing'])

"### search ###################################################################

" nnoremap <silent> // :<C-u>Unite
"             \ -buffer-name=search
"             \ -no-quit
"             \ -keep-focus
"             \ -immediately
"             \ -silent
"             \ line<cr>

"### tags #####################################################################

call unite#custom#source('tag', 'converters', ['converter_default'])
call unite#custom#source('tag', 'sorters', ['sorter_word'])

" -no-quit
" Doesn't close unite buffer after firing an action.  Unless you
" specify it, a unite buffer gets closed when you selected an
" action which is "is_quit".

nnoremap <silent> t :<C-u>UniteWithCursorWord
            \ -buffer-name=unite-tags
            \ -no-quit
            \ -silent
            \ tag<cr>

nnoremap <silent> T :<C-u>Unite
            \ -buffer-name=unite-tags
            \ -no-quit
            \ -silent
            \ tag<cr>

