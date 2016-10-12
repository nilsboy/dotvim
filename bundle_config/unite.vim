" Unite and create user interfaces
NeoBundle 'Shougo/unite.vim', {
    \ 'name' : 'unite.vim'
    \ , 'depends' : 'Shougu/vimproc.vim'
\ }

" autocmd FileType unite setlocal winheight=20

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
"
" List all kinds
" let x = unite#get_kinds() | echo x

"## defaults ###################################################################

let g:unite_no_default_keymappings = 1

" help source for unite.vim
NeoBundle 'Shougo/unite-help'

if neobundle#tap('unite.vim') 
    function! neobundle#hooks.on_post_source(bundle)

let g:unite_data_directory = g:vim.cache.dir . "unite"
" let g:unite_enable_auto_select = 0

" Probably does not work with volatile sources
" call unite#filters#matcher_default#use(['matcher_fuzzy'])

" complains if not set
let g:unite_abbr_highlight = "function"

let g:unite_prompt = "> "

call unite#custom#profile('default', 'context', {
    \ 'sync' : 1,
    \ 'match_input' : 1,
    \ 'keep_focus' : 1,
    \ 'silent' : 1,
    \ 'auto_preview' : 1,
    \ 'start_insert': 1,
\ })
" \ 'auto_preview' : 1,
" \ 'wipe' : 1,
" \ 'no_split' : 1,
" \ 'resume' : 1,
" \ 'here' : 1,
" TODO check -previewheight={height}

nnoremap <nowait><silent><tab> :UniteResume -no-start-insert<cr>

"### allow open action for script-file #####################################

" let x = unite#get_kinds("word") | echo x
"    \ -default-action=open

" does not work:
" [unite.vim] Vim(if):E716: Key not present in Dictionary: action__path)
" call extend(unite#get_kinds("word").parents, [ 'file' ])
" call unite#custom_default_action('word', 'open')

call unite#custom#source('script-file', 'converters',
    \ ['converter_file_directory_pretty'])
call unite#custom#source('script-file', 'sorters', ['sorter_nothing'])

"### Unite buffer mappings ######################################################

" Hack sometimes unite does not close
autocmd FileType unite nmap <buffer><silent> x :pc! \| :bwipeout!<cr><esc>

autocmd FileType unite nmap <nowait><buffer> <TAB> <plug>(unite_exit)
autocmd FileType unite imap <nowait><buffer> <TAB> <esc><plug>(unite_exit)
" autocmd FileType unite imap <nowait><buffer> <TAB> <esc>

autocmd FileType unite nmap <nowait><buffer> <esc> <plug>(unite_exit)

autocmd FileType unite nmap <buffer> <cr> <Plug>(unite_do_default_action)
autocmd FileType unite imap <buffer> <cr> <Plug>(unite_do_default_action)

autocmd FileType unite nnoremap <buffer> i gg0"_DA
autocmd FileType unite nnoremap <buffer> A ggA

"### files #####################################################################

" See: https://github.com/Shougo/unite.vim/issues/1186
" Emulate :UniteWithProjectDir
nnoremap <silent> <leader>ff :Unite
    \ -buffer-name=files-in-project-dir
    \ -smartcase
    \ script-file:find-and-limit\ --fallback-to-cwd\ --project\ --abs
    \ <cr><esc>

" Emulate :UniteWithBufferDir
nnoremap <silent> <leader>fb :call UniteFindFilesInBufferProjectDir()<cr><esc>
function! UniteFindFilesInBufferProjectDir()
    let $_VIM_LEADER_FB = expand("%:p:h")
    :Unite
        \ -buffer-name=files-in-buffer-dir
        \ -smartcase
        \ script-file:find-and-limit\ --fallback-to-cwd\ --dir\ "$_VIM_LEADER_FB"\ --project\ --abs
endfunction

nnoremap <silent> <leader>fd :call UniteFindFilesInBufferDir()<cr><esc>
function! UniteFindFilesInBufferDir()
  let $_VIM_LEADER_FB = expand("%:p:h")
  :Unite
        \ -buffer-name=files-in-buffer-dir
        \ -smartcase
        \ script-file:find-and-limit\ --dir\ "$_VIM_LEADER_FB"\ --abs
endfunction

" Find inside vim bundle directories
nnoremap <silent> <leader>vb :Unite
    \ -buffer-name=vim-bundle-directories
    \ -smartcase
    \ script-file:find-and-limit\ --dir\ "$_VIM_BUNDLE_DIR"\ --abs
    \ <cr><esc>

nnoremap <silent> <Leader>fg :UniteWithCursorWord
    \ -buffer-name=grep-cursor
    \ script-file:find-and-limit\ --abs\ --basename
    \ <cr><esc>

"### grep ######################################################################

call unite#custom#source('grep', 'converters', 
    \ ['converter_tail_abbr'])

let g:unite_source_grep_default_opts = ' -inH '
    \ . ' --exclude-dir "node_modules" '
    \ . ' --exclude-dir "bower_components" '
    \ . ' --exclude-dir ".git" '
    \ . ' --exclude ".*" '
    \ . ' --exclude "*.class" '
    \ . ' --exclude-dir "classes" '

nnoremap <silent> <Leader>gg :UniteWithCursorWord
    \ -buffer-name=grep-cursor
    \ -no-start-insert
    \ script-file:find-and-limit\ --abs
    \ grep:**
    \ <cr><esc>

vnoremap <silent> <Leader>gg y:Unite
    \ -buffer-name=grep-word
    \ -no-start-insert
    \ -input=<c-r>=escape(@", '\\.*$^[]')<cr><esc>
    \ script-file:find-and-limit\ --abs
    \ grep:**::<c-r>=escape(@", '\\.*$^[]')<cr><esc>
    \ <cr><esc>

nnoremap <silent> <Leader>gi :UniteWithInput
    \ -buffer-name=grep-input
    \ -no-start-insert
    \ script-file:find-and-limit\ --abs
    \ grep:**
    \ <cr>

" :UniteWithCursorWord grep:$buffers

"### mru #######################################################################

" MRU plugin includes unite.vim MRU sources
NeoBundle 'Shougo/neomru.vim'

call unite#custom#source('neomru/file', 'converters', 
    \ ['converter_file_directory_pretty'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

let g:neomru#file_mru_limit=3000

nnoremap <silent> <leader>rr :Unite
    \ -buffer-name=recent-files
    \ neomru/file
    \ <cr><esc>

nnoremap <silent> <leader>rp :UniteWithProjectDir
    \ -buffer-name=recent-files-in-project
    \ neomru/file
    \ <cr><esc>

nnoremap <silent> <leader>rd :Unite
    \ -buffer-name=recent-directories
    \ -default-action=project_cd
    \ neomru/directory
    \ <cr><esc>

"### change list ###############################################################

nnoremap <silent> <leader>c :Unite
    \ -buffer-name=jump
    \ change jump
    \ <cr><esc>

"### git #######################################################################

nnoremap <silent> <leader>gc :Unite
    \ -buffer-name=git-modified
    \ -no-start-insert
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
    \ outline
    \ <cr><esc>

"### line ######################################################################

call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent><leader>/ :Unite
    \ -buffer-name=line
    \ line
    \ <cr><esc>

nnoremap <silent><leader>// :UniteWithCursorWord
    \ -buffer-name=line-cursor
    \ -no-start-insert
    \ line
    \ <cr><esc>

"### vim environment ###########################################################

call unite#custom#source('tab', 'sorters', ['sorter_nothing'])
call unite#custom#source('window', 'sorters', ['sorter_nothing'])

call unite#custom#source('buffer', 'sorters', ['sorter_nothing'])
let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "

" nnoremap <nowait><leader>b :Unite -buffer-name=buffers buffer:! <cr><esc>

nnoremap <silent><leader>vv :<C-u>Unite
    \ -buffer-name=buffers
    \ buffer
    \ <cr><esc>
    " \ window tab

call unite#custom#source('mapping', 'sorters', ['sorter_word'])
nnoremap <silent><leader>vm :<C-u>Unite
    \ -buffer-name=mappings
    \ mapping
    \ <cr><esc>

" Show vim's predefined mappings
nnoremap <silent><leader>vM :help index \| :only<cr><esc>

" vim help
nnoremap <leader>vh :Unite help<cr><esc>

" vim environment
nnoremap <leader>vee :call VimEnvironment()<cr><esc>

"### Marks #####################################################################

" Unite source for marks
NeoBundle 'tacroe/unite-mark'

"    \   "abcdefghijklmnopqrstuvwxyz"
"    \ . "0123456789.'`^<>[]{}()\""
let g:unite_source_mark_marks =
    \ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

nnoremap <silent> <leader>mm :Unite
    \ -buffer-name=marks
    \ mark
    \ <cr><esc>

"### bookmark ##################################################################

nnoremap <silent> <Leader>bb :Unite
    \ -buffer-name=bookmark
    \ bookmark
    \ <cr><esc>

nnoremap <silent> <Leader>ba :UniteBookmarkAdd<cr><esc>

"### quickfix ##################################################################

NeoBundle 'sgur/unite-qf'

nnoremap <silent> <leader>qq :Unite
    \ -buffer-name=quickfix
    \ -no-auto-preview
    \ qf
    \ <cr><esc>

" Needs to be BufWinEnter not BufReadPost for youcompleteme's
" GoToReferences to work
autocmd BufWinEnter quickfix call s:ReplaceQuickfixWithUnite()
function s:ReplaceQuickfixWithUnite()
    cclose
    Unite
        \ -buffer-name=quickfix
        \ -no-auto-preview
        \ qf
endfunction


"### end #######################################################################

  endfunction
  call neobundle#untap()
endif

"### experiments ###############################################################

" let g:unite_open = 0

" augroup UniteSetOpen
"     autocmd!
"     autocmd BufCreate,BufAdd,BufEnter * call UniteSetOpen()
" augroup END
" function! UniteSetOpen()
"     if &filetype == "unite"
"         let g:unite_open = 1
"     endif
" endfunction

" augroup UniteSetClosed
"     autocmd!
"     autocmd BufLeave * call UniteSetClosed()
" augroup END
" function! UniteSetClosed()
"     let l:buffer = bufnr(expand("<abuf>"))
"     let l:type = getbufvar(l:buffer, "&filetype")
"     if &filetype == "unite"
"         let g:unite_open = 0
"     endif
" endfunction

" augroup UniteSetClosed
"     autocmd!
"     autocmd BufHidden,BufLeave * call UniteSetClosed()
" augroup END
" function! UniteSetClosed()
"     if &filetype == "unite"
"         let g:unite_open = 0
"     endif
" endfunction

" augroup SingleWindowMode
"     autocmd!
"     " autocmd FileType * call SingleWindowMode()
"     autocmd BufEnter * call SingleWindowMode()
" augroup END
" function! SingleWindowMode()
"     if &filetype == "unitexx"
"         return
"     endif
"     if g:unite_open == 0
"         " call unite#view#_quit(0)
"         " only
"         resize
"     endif
" endfunction

" Does not work
" Use file source on first resume invocation if no unite buffer exists jet.
" nnoremap <silent><tab> :call UniteResumeWithoutSource()<cr><esc>
" function! UniteResumeWithoutSource()
"     if bufname("unite") != ""
"         :UniteResume
"     else
"         :Unite
"             \ -buffer-name=files
"             \ -smartcase
"             \ script-file:abs=1\ find-and-limit
"     endif
" endfunction

" " https://github.com/Shougo/unite.vim/issues/278#issuecomment-52061459
" " Wipe unite window - stops :UniteResume from working
" augroup unite_wipe_nosplit
"     autocmd!
"     autocmd BufLeave *
"         \ if &filetype ==# 'unite' |
"         \   setlocal bufhidden=wipe |
"         \ endif
" augroup END


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

