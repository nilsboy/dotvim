" for a list of vim's internal mappings see:
" :h index
"
" Good mappings tutorial:
" https://old.reddit.com/r/vim/comments/a4fg63/for_mappings_and_a_tutorial_vimways_824/
"
" Retain an existing mapping:
" :h maparg

" Potentially reassignable keys for normal mode:
" s, S, Q, Z, <bs>, M, r, R, <space>, Y, -, +, <cr>
" :help map-which-keys

" Possible insert mode leaders:
" imap <c-b>
" imap <c-space>

" These are the same in the terminal:
" Tab and Ctrl-I (<c-i><c-I>)
" Enter and Ctrl-M (<c-m>)
" Esc and Ctrl-[ (<c-[>)

inoremap <c-z> <esc><c-z>

" Adding a left shift key does not work like this
" nnoremap < <shift>

" Does not work on terminal vim
" nnoremap <s-space> <C-b>

" use <leader>! as prefix to remap stuff
" Remap <C-i> as it's the same as Tab
" nnoremap <leader>!a <C-o> foo
" nnoremap <leader>!b <C-i>

" jumplist
" <c-i> is the same as <tab>
nnoremap <c-u> <c-o>
nnoremap <c-o> <c-i>
vnoremap <c-u> <c-o>
vnoremap <c-o> <c-i>

imap <c-h> <esc><c-h>
imap <c-l> <esc><c-l>
imap <c-j> <esc><c-j>
imap <c-k> <esc><c-k>

vmap <c-h> <esc><c-h>
vmap <c-l> <esc><c-l>
vmap <c-j> <esc><c-j>
vmap <c-k> <esc><c-k>

" Never use formatprg (it's global) and doesn't fallback to vim's default
" set formatprg=false

" Nicer redo
" tags: undo
nnoremap U <c-r>
nnoremap <leader>ju U

" Dont use Q for Ex mode
nnoremap Q :xa<cr>

" make . work with visually selected lines
xnoremap . :norm.<CR>

" map gx myself as long as I disable netrw
nmap gx <leader>gx
nnoremap <silent> <leader>gx "zyiW:call system("xdg-open " . @z)<cr>

" Don't wait after escape in insert mode
" Breaks curser keys etc. (apparently not in Neovim)
" removed from Neovim (2017-03-01)
" set noesckeys

" Close buffer
" Mapping <esc> in vimrc breaks arrow behaviour"
" (http://stackoverflow.com/questions/11940801)
" - seems to be no problem with neovim
nnoremap <silent><esc> :call nb#buffer#close()<cr>

" Causes delay
" nnoremap <esc>[ <esc>[

nnoremap <leader>k :cclose \| :lclose<cr> q:i<esc>k

augroup MyVimrcAugroupAdjustWindowSizes
  autocmd VimEnter,VimResized * :let &previewheight = &lines / 3 * 2
  autocmd VimEnter,VimResized * :let &cmdwinheight = &lines / 3 * 2
  autocmd VimEnter,VimResized * :execute 'nnoremap rl ' . &columns / 2 . 'l'
  autocmd VimEnter,VimResized * :execute 'nnoremap rh ' . &columns / 2 . 'h'
  autocmd VimEnter,VimResized * :execute 'nnoremap rj ' . (&lines / 2 - 3) . 'j'
  autocmd VimEnter,VimResized * :execute 'nnoremap rk ' . (&lines / 2 - 3) . 'k'
augroup END

augroup MyVimrcAugroupCmdwinSetup
  autocmd!
  " Reset <cr> mapping for command-line-window in case <cr> is mapped somewhere
  autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>

  " autocmd CmdwinEnter * inoremap <buffer><silent> <tab> <esc>:quit<cr>
  autocmd CmdwinEnter * nnoremap <buffer><silent> <tab> :quit<cr>

  autocmd CmdwinEnter * nmap <buffer><silent> <c-j> :quit<cr>
  autocmd CmdwinEnter * nmap <buffer><silent> <c-k> :quit<cr>

  " autocmd CmdwinEnter * imap <buffer><silent> <c-h> <esc><c-h>
  autocmd CmdwinEnter * imap <buffer><silent> <c-j> <esc>:quit<cr>
  autocmd CmdwinEnter * imap <buffer><silent> <c-k> <esc>:quit<cr>
  " autocmd CmdwinEnter * imap <buffer><silent> <c-l> <esc><c-l>

  " autocmd CmdwinEnter * nmap <space><space> q:i
  autocmd CmdwinEnter * nmap <buffer><silent> <leader>k :quit<cr>
  autocmd CmdwinEnter * nmap <buffer><silent> Q <esc>:xa<cr>
augroup END

" Reselect visual block after indent
vnoremap <nowait>< <gv
vnoremap <nowait>> >gv

" similar to gv, reselects the last changed block
nnoremap gV `[v`]

" always search forward and N backward, use this
" nnoremap <expr> n 'Nn'[v:searchforward]
" nnoremap <expr> N 'nN'[v:searchforward]

nnoremap <silent> <leader>vv :execute "edit " . stdpath('config')
  \ . "/pack/my/start/3_config/after/plugin/z1_my_mappings.vim"<cr>
nnoremap <silent> <leader>vt :execute ':edit ' . stdpath('config')
  \ . '/pack/my/start/3_config/after/ftplugin/' . &filetype . '.vim'<cr>

" Show all mappings
nnoremap <leader>vem :Verbose cmap <bar> map<cr>

" Show all <leader> search mappings
nnoremap <leader>/H :Map <leader>/<cr> <bar>

" open search history and select last entry
nnoremap <leader>/k q/k

" search for selection
" vnoremap <leader>// y:execute '/' . @"<cr>
" vnoremap <leader>// y:/\V<c-r>"<cr>

nnoremap <leader>/C /\v^\s*[/"#]+<cr>

" search for character under cursor
nnoremap <leader>/c "zyl/<c-r>z<cr>

" nnoremap <leader>/b /^.*\S\+\s\+{\s*$<cr>
nnoremap <leader>/b /^.*{.*$<cr>
nnoremap <leader>/s /\\v^\\s*$<cr>
nnoremap <leader>/S /\\v^\\S+<cr>
nnoremap <leader>/w /\\<\\><left><left>
nnoremap <leader>/r gg/require<cr>}
nnoremap <leader>/t gg/TODO<cr>
" nnoremap ( ?[\[({<]<cr>
" nnoremap ) /[\[({<]<cr>
" nnoremap ( :normal F{<cr>
" nnoremap ) :normal f{<cr>
" nnoremap ) ?[\])}>]<cr>

" nnoremap [[ ?{<cr>
" nnoremap ]] /{<cr>

" Make gf work with relative file names and non existent files
nnoremap <leader>jf :execute ":edit " . getcwd() . '/' . expand('<cfile>')<cr>

" Restore cursor position after visual selection
nnoremap v m`v
nnoremap V m`V
nnoremap <C-v> m`<C-v>
vnoremap <esc> <esc>``
" clipboard
vnoremap y y``

nnoremap <leader>vH :Map <leader>v<cr>

function! MyZ0MyMappingsMessages() abort
  echom '=== Messages until '
        \ . strftime("%H:%M:%S")
        \ . ' ======================='
  call nb#createTempBuffer('messages')
  silent put!=execute('messages')
  keepjumps normal G
  setlocal syntax=txt
  silent! %s/\v\<09\>/\t/g
  silent! %s/\v\<00\>/\r/g
  echom ''
endfunction
nnoremap <silent> <leader>vM :call MyZ0MyMappingsMessages()<cr><cr>

" Easier change and replace word
nnoremap c* *Ncgn
nnoremap c# #NcgN
nnoremap cg* g*Ncgn
nnoremap cg# g#NcgN

" Go to alternate file
nnoremap <bs> <c-^>

" Replace selection
nnoremap gs :%s//g<Left><Left>
xnoremap gs "zy:%s/<C-r>z//g<Left><Left>
nnoremap gS "zyiw:%s/<C-r>z//g<Left><Left>

" Quickly jump to buffers
nnoremap gb :ls<cr>:buffer<space>

" select last pasted text
" nnoremap <expr> gp '`[' . getregtype()[0] . '`]'

" Toggle highlighting current matches
nmap <silent><c-c> :silent set hlsearch! hlsearch? \| :echo<CR>

" Marks:
" switch lower case marks with uppercase ones
" https://www.reddit.com/r/vim/comments/3g5v2m/is_there_any_way_to_use_lowercase_marks_instead/ctv5k6s/
noremap <silent> <expr> ' "`".toupper(nr2char(getchar()))
noremap <silent> <expr> m "m".toupper(nr2char(getchar()))
sunmap '
sunmap m

" nnoremap ' `
" nnoremap ` '

nnoremap gd [<c-d>
" nnoremap <silent> <leader>gd gd

cnoremap <expr> ,h fnameescape($HOME) . '/'
cnoremap <expr> ,d fnameescape(expand('%:p:h')) . '/'
cnoremap <expr> ,b fnameescape(expand('%:t'))
cnoremap <expr> ,f fnameescape(expand('%'))
cnoremap <expr> ,t &filetype . ' '

nnoremap <silent> <leader>vs :call z1_my_mappings#scriptnames()<cr>
function! z1_my_mappings#scriptnames(...) abort
  call nb#createTempBuffer('scriptnames')
  call setline('.', execute('scriptnames')->split("\n"))
  keepjumps normal! gg
endfunction

function! MyVimrcRtp() abort
  call nb#createTempBuffer("runtimepath")
  call setline('.', execute('echo &runtimepath')->split("\n"))
  %s/,/\r/g
  normal! gg
endfunction
nnoremap <silent> <leader>vR :call MyVimrcRtp()<cr>

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" function! z1_my_mappings#pm2log() abort
"   call nb#createTempBuffer("pm2-log")
"   call setline('.', execute('!pm2 log --raw --lines 30000 --nostream')->split("\n"))
"   keepjumps g/last 30000 lines/d
"   keepjumps normal! G
"   " 2020-06-25 15:39: info: Feathers application started on http://localhost:6000
"   silent! keepjumps keeppatterns %s/\v^\d+-\d+-\d+ \d+\:\d+\: //g
"   silent !pm2 flush
" endfunction
" nnoremap <silent> <leader>TBD :call z1_my_mappings#pm2log()<cr>

" TODO:
" " Press <Leader>e, then type any text‑object (e.g. i), a", iw, etc.)
" nnoremap <silent> ee :call JumpToEndOfTextObj()<CR>

" function! JumpToEndOfTextObj() abort
"   " Prompt for the text‑object (the user types it, e.g. i) )
"   let l:obj = nr2char(getchar())
"   " Build the normal‑mode command: select the object, exit visual, move right
"   execute 'normal! v' . l:obj . "\<Esc>l"
" endfunction

