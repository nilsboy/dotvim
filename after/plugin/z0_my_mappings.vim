" For a list of vim's internal mappings see:
" :h index

" Potentially reassignable keys for normal mode:
" s, S, Q, Z, <bs>, M, m, r, R, <space>, Y
" <cr> is used in quickfix etc for jumping
" Maybe use r as secondary leader?

" Possible insert mode leaders:
" imap <c-b>
" imap <c-space>

" These are the same for vim
" Tab and Ctrl-I (<c-i><c-I>)
" Enter and Ctrl-M (<c-m>)
" Esc and Ctrl-[ (<c-[>)

" Clear all mappings
" :mapclear

" Map space to leader instead of the other way around to keep the original
" leader in insert mode - because space does not work well there.
nmap <space> <leader>
vmap <space> <leader>

" Ignore the leader if the following key is not mapped
nmap <leader> <nop>
vmap <leader> <nop>

" also use <space> for custom text-objects - i.e. see: vim-textobj-lastpat.vim

nnoremap <leader>vee :call VimEnvironment()<cr><esc>
nnoremap <leader>veg :call DUMP(g:)<cr>

nnoremap <silent><c-z> :silent wall<cr><c-z>
inoremap <silent><c-z> <esc>:silent wall<cr><c-z>

" Save file as root
command! -nargs=* WriteWithSudo :SudoWrite

" Adding a left shift key does not work like this
" nnoremap < <shift>

" Does not work on terminal vim
" nnoremap <s-space> <C-b>

" use <leader>! as prefix to remap stuff
" Remap <C-i> as it's the same as Tab
" nnoremap <leader>!a <C-o>
" nnoremap <leader>!b <C-i>

" jump list
" <c-i> is the same as <tab>
nnoremap <c-u> <c-o>
nnoremap <c-o> <c-i>

" " Write all when leaving a tmux pane
" nmap <silent><c-j> :silent wall<cr><c-j>
" nmap <silent><c-k> :silent wall<cr><c-k>
" nmap <silent><c-h> :silent wall<cr><c-h>
" nmap <silent><c-l> :silent wall<cr><c-l>

imap <c-h> <esc><c-h>
imap <c-l> <esc><c-l>
imap <c-j> <esc><c-j>
imap <c-k> <esc><c-k>

vmap <c-h> <esc><c-h>
vmap <c-l> <esc><c-l>
vmap <c-j> <esc><c-j>
vmap <c-k> <esc><c-k>

nnoremap <silent> <leader>go :only<cr>

" Never use formatprg (it's global) and doesn't fallback to vim's default
set formatprg=false

" Nicer redo
" tags: undo
nnoremap U <c-r>
nnoremap <leader>gu U

" Dont use Q for Ex mode
nnoremap Q :xa<cr>

" make . work with visually selected lines
xnoremap . :norm.<CR>

nnoremap M '

" Quickly jump to buffers
nnoremap gb :ls<cr>:buffer<space>

nnoremap <silent><leader>ii :!firefox
      \ "https://duckduckgo.com/?q=<cword> site:stackoverflow.com"<cr><cr>
vnoremap <silent><leader>ii y:execute '!firefox '
      \ . 'https://duckduckgo.com/?q=' . @"<cr>
nnoremap <silent><leader>is :execute
      \ ":RunIntoBuffer so-lucky ". expand("<cword>") . " [" . &filetype . "]"<cr>

" Run current line in the shell
nnoremap <silent><leader>el :RunCursorLine<cr>

" Don't wait after escape in insert mode
" Breaks curser keys etc. (apparently not in Neovim)
" removed from Neovim (2017-03-01)
" set noesckeys

" Close buffer
" Mapping <esc> in vimrc breaks arrow behaviour"
" (http://stackoverflow.com/questions/11940801)
" - seems to be no problem with neovim
nnoremap <silent><esc> :call BufferClose()<cr>

" Causes delay
" nnoremap <esc>[ <esc>[

" Open command-line window
" :h cmdline-window
nnoremap <space><space> q:i
vnoremap <space><space> q:i
nnoremap <leader>k q:i<esc>k
nnoremap <leader>A q:i<esc>kA

augroup MyVimrcAugroupAdjustWindowSizes
  autocmd VimEnter,VimResized * :let &cmdwinheight = &lines / 5
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

  autocmd CmdwinEnter * nmap <buffer><silent> <c-h> :quit<cr><c-h>
  autocmd CmdwinEnter * nmap <buffer><silent> <c-j> :quit<cr><c-j>
  autocmd CmdwinEnter * nmap <buffer><silent> <c-k> :quit<cr>
  autocmd CmdwinEnter * nmap <buffer><silent> <c-l> :quit<cr><c-l>

  autocmd CmdwinEnter * nmap <buffer><silent> <leader>k :quit<cr>

  autocmd CmdwinEnter * imap <buffer><silent> <c-h> <esc>:quit<cr><c-h>
  autocmd CmdwinEnter * imap <buffer><silent> <c-j> <esc>:quit<cr><c-j>
  autocmd CmdwinEnter * imap <buffer><silent> <c-k> <esc>:quit<cr>
  autocmd CmdwinEnter * imap <buffer><silent> <c-l> <esc>:quit<cr><c-l>
augroup END

" Reselect visual block after indent
vnoremap <nowait>< <gv
vnoremap <nowait>> >gv

" similar to gv, reselects the last changed block
nnoremap gV `[v`]

" hide annoying quit message
" nnoremap <C-c> <C-c>:echo<cr>

" always search forward and N backward, use this
" nnoremap <expr> n 'Nn'[v:searchforward]
" nnoremap <expr> N 'nN'[v:searchforward]

nnoremap <leader>vr :execute "edit " . g:vim.etc.dir . "/README.md"<cr>
nnoremap <leader>vv :execute "edit " . g:vim.etc.dir . "after/plugin/z0_my_vimrc.vim"<cr>
nnoremap <silent> <leader>vt :execute ':edit ' 
  \ . fnameescape(g:vim.after.dir . 'ftplugin/' . &filetype . '.vim')<cr>

" Show all <leader> mappings
nnoremap <leader>vm :Verbose cmap <bar> map<cr> :only<cr>

" Show all <leader> search mappings
nnoremap <leader>/? :Verbose map <leader>/<cr> <bar> :only<cr>

" open search history and select last entry
nnoremap <leader>// q/k

" search for selection
" vnoremap <leader>// y:execute '/' . @"<cr>
vnoremap <leader>// y:/\V<c-r>"<cr>
nnoremap <leader>/C /\v^\s*[/"#]+<cr>
" nnoremap <leader>/b /^.*\S\+\s\+{\s*$<cr>
nnoremap <leader>/b /^.*{.*$<cr>
nnoremap <leader>/S /^\S\+<cr>
nnoremap <leader>/w /\\<\\><left><left>
nnoremap <leader>/r gg/require<cr>}
nnoremap <leader>/t gg/TODO<cr>
" nnoremap ( ?[\[({<]<cr>
" nnoremap ) /[\[({<]<cr>
nnoremap ( :normal F{<cr>
nnoremap ) :normal f{<cr>
" nnoremap ) ?[\])}>]<cr>

" nnoremap [[ ?{<cr>
" nnoremap ]] /{<cr>

" Make gf work with relative file names and non existent files
nnoremap <leader>gf :execute ":edit " . expand('%:h') . '/' . expand('<cfile>')<cr>

nnoremap ' `
nnoremap ` '

" Restore cursor position after visual selection
nnoremap v m`v
nnoremap V m`V
nnoremap <C-v> m`<C-v>
vnoremap <esc> <esc>``
vnoremap y y``

nnoremap <silent><leader>gm :echom '=== Messages until ' . strftime("%H:%M:%S")
      \ . ' ======================='
      \ \| :silent Verbose messages<cr> \| :silent only \| :normal G <cr>
      \ \| :setlocal syntax=txt
      \ \| echom ''
      \ <cr>

" Easier change and replace word
nnoremap c* *Ncgn
nnoremap c# #NcgN
nnoremap cg* g*Ncgn
nnoremap cg# g#NcgN

nnoremap <leader>hW :execute 'Help ' . expand('<cWORD>')<cr>
nnoremap <leader>hh :execute 'Help ' . expand('<cword>')<cr>
vnoremap <leader>hh y:execute 'Help ' . escape(expand(@"), ' ')<cr>
nnoremap <leader>hp :call Help(expand('%:t:r'))<cr>

" Go to alternate file
nnoremap <bs> <c-^>

" Replace selection
nnoremap gs :%s//g<Left><Left>
xnoremap gs y:%s/<C-r>"//g<Left><Left>
nnoremap gS :%s/<C-r><C-w>/<c-r><c-w>/g<left><left>
xnoremap gS :%s/<C-r>"/<c-r>"/g<left><left>

nnoremap <cr> :
" inoremap <c-space> <c-x><c-o>

" TODO: find mapping - gp?
" select last pasted text
" nnoremap x `[v`]

command! -nargs=* EditInBufferDir
      \ :execute 'edit ' . expand('%:p:h') . '/' . expand('<args>')

" Toggle highlighting current matches
nmap <silent><c-c> :silent set hlsearch! hlsearch?<CR>

set nowildmenu
cnoremap <tab> <C-L><C-D>

" switch lower case marks with uppercase ones
" https://www.reddit.com/r/vim/comments/3g5v2m/is_there_any_way_to_use_lowercase_marks_instead/ctv5k6s/
noremap <silent> <expr> ' "'".toupper(nr2char(getchar()))
noremap <silent> <expr> m "m".toupper(nr2char(getchar()))
sunmap '
sunmap m

