" Unite and create user interfaces
NeoBundle 'Shougo/unite.vim', { 'name' : 'unite.vim'
      \ , 'depends' : 'Shougu/vimproc.vim'
\ }

" TODO
" A: You can change below highlights by |:highlight|.
" "uniteStatusNormal", "uniteStatusHead"
" "uniteStatusSourceNames", "uniteStatusSourceCandidates"
" "uniteStatusMessage", "uniteStatusLineNR"

" Quickfix
" NeoBundle 'sgur/unite-qf'

" codesearch source for unite.vim
" NeoBundle 'junkblocker/unite-codesearch'

" Notes
" -immediately breaks file/async

"## defaults ###################################################################

if neobundle#tap('unite.vim') 
    function! neobundle#hooks.on_post_source(bundle)

let g:unite_data_directory = g:vim.cache.dir . "unite"

" no clue - but complains if not set
let g:unite_abbr_highlight = "function"

let g:unite_source_history_yank_enable = 1
let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "

let g:unite_source_rec_max_cache_files = 100
let g:unite_source_rec_min_cache_files = 0

" TODO look at file_rec/git

call unite#custom#profile('default', 'context', {
    \ 'start_insert': 1,
    \ 'no_split' : 1,
    \ })

autocmd FileType unite nmap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite nmap <buffer> <C-l> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <C-l> <plug>(unite_exit)
autocmd FileType unite nmap <buffer> <space> <Plug>(unite_select_next_page)
autocmd FileType unite nmap <buffer> b     <Plug>(unite_select_previous_page)
autocmd FileType unite nmap <buffer> <esc> <Plug>(nothing)
autocmd FileType unite nmap <buffer> i ggk0DA
autocmd FileType unite nmap <buffer> a ggkA

"### files #####################################################################

call unite#custom#source('file_rec/async', 'ignore_globs',
    \ split(&wildignore, ','))

call unite#custom#source('file_rec/async', 'converters', 
    \ ['converter_file_directory'])
call unite#custom#source('file_rec/async', 'sorters', ['sorter_selecta'])

call unite#custom#source('script-file', 'converters',
    \ ['converter_file_directory_pretty'])
call unite#custom#source('script-file', 'sorters', ['sorter_nothing'])

nnoremap <silent> <tab> :Unite
    \ -buffer-name=files
    \ -keep-focus
    \ -auto-preview
    \ -hide-source-names
    \ -resume
    \ script-file:find-and-limit
    \ <cr>
    " \ -no-start-insert

nnoremap <silent> <leader>fr :UniteWithProjectDir
    \ -buffer-name=files
    \ -keep-focus
    \ -auto-preview
    \ -resume
    \ file_rec/async
    \ <cr>

"### grep ######################################################################

call unite#custom#source('grep', 'converters', 
    \ ['converter_tail_abbr'])

let g:unite_source_grep_default_opts = ' -inH '
    \ . ' --exclude-dir "node_modules" '
    \ . ' --exclude-dir ".git" '
    \ . ' --exclude ".*" '
    \ . ' --exclude "*.class" '
    \ . ' --exclude-dir "classes" '

nnoremap <silent> <Leader>gg :UniteWithCursorWord
    \ -buffer-name=grep
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ grep:**<cr>

nnoremap <silent> <Leader>gr :UniteWithCursorWord
    \ -buffer-name=grep
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ -resume
    \ grep:**<cr>

vnoremap <silent> <Leader>gg y:UniteWithProjectDir
    \ -buffer-name=grep
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ grep:::<c-r>=escape(@", '\\.*$^[]')<cr><cr>

nnoremap <silent> <Leader>gi :Unite
    \ -buffer-name=grep-prompt
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ grep:**<cr>

nnoremap <silent> <Leader>gir :Unite
    \ -buffer-name=grep-prompt
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ -resume
    \ grep:**<cr>

"### mru #######################################################################

" MRU plugin includes unite.vim MRU sources
NeoBundle 'Shougo/neomru.vim'

call unite#custom#source('neomru/file', 'converters', 
    \ ['converter_file_directory'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

let g:neomru#file_mru_limit=3000

nnoremap <silent> <leader>r :UniteWithProjectDir
    \ -buffer-name=mru-project
    \ -keep-focus
    \ -auto-preview
    \ -hide-source-names
    \ neomru/file
    \ <cr>

nnoremap <silent> <leader>rr :Unite
    \ -buffer-name=recent-files
    \ -keep-focus
    \ -auto-preview
    \ -hide-source-names
    \ neomru/file
    \ <cr>

nnoremap <silent> <leader>rd :Unite
    \ -buffer-name=recent-directories
    \ -keep-focus
    \ -auto-preview
    \ -hide-source-names
    \ -default-action=project_cd
    \ neomru/directory
    \ <cr>

" call unite#custom#source('script', 'converters', 
"     \ ['converter_file_directory'])
" call unite#custom#source('script', 'sorters', ['sorter_selecta'])

nnoremap <silent> <leader>rc :Unite
    \ -buffer-name=modified-files
    \ -keep-focus
    \ -auto-preview
    \ -hide-source-names
    \ -no-start-insert
    \ script-file:git-modified
    \ <cr>

"### outline ###################################################################

" outline source for unite.vim
NeoBundle 'Shougo/unite-outline'

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
    \ -auto-preview
    \ outline<cr>

"### line ######################################################################

call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent> -- :Unite
    \ -buffer-name=line
    \ -hide-source-names
    \ -keep-focus
    \ -auto-preview
    \ -resume
    \ line
    \ <cr>

nnoremap <silent> --w :UniteWithCursorWord
    \ -buffer-name=line
    \ -hide-source-names
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ -resume
    \ line
    \ <cr>

nnoremap <silent> --r :Unite
    \ -buffer-name=line
    \ -hide-source-names
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ -resume
    \ line
    \ <cr>

"### registers #################################################################

nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>

"### vim environment ###########################################################

call unite#custom#source('tab', 'sorters', ['sorter_nothing'])
call unite#custom#source('window', 'sorters', ['sorter_nothing'])
call unite#custom#source('buffer', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>v :<C-u>Unite
    \ -buffer-name=vimfos
    \ -no-quit
    \ -keep-focus
    \ buffer window tab<cr>

nnoremap <silent> <leader>vm :<C-u>Unite
    \ -buffer-name=mappings
    \ -no-quit
    \ -keep-focus
    \ mapping<cr>

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

"    \   "abcdefghijklmnopqrstuvwxyz"
"    \ . "0123456789.'`^<>[]{}()\""
let g:unite_source_mark_marks =
    \ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

nnoremap <silent> <leader>rm :Unite
    \ -buffer-name=marks
    \ -hide-source-names
    \ mark
    \ <cr>

"### bookmark ##################################################################

nnoremap <silent> <Leader>m :UniteBookmarkAdd<cr>

nnoremap <silent> <Leader>mm :Unite
    \ -buffer-name=bookmark
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ bookmark<cr>

nnoremap <silent> <Leader>mr :Unite
    \ -buffer-name=bookmark
    \ -keep-focus
    \ -no-start-insert
    \ -auto-preview
    \ -resume
    \ bookmark<cr>

"### end #######################################################################

  endfunction
  call neobundle#untap()
endif
