finish
" Unite and create user interfaces
NeoBundle 'Shougo/unite.vim', {
    \ 'name' : 'unite.vim'
    \ , 'depends' : 'Shougu/vimproc.vim'
\ }

" Unite still needed to use some unite sources with denite.

finish

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
" NeoBundle 'Shougo/unite-help'

if neobundle#tap('unite.vim') 
    function! neobundle#hooks.on_post_source(bundle)

let g:unite_data_directory = $XDG_CACHE_DIR . "/unite"
" let g:unite_enable_auto_select = 0

" Probably does not work with volatile sources
" call unite#filters#matcher_default#use(['matcher_fuzzy'])

" complains if not set
" let g:unite_abbr_highlight = "function"

" let g:unite_source_line_enable_highlight = 1

let g:unite_prompt = "> "
" set previewheight=20

call unite#custom#profile('default', 'context', {
    \ 'match_input' : 'Search',
    \ 'keep_focus' : 1,
    \ 'silent' : 1,
    \ 'auto_preview' : 1,
    \ 'start_insert': 1,
    \ 'smart_case': 1,
    \ 'hide_source_names': 1,
\ })

    " \ 'sync' : 1,
    " \ 'previewheight': 999,
    " \ 'auto_highlight': 1,
    " \ 'vertical_preview': 1,
    " \ 'custom_grep_search_word_highlight': 'Search',
    " \ 'auto_preview' : 1,
    " \ 'wipe' : 1,
    " \ 'wrap' : 1,
    " \ 'no_split' : 1,
    " \ 'resume' : 1,
    " \ 'here' : 1,

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

autocmd FileType unite nmap <nowait><buffer> <TAB> <plug>(unite_all_exit)
autocmd FileType unite imap <nowait><buffer> <TAB> <esc><plug>(unite_all_exit)
" autocmd FileType unite imap <nowait><buffer> <TAB> <esc>

autocmd FileType unite nmap <nowait><buffer> <esc> <plug>(unite_exit)

autocmd FileType unite nmap <buffer> <cr> <Plug>(unite_do_default_action)
autocmd FileType unite imap <buffer> <cr> <Plug>(unite_do_default_action)
autocmd FileType unite nmap <buffer> R <Plug>(unite_redraw)

autocmd FileType unite nnoremap <buffer> i gg0"_DA
autocmd FileType unite nnoremap <buffer> A ggA

autocmd FileType unite imap <buffer><silent> <c-h> <esc><c-h>
autocmd FileType unite imap <buffer><silent> <c-j> <esc><c-j>
autocmd FileType unite imap <buffer><silent> <c-k> <esc><c-k>
autocmd FileType unite imap <buffer><silent> <c-l> <esc><c-l>

autocmd FileType unite nmap <buffer><silent> L :call BufferSwitchToNextByName('[unite]')<cr>
autocmd FileType unite nmap <buffer><silent> H :call BufferSwitchToPreviousByName('[unite]')<cr>

"### files #####################################################################

let g:unite_source_rec_max_cache_files = 0

nnoremap <silent> <leader>ff :call Find_Unite()<cr><esc>
function! Find_Unite() abort
    call CdProjectRoot()
    :Unite
      \ -buffer-name=find-project-unite
      \ script-file:find-and
endfunction

nnoremap <silent> <leader>fd :call FindDir_Unite()<cr><esc>
function! FindDir_Unite() abort
    execute "lcd" expand("%:p:h")
    :Unite
      \ -buffer-name=find-dir-unite
      \ script-file:find-and
endfunction

nnoremap <silent> <leader>fw :call FindWord_Unite()<cr><esc>
function! FindWord_Unite() abort
    call CdProjectRoot()
    :UniteWithCursorWord
        \ -buffer-name=find-word-unite
        \ script-file:find-and
endfunction

nnoremap <silent> <leader>vp :call FindVimPlugins_Unite()<cr><esc>
function! FindVimPlugins_Unite() abort
    execute 'lcd ' . g:vim.bundle.dir
    :Unite
        \ -buffer-name=find-vim-plugins-unite
        \ script-file:find-and
endfunction

"### grep ######################################################################

" call unite#custom#source('grep', 'converters', 
    " \ ['converter_tail_abbr'])

let g:unite_source_grep_default_opts = ' -inH '
    \ . ' --exclude-dir "node_modules" '
    \ . ' --exclude-dir "bower_components" '
    \ . ' --exclude-dir ".git" '
    \ . ' --exclude ".*" '
    \ . ' --exclude "*.class" '
    \ . ' --exclude-dir "classes" '

" Use ag for search
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column --smart-case'
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <silent> <leader>gg yiw:call Grep_Unite(@")<cr>
nnoremap <silent> <leader>gW yiW:call Grep_Unite(@")<cr>
vnoremap <silent> <Leader>gg y:call Grep_Unite(@")<cr>
nnoremap <silent> <leader>gi :call Grep_Unite(input("Grep for: "))<cr>

function! Grep_Unite(term) abort
    let l:term = escape(a:term, " ")
    call CdProjectRoot()
    execute "
      \ Unite
          \ -buffer-name=grep-input-unite
          \ -input=" . l:term . "
          \ -no-start-insert
          \ script-file:find-and
          \ grep:**
      \ "
endfunction

"### Most Recent files #########################################################

" MRU plugin includes unite.vim MRU sources
NeoBundle 'Shougo/neomru.vim'

call unite#custom#source('neomru/file', 'converters', 
    \ ['converter_file_directory_pretty'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

let g:neomru#file_mru_limit=3000

nnoremap <silent> <tab> :call UniteResumeOrFallback()<cr><esc>
function! UniteResumeOrFallback() abort
  if BufferFindByName('[unite]')
    UniteResume
  else
    call Recent_Global_Unite()
  endif
endfunction

nnoremap <silent> <leader>rg :call Recent_Global_Unite()<cr><esc>
function! Recent_Global_Unite() abort
  :Unite
    \ -buffer-name=recent-files-unite
    \ neomru/file
endfunction

nnoremap <silent> <leader>rr :UniteWithProjectDir
    \ -buffer-name=recent-files-in-project-unite
    \ neomru/file
    \ <cr><esc>

nnoremap <silent> <leader>rd :Unite
    \ -buffer-name=recent-directories-unite
    \ -default-action=vimfiler
    \ neomru/directory
    \ <cr><esc>

"### change list ###############################################################

nnoremap <silent> <leader>c :Unite
    \ -buffer-name=jump-unite
    \ change jump
    \ <cr><esc>

"### git #######################################################################

nnoremap <silent> <leader>gc :Unite
    \ -buffer-name=git-modified-unite
    \ -no-start-insert
    \ script-file:git-modified
    \ <cr><esc>

nnoremap <silent> <Leader>o :<C-u>Unite
    \ -buffer-name=outline-unite
    \ outline
    \ <cr><esc>

"### line ######################################################################

call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent><leader>/ :Unite
    \ -buffer-name=line-unite
    \ line
    \ <cr><esc>

nnoremap <silent><leader>// :UniteWithCursorWord
    \ -buffer-name=line-cursor-unite
    \ -no-start-insert
    \ line
    \ <cr><esc>

"### vim environment ###########################################################

call unite#custom#source('tab', 'sorters', ['sorter_nothing'])
call unite#custom#source('window', 'sorters', ['sorter_nothing'])

call unite#custom#source('buffer', 'sorters', ['sorter_nothing'])
let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "

nnoremap <silent><leader>vv :<C-u>Unite
    \ -buffer-name=buffers-unite
    \ buffer
    \ <cr><esc>

nnoremap <silent><leader>va :<C-u>Unite
    \ -buffer-name=all-buffers-unite
    \ buffer:!
    \ <cr><esc>

call unite#custom#source('mapping', 'sorters', ['sorter_word'])
nnoremap <silent><leader>vm :<C-u>Unite
    \ -buffer-name=mappings-unite
    \ mapping
    \ <cr><esc>

" vim help
" Don't use! locks vim up
" nnoremap <leader>vh :Unite help<cr><esc>

"### Marks #####################################################################

" Unite source for marks
NeoBundle 'tacroe/unite-mark'

"    \   "abcdefghijklmnopqrstuvwxyz"
"    \ . "0123456789.'`^<>[]{}()\""
let g:unite_source_mark_marks =
    \ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

" nnoremap <silent> <leader>mm :Unite
"     \ -buffer-name=marks-unite
"     \ mark
"     \ <cr><esc>

"### bookmark ##################################################################

nnoremap <silent> <Leader>bb :Unite
    \ -buffer-name=bookmark-unite
    \ bookmark
    \ <cr><esc>

nnoremap <silent> <Leader>ba :UniteBookmarkAdd<cr><esc>

"### quickfix ##################################################################

NeoBundle 'sgur/unite-qf'

nnoremap <silent> <leader>qq :Unite
    \ -buffer-name=quickfix-unite
    \ -no-auto-preview
    \ qf
    \ <cr><esc>

" Needs to be BufWinEnter not BufReadPost for youcompleteme's
" GoToReferences to work
autocmd BufWinEnter quickfix call s:ReplaceQuickfixWithUnite()
function s:ReplaceQuickfixWithUnite()
    cclose
    Unite
        \ -buffer-name=quickfix-unite
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
"             \ -buffer-name=files-unite
"             \ script-file:abs=1\ find-and
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

