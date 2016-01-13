" Unite and create user interfaces
NeoBundle 'Shougo/unite.vim', { 'name' : 'unite.vim'
      \ , 'depends' : 'Shougu/vimproc.vim'
\ }

NeoBundle 'sgur/unite-qf'

"## TODO #######################################################################

" TODO start in normal mode if resuming

"## Notes ######################################################################

" Create a new unite buffer.
" -create
"
" rotate-next-source
"
" codesearch source for unite.vim
" NeoBundle 'junkblocker/unite-codesearch'
"
" jump_point	Nominates current line of "file:line" format as candidates.
" 		This source is useful for |vimshell| outputs.
"
" file_point	Nominates filename or URI at the cursor as candidates.
" 		This source is useful for |vimshell| outputs.

"## defaults ###################################################################

if neobundle#tap('unite.vim') 
    function! neobundle#hooks.on_post_source(bundle)

let g:unite_data_directory = g:vim.cache.dir . "unite"

" complains if not set
let g:unite_abbr_highlight = "function"

call unite#custom#profile('default', 'context', {
    \ 'auto_preview' : 1,
    \ 'start_insert': 1,
    \ 'sync' : 1,
    \ 'match_input' : 1,
    \ 'keep_focus' : 1,
    \ 'no_split' : 1,
    \ 'silent' : 1,
\ })
" \ 'resume' : 1,

nnoremap <silent> <tab> :UniteResume<cr><esc>

call unite#custom#source('script-file', 'converters',
    \ ['converter_file_directory_pretty'])
call unite#custom#source('script-file', 'sorters', ['sorter_nothing'])

autocmd FileType unite nmap <buffer> <esc> <Plug>(nilsb_nothing)
autocmd FileType unite nmap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <TAB> <plug>(unite_exit)

autocmd FileType unite nmap <buffer> <C-l> <plug>(unite_rotate_next_source)
autocmd FileType unite nmap <buffer> <C-h> <plug>(unite_rotate_previous_source)

autocmd FileType unite imap <buffer> <C-l> <esc><plug>(unite_rotate_next_source)
autocmd FileType unite imap <buffer> <C-h> <esc><plug>(unite_rotate_previous_source)

autocmd FileType unite nmap <buffer> <SPACE> <C-F>
autocmd FileType unite nmap <buffer><nowait> b <C-B>

autocmd FileType unite nnoremap <buffer> i gg0DA
autocmd FileType unite nnoremap <buffer> A ggA

"### files #####################################################################

" let g:unite_source_rec_max_cache_files = 100
" let g:unite_source_rec_min_cache_files = 0

" call unite#custom#source('file_rec/async', 'ignore_globs',
"     \ split(&wildignore, ','))

    " \ -default-action=open
nnoremap <silent> <leader>f :Unite
    \ -buffer-name=files
    \ -smartcase
    \ script-file:find-and-limit
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
    \ grep:**
    \ script-file:find-and-limit
    \ <cr>
    \ <esc>

vnoremap <silent> <Leader>gg y:Unite
    \ -buffer-name=grep-word
    \ -input=<c-r>=escape(@", '\\.*$^[]')<cr>
    \ grep:**::<c-r>=escape(@", '\\.*$^[]')<cr>
    \ script-file:find-and-limit
    \ <cr>

nnoremap <silent> <Leader>gi :UniteWithInput
    \ -buffer-name=grep-input
    \ grep:**
    \ script-file:find-and-limit
    \ <cr>

" :UniteWithCursorWord grep:$buffers

"### mru #######################################################################

" MRU plugin includes unite.vim MRU sources
NeoBundle 'Shougo/neomru.vim'

call unite#custom#source('neomru/file', 'converters', 
    \ ['converter_file_directory_pretty'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

let g:neomru#file_mru_limit=3000

nnoremap <silent> <leader>r :UniteWithProjectDir
    \ -buffer-name=mru-project
    \ neomru/file
    \ <cr>

nnoremap <silent> <leader>rr :Unite
    \ -buffer-name=recent-files
    \ neomru/file
    \ <cr>

nnoremap <silent> <leader>rd :Unite
    \ -buffer-name=recent-directories
    \ -default-action=project_cd
    \ neomru/directory
    \ <cr>

"### changes ###################################################################

nnoremap <silent> <leader>c :Unite
    \ -buffer-name=jump
    \ change jump
    \ <cr>

"### git #######################################################################

nnoremap <silent> <leader>gc :Unite
    \ -buffer-name=git-modified
    \ script-file:git-modified
    \ <cr>
    \ <esc>

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
    \ outline
    \ <cr>

"### line ######################################################################

call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent> ,- :Unite
    \ -buffer-name=line
    \ line
    \ <cr>

nnoremap <silent> ,-- :UniteWithCursorWord
    \ -buffer-name=line
    \ -no-start-insert
    \ line
    \ <cr>

"### registers #################################################################

" also see source register
let g:unite_source_history_yank_enable = 1
let g:unite_source_history_yank_save_clipboard = 1
" let g:unite_source_history_yank_limit = 100
" let g:unite_source_history_yank_file = TODO

nnoremap <leader>y :Unite
    \ -buffer-name=yank
    \ history/yank register
    \ <cr><cr>

"### vim environment ###########################################################

call unite#custom#source('tab', 'sorters', ['sorter_nothing'])
call unite#custom#source('window', 'sorters', ['sorter_nothing'])

call unite#custom#source('buffer', 'sorters', ['sorter_nothing'])
let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "

nnoremap <silent> <leader>v :<C-u>Unite
    \ -buffer-name=vimfos
    \ buffer window tab
    \ <cr>

nnoremap <silent> <leader>vm :<C-u>Unite
    \ -buffer-name=mappings
    \ mapping
    \ <cr>

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
    \ mark
    \ <cr>

"### bookmark ##################################################################

nnoremap <silent> <Leader>b :UniteBookmarkAdd<cr>

nnoremap <silent> <Leader>bb :Unite
    \ -buffer-name=bookmark
    \ bookmark
    \ <cr>

"### quickfix ##################################################################


"### end #######################################################################

  endfunction
  call neobundle#untap()
endif
