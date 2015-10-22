" Unite and create user interfaces
NeoBundle 'Shougo/unite.vim', { 'name' : 'unite.vim'
      \ , 'depends' : 'Shougu/vimproc.vim'
      \ }

" outline source for unite.vim
NeoBundle 'Shougo/unite-outline'

" Quickfix
" NeoBundle 'sgur/unite-qf'

" codesearch source for unite.vim
" NeoBundle 'junkblocker/unite-codesearch'

"## defaults ###################################################################

if neobundle#tap('unite.vim') 
    function! neobundle#hooks.on_post_source(bundle)

let g:unite_data_directory = g:vim.cache.dir . "unite"

" no clue - but complains if not set
let g:unite_abbr_highlight = "function"

let g:unite_source_history_yank_enable = 1
let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "

let g:unite_source_rec_max_cache_files = 0

call unite#custom#profile('default', 'context', {
      \ 'start_insert': 1,
      \ 'no_split' : 1,
      \ })

autocmd FileType unite nmap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite nmap <buffer> <C-l> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <C-l> <plug>(unite_exit)

"### files #####################################################################

" call unite#custom#source('file_rec', 'matchers', 
"     \ ['matcher_project_ignore_files',
"     \ 'matcher_default']
" \)

call unite#custom#source('file_rec/async', 'converters', 
    \ ['converter_file_directory'])
call unite#custom#source('file_rec/async', 'sorters', ['sorter_selecta'])

" ignore files from wildignore
" call unite#custom#source('file_rec/async,file_rec/git', 'ignore_globs', [])
call unite#custom#source('file_rec/async', 'ignore_globs',
		\ split(&wildignore, ','))

let g:unite_source_rec_max_cache_files = 1000

nnoremap <silent><TAB> :UniteWithProjectDir
            \ -buffer-name=any
            \ -hide-source-names
            \ file_rec/async
            \ <cr>

"### grep ######################################################################

" call unite#custom#source('vimgrep', 'converters', ['converter_default'])
" call unite#custom#source('vimgrep', 'sorters', ['sorter_word'])

" nnoremap <silent> <Leader>g :UniteWithCursorWord
"             \ -buffer-name=grep
"             \ -no-quit
"             \ -keep-focus
"             \ -immediately
"             \ grep:**<cr>

"### mru #######################################################################

" MRU plugin includes unite.vim MRU sources
NeoBundle 'Shougo/neomru.vim'

call unite#custom#source('neomru/file', 'converters', 
    \ ['converter_file_directory'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

let g:neomru#file_mru_limit=3000

nnoremap <silent> <leader>r :UniteWithProjectDir
            \ -buffer-name=mru-project
            \ -hide-source-names
            \ neomru/file
            \ <cr>

nnoremap <silent> <leader>rr :Unite
            \ -buffer-name=recent-files
            \ -hide-source-names
            \ neomru/file
            \ <cr>

nnoremap <silent> <leader>rd :Unite
            \ -buffer-name=recent-directories
            \ -hide-source-names
            \ -default-action=project_cd
            \ neomru/directory
            \ <cr>

call unite#custom#source('script', 'converters', 
    \ ['converter_file_directory'])
call unite#custom#source('script', 'sorters', ['sorter_selecta'])

nnoremap <silent> <leader>rc :Unite
            \ -buffer-name=modified-files
            \ -hide-source-names
            \ script:bash:vim-unite-git-modified
            \ <cr>

"### outline ###################################################################

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

nnoremap <silent> <Leader>o :<C-u>Unite
            \ -buffer-name=outline
            \ -keep-focus
            \ -silent
            \ outline<cr>

"### line ######################################################################

call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent> -- :UniteWithCursorWord
            \ -hide-source-names
            \ line
            \ <cr>

" nnoremap <silent> - :Unite
"             \ -hide-source-names
"             \ line
"             \ <cr>

"### registers #################################################################

nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>

"### vim environment ###########################################################

call unite#custom#source('tab', 'sorters', ['sorter_nothing'])
call unite#custom#source('window', 'sorters', ['sorter_nothing'])
call unite#custom#source('buffer', 'sorters', ['sorter_nothing'])

" nnoremap <silent> <leader>v :<C-u>Unite
"     \ -buffer-name=vimfos
"     \ -no-quit
"     \ -keep-focus
"     \ -immediately
"     \ -silent
"     \ tab window buffer mapping<cr>

"### mru on vim startup if no file is opened ###################################

" autocmd StdinReadPre * let s:std_in=1
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

"### Marks #####################################################################

" Unite source for marks
NeoBundle 'tacroe/unite-mark'

let g:unite_source_mark_marks =
    \   "abcdefghijklmnopqrstuvwxyz"
    \ . "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    \ . "0123456789.'`^<>[]{}()\""

nnoremap <silent> <leader>rm :Unite
            \ -buffer-name=marks
            \ -hide-source-names
            \ mark
            \ <cr>

"### end #######################################################################

  endfunction
  call neobundle#untap()
endif
