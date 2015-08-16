" Unite and create user interfaces
NeoBundle 'Shougo/unite.vim', { 'name' : 'unite.vim'
      \ , 'depends' : 'vimproc.vim'
      \ }

" MRU plugin includes unite.vim MRU sources
NeoBundle 'Shougo/neomru.vim'

" outline source for unite.vim
NeoBundle 'Shougo/unite-outline'

" Quickfix
" NeoBundle 'sgur/unite-qf'

" codesearch source for unite.vim
NeoBundle 'junkblocker/unite-codesearch'

"## config #####################################################################

if neobundle#tap('unite.vim') 
    function! neobundle#hooks.on_source(bundle)

let g:unite_data_directory = g:vim.cache.dir . "unite"

" no clue - but complains if not set
let g:unite_abbr_highlight = "function"

let g:unite_source_history_yank_enable = 1
let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "

" call unite#filters#matcher_default#use(['matcher_fuzzy'])
" call unite#filters#converter_default#use(['converter_file_directory'])
" call unite#filters#sorter_default#use(['sorter_word'])

autocmd FileType unite nmap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite nmap <buffer> <C-l> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <C-l> <plug>(unite_exit)

"### any ######################################################################

" call unite#custom#source('file_rec', 'converters', ['converter_default'])
call unite#custom#source('file_rec', 'sorters', ['sorter_word'])
" g:unite_source_rec_max_cache_files

nnoremap <silent><TAB> :Unite
            \ -buffer-name=any
            \ -start-insert
            \ -hide-source-names
            \ outline
            \ neomru/file
            \ <cr>

" matcher_project_ignore_files
"### grep #####################################################################

" call unite#custom#source('vimgrep', 'converters', ['converter_default'])
" call unite#custom#source('vimgrep', 'sorters', ['sorter_word'])

if executable('xxcgrep')
    let g:unite_source_grep_command='csearch'
    let g:unite_source_grep_default_opts='-i'
    let g:unite_source_grep_recursive_opt=''
elseif executable('ag')
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
    let g:unite_source_grep_command='ack'
    let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
    let g:unite_source_grep_recursive_opt=''
endif

nnoremap <silent> <Leader>g :UniteWithCursorWord
            \ -buffer-name=grep
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ grep:**<cr>

"### recent files #############################################################

call unite#custom#source('neomru/file', 'converters', ['converter_file_directory'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>r :Unite
            \ -buffer-name=recent-files
            \ -start-insert
            \ -hide-source-names
            \ neomru/file
            \ <cr>

"### recent dirs ##############################################################

call unite#custom#source('neomru/directory', 'converters', ['converter_full_path'])
call unite#custom#source('neomru/directory', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>d :<C-u>Unite
            \ -buffer-name=recent-dir
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -silent
            \ neomru/directory<cr>

"### outline ##################################################################

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
            \ -start-insert
            \ outline<cr>

"### line #####################################################################

call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent> -- :UniteWithCursorWord
            \ -start-insert
            \ -hide-source-names
            \ line
            \ <cr>

" nnoremap <silent> - :Unite
"             \ -start-insert
"             \ -hide-source-names
"             \ line
"             \ <cr>

"### registers ################################################################

nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>

"### vim environment ##########################################################

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

"### mru on vim startup if no file is opened ##################################

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

  endfunction
  call neobundle#untap()
endif
