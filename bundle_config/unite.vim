" Unite and create user interfaces
NeoBundle 'Shougo/unite.vim', { 'name' : 'unite.vim'
      \ , 'depends' : 'Shougu/vimproc.vim'
\ }

" TODO start in normal mode if resuming

" TODO
" A: You can change below highlights by |:highlight|.
" "uniteStatusNormal", "uniteStatusHead"
" "uniteStatusSourceNames", "uniteStatusSourceCandidates"
" "uniteStatusMessage", "uniteStatusLineNR"

" Quickfix
" NeoBundle 'sgur/unite-qf'

" codesearch source for unite.vim
" NeoBundle 'junkblocker/unite-codesearch'

" TODO look at file_rec/git
" TODO combi source grep + filenames
" TODO source change Nominates results of |:changes| command as candidates.
" TODO history/unite
"
" ?: file_list Nominates files in the filelist.
" jump_point	Nominates current line of "file:line" format as candidates.
" 		This source is useful for |vimshell| outputs.

" 						*unite-source-file_point*
" file_point	Nominates filename or URI at the cursor as candidates.
" 		This source is useful for |vimshell| outputs.

" 						*unite-source-launcher*
" launcher	Nominates executable files from $PATH as candidates.

" 		Source arguments:
" 		1. comma separated executable files' path.

"## defaults ###################################################################

if neobundle#tap('unite.vim') 
    function! neobundle#hooks.on_post_source(bundle)

let g:unite_data_directory = g:vim.cache.dir . "unite"

" complains if not set
let g:unite_abbr_highlight = "function"

let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "

" g:unite_enable_auto_select = 0

call unite#custom#profile('default', 'context', {
    \ 'start_insert': 1,
    \ 'no_split' : 1,
    \ 'keep_focus' : 1,
    \ 'auto_preview' : 1,
    \ 'resume' : 1,
    \ 'silent' : 1,
\ })
" \ 'hide_source_names' : 1,
" \ 'quick_match' : 1,
" print warnings:
" \ 'verbose' : 1,

" -create
" Create a new unite buffer.

" -abbr-highlight={highlight-name}
" Specify abbreviated candidates highlight.
" Default: "Normal"

" -here
" Open unite buffer at the cursor position.

" Note: Uses |unite-options-buffer-name| to search for

autocmd FileType unite nmap <buffer> <esc> <Plug>(nilsb_nothing)
autocmd FileType unite nmap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite nmap <buffer> <C-l> <plug>(unite_exit)
autocmd FileType unite imap <buffer> <C-l> <plug>(unite_exit)

autocmd FileType unite nmap <buffer> <SPACE> <C-F>
autocmd FileType unite nmap <buffer><nowait> b <C-B>

autocmd FileType unite nnoremap <buffer> i gg0DA
autocmd FileType unite nnoremap <buffer> A ggA

"### files #####################################################################

" let g:unite_source_rec_max_cache_files = 100
" let g:unite_source_rec_min_cache_files = 0

" call unite#custom#source('file_rec/async', 'ignore_globs',
"     \ split(&wildignore, ','))

call unite#custom#source('script-file', 'converters',
    \ ['converter_file_directory_pretty'])
call unite#custom#source('script-file', 'sorters', ['sorter_nothing'])

nnoremap <silent> <tab> :Unite
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
    \ grep:**<cr><esc>

vnoremap <silent> <Leader>gg y:Unite
    \ -buffer-name=grep
    \ -no-resume
    \ -input=<c-r>=escape(@", '\\.*$^[]')<cr>
    \ grep:**::<c-r>=escape(@", '\\.*$^[]')<cr><cr>

nnoremap <silent> <Leader>gi :Unite
    \ -buffer-name=grep
    \ grep:**<cr>

nnoremap <silent> <Leader>gr :Unite
    \ -buffer-name=grep
    \ grep:**<cr><esc>

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

nnoremap <silent> <leader>rc :Unite
    \ -buffer-name=modified-files
    \ script-file:git-modified
    \ <cr><esc>

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
    \ outline<cr>

"### line ######################################################################

call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent> -- :Unite
    \ -buffer-name=line
    \ line
    \ <cr>

nnoremap <silent> --w :UniteWithCursorWord
    \ -buffer-name=line
    \ -no-start-insert
    \ line
    \ <cr>

nnoremap <silent> --r :Unite
    \ -buffer-name=line
    \ line
    \ <cr>

"### registers #################################################################

" also see source register
let g:unite_source_history_yank_enable = 1
let g:unite_source_history_yank_save_clipboard = 1
" let g:unite_source_history_yank_limit = 100
" let g:unite_source_history_yank_file = TODO

nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>

"### vim environment ###########################################################

call unite#custom#source('tab', 'sorters', ['sorter_nothing'])
call unite#custom#source('window', 'sorters', ['sorter_nothing'])
call unite#custom#source('buffer', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>v :<C-u>Unite
    \ -buffer-name=vimfos
    \ buffer window tab<cr>

nnoremap <silent> <leader>vm :<C-u>Unite
    \ -buffer-name=mappings
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
    \ mark
    \ <cr>

"### bookmark ##################################################################

nnoremap <silent> <Leader>m :UniteBookmarkAdd<cr>

nnoremap <silent> <Leader>mm :Unite
    \ -buffer-name=bookmark
    \ bookmark<cr>

nnoremap <silent> <Leader>mr :Unite
    \ -buffer-name=bookmark
    \ bookmark<cr>

"### end #######################################################################

  endfunction
  call neobundle#untap()
endif
