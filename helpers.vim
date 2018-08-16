" VimL Helper Libraries
" - l9.vim
" - https://github.com/LucHermitte/lh-vim-lib
" - tomtom/tlib_vim
" - ingo-library

" Close a buffer writing its content and closing vim if appropriate.
function! BufferClose() abort
  if BufferIsCommandLine() == 1
    silent! quit
    return
  endif
  if BufferIsQuickfix()
    cclose
    return
  endif
  if BufferIsLoclist()
    lclose
    return
  endif
  let wasQfOpen = MyHelpersQuickfixIsOpen()
  if wasQfOpen
    cclose
  endif
  if ! &previewwindow
    pclose
  endif
  if BufferIsUnnamed() == 1
  elseif &write
    silent update
  endif
  if BufferIsLast() == 1
    silent! q!
  endif
  " Using bwipe prevents the current position mark from being saved - so
  " the file position can not be restored when loading the file again.
  " netrw leaves its buffers in a weired state
  if BufferIsNetrw() == 1
    silent! bwipeout!
  else
    silent! bdelete!
  endif
  if wasQfOpen
    copen
    wincmd p
  endif
endfunction

" function! BufferCheckAndDeleteEmpty() abort
"     if bufname('%') == ''
"       return
"     endif
"     if BufferIsSpecial()
"       return
"     endif
"     " call INFO('BufferIsSpecial(): ', BufferIsSpecial() . bufname('%'))
"     bufdo :call BufferDeleteEmpty()
" endfunction
" function! BufferDeleteEmpty() abort
"     if BufferIsSpecial()
"       return
"     endif
"     if BufferIsEmpty() == 1 && BufferIsUnnamed() == 1
"         silent bdelete!
"     endif
" endfunction
" augroup s:BufferDeleteEmpty
"     " autocmd BufReadPost * :call BufferCheckAndDeleteEmpty()
"     " autocmd BufReadPost * :call BufferListedCount()
"     autocmd BufReadPost * :bufdo call INFO('bn: '. bufname('%'))
"     " autocmd BufReadPost * :call BufferDeleteEmpty()
" augroup END

function! BufferListedCount() abort
    let lastBuffer = bufnr('$')
    let listed = 0
    let i = 0
    while i <= lastBuffer
        let i = i + 1
        if BufferIsSpecial() == 1
          continue
        endif
        if buflisted(i) == 1
            let listed = listed + 1
        endif
    endwhile
    return listed
endfunction

function! BufferIsSpecial() abort
  if &previewwindow == 1
    return 1
  endif
  return bufname('%') =~ '\v.*\[.*' ? 1 : 0
endfunction

function! BufferIsCommandLine() abort
    if bufname("%") == '[Command Line]'
        return 1
    endif
    return 0
endfunction

function! BufferIsNetrw() abort
    if &filetype == 'netrw'
        return 1
    endif
    return 0
endfunction

function! BufferIsUnnamed() abort
    if empty(bufname("%"))
        return 1
    else
        return 2
    endif
endfunction

function! BufferIsEmpty() abort
    if line('$') == 1 && getline(1) == '' 
        return 1
    else
        return 0
    endif
endfunction

function! BufferCanWrite() abort
    return &write
endfunction

function! BufferIsLast() abort

    let lastBuffer = bufnr('$')

    let listed = 0
    let i = 1
    while i <= lastBuffer

        if buflisted(i) == 1
            let listed = listed + 1
        endif

        if listed > 1
            return 0
        endif

        let i = i + 1

    endwhile

    return 1

endfunction

function! BufferFindByFiletype() abort

    let lastBuffer = bufnr('$')

    let listed = 0
    let i = 1
    while i <= lastBuffer

        if buflisted(i) == 1
            let listed = listed + 1
        endif

        if listed > 1
            return 0
        endif

        let i = i + 1

    endwhile

    return 1

endfunction

function! BufferFindByName(name) abort
    let lastBuffer = bufnr('$')
    let i = 1
    while i <= lastBuffer
        if bufname(i) =~ fnameescape(a:name)
          return i
        endif
        let i = i + 1
    endwhile
    return 0
endfunction

function! BufferFindNextByName(name, current) abort
  return BufferFindAnotherByName(a:name, a:current, 1)
endfunction

function! BufferFindPreviousByName(name, current) abort
  return BufferFindAnotherByName(a:name, a:current, -1)
endfunction

function! BufferFindAnotherByName(name, current, direction) abort
    let l:lastBuffer = bufnr('$')
    let l:i = bufnr(a:current)
    while l:i * a:direction <= lastBuffer
        let l:name = bufname(l:i)

        if l:name == a:current
          let l:i = l:i + a:direction
          continue
        endif

        if l:name =~ fnameescape(a:name)
          return l:i
        endif

        let l:i = l:i + a:direction
    endwhile
    return 0
endfunction

function! BufferSwitchToNextByName(name) abort
  let l:unite_buffer = BufferFindNextByName(a:name, expand('%'))
  if l:unite_buffer == 0
    echo "No next " . a:name . " buffer found."
    return
  endif
  execute ":buffer " . l:unite_buffer
endfunction

function! BufferSwitchToPreviousByName(name) abort
  let l:unite_buffer = BufferFindPreviousByName(a:name, expand('%'))
  if l:unite_buffer == 0
    echo "No previous " . a:name . " buffer found."
    return
  endif
  execute ":buffer " . l:unite_buffer
endfunction

command! -nargs=1 BufferCreateTemp call BufferCreateTemp(<f-args>)
function! BufferCreateTemp(...) abort
    execute ":new /tmp/" . split(a:1, " ")[0]
    normal ggdG
    setlocal buftype=nowrite
endfunction

function! RedirNew(name, command) abort
    call BufferCreateTemp(a:name)
    silent execute ":Redir :" . a:command
endfunction
command! -nargs=+ RedirNew call RedirNew("<args>")

command! -nargs=+ Redir call Redir("<args>")
function! Redir(command) abort
    call RedirIntoCurrentBuffer(a:command)
    normal ggdddd
endfunction

" TODO checkout :Verbose
function! RedirIntoCurrentBuffer(command) abort

    let output = ""
    redir => output

    " Execute the specified command
    try
        silent execute a:command
    catch
        put='command failed'
    finally
        redir END

        " Place the output in the destination buffer.
        silent put=output
    endtry

endfunction

command! -nargs=* Run call Run(<f-args>)
function! Run(...) abort
    let buffer_name = a:1
    let command = join(a:000[1:])
    call INFO('Running ' . command)
    silent! execute ":e " . buffer_name
    " normal! ggdG
    setlocal buftype=nowrite
    silent execute ":r! " . command
endfunction

" Checkout: https://github.com/thinca/vim-quickrun
function! RunIntoBuffer(...) abort

    silent wall

    let buffer_name = a:1
    let buffer_name = substitute(buffer_name, '[^a-zA-Z0-9_\-/\.]', "", "g")
    if buffer_name == ""
        let buffer_name = "cmd"
    endif
    let buffer_name = buffer_name . ".output"

    call BufferCreateTemp(buffer_name)
    normal die
    only

    let command = join(a:000)
    " let command = substitute(command, ';', "\\\\;", "g")
    " silent! execute ":r!run-and-capture 'echo " . command . " | bash'"
    let command = shellescape(command)
    " echom "Running command: " . command
    silent! execute ":r!run-and-capture " . command
    normal ggddG

    " %!html-strip

    " Remove broken linebreak
    %s/\r//ge

    " Hack: remove duplicate perl line number
    " %s/\v,  line \d+//ge

    " Convert ansi colors
    " Screws with color conversion of colorscheme
    " AnsiEsc
    " fix invisible ansi white
    " hi ansiWhite ctermfg=black

    setlocal wrap

    " TODO execute "/" . command

    " Seems to break CSApprox vim colors:
    " AnsiEsc

    setlocal syntax=txt

    " autocmd BufEnter <buffer> :AnsiEsc
    " autocmd BufEnter <buffer> hi ansiWhite ctermfg=black

endfunction
command! -nargs=* RunIntoBuffer call RunIntoBuffer(<f-args>)

let g:commands = []

call add(g:commands, 'verbose map<buffer>  ')   " buffer local Normal and Visual mode maps
call add(g:commands, 'verbose map!<buffer> ')   " buffer local Insert and Command-line mode maps

" ### There are six sets of mappings

call add(g:commands, 'verbose map          ')   " Normal-mode mappings only

" - For Normal mode: When typing commands.
call add(g:commands, 'verbose nmap         ')   " Normal-mode mappings only

" - For Visual mode: When typing commands while the Visual area is highlighted.
call add(g:commands, 'verbose xmap         ')   " visual mode maps only

" - For Select mode: like Visual mode but typing text replaces the selection.
call add(g:commands, 'verbose smap         ')   " Select-mode mappings only

" - For Operator-pending mode: When an operator is pending (after "d", "y", "c",
"   etc.).  See below: |omap-info|.
call add(g:commands, 'verbose omap         ')   " Operator-pending mode mappings only

" - For Insert mode.  These are also used in Replace mode.
call add(g:commands, 'verbose imap         ')   " list insert mode maps

" - For Command-line mode: When entering a ":" or "/" command.
call add(g:commands, 'verbose cmap         ')   " list command mode maps

call add(g:commands, 'verbose lmap         ')   " language mappings (set by keymap or by lmap)

call add(g:commands, 'abbreviate   ')   " list abbreviations
call add(g:commands, 'args         ')   " argument list
call add(g:commands, 'augroup      ')   " augroups
call add(g:commands, 'verbose autocmd      ')   " list auto-commands
call add(g:commands, 'buffers      ')   " list buffers
call add(g:commands, 'breaklist    ')   " list current breakpoints
call add(g:commands, 'cabbrev      ')   " list command mode abbreviations
call add(g:commands, 'changes      ')   " changes
call add(g:commands, 'verbose command      ')   " list commands
call add(g:commands, 'compiler     ')   " list compiler scripts
call add(g:commands, 'digraphs     ')   " digraphs
call add(g:commands, 'file         ')   " print filename, cursor position and status (like Ctrl-G)
call add(g:commands, 'filetype     ')   " on/off settings for filetype detect/plugins/indent
call add(g:commands, 'verbose function     ')   " list user-defined functions (names and argument lists but not the full code)
call add(g:commands, 'highlight    ')   " highlight groups
call add(g:commands, 'history c    ')   " command history
call add(g:commands, 'history =    ')   " expression history
call add(g:commands, 'history s    ')   " search history
call add(g:commands, 'history      ')   " your commands
call add(g:commands, 'iabbrev      ')   " list insert mode abbreviations
call add(g:commands, 'intro        ')   " the Vim splash screen, with summary version info
call add(g:commands, 'jumps        ')   " your movements
call add(g:commands, 'language     ')   " current language settings
call add(g:commands, 'let          ')   " all variables
call add(g:commands, 'let g:       ')   " global variables
call add(g:commands, 'let v:       ')   " Vim variables
call add(g:commands, 'list         ')   " buffer lines (many similar commands)
call add(g:commands, 'ls           ')   " buffers
call add(g:commands, 'ls!          ')   " buffers, including unlisted buffers
call add(g:commands, 'marks        ')   " marks
call add(g:commands, 'menu         ')   " menu items
call add(g:commands, 'messages     ')   " message history
call add(g:commands, 'print        ')   " display buffer lines (useful after :g or with a range)
call add(g:commands, 'reg          ')   " registers
call add(g:commands, 'scriptnames  ')   " all scripts sourced so far
call add(g:commands, 'set all      ')   " all options, including defaults
call add(g:commands, 'setglobal    ')   " global option values
call add(g:commands, 'setlocal     ')   " local option values
call add(g:commands, 'set          ')   " options with non-default value
call add(g:commands, 'set termcap  ')   " list terminal codes and terminal keys
call add(g:commands, 'spellinfo    ')   " spellfiles used
call add(g:commands, 'syntax       ')   " syntax items
call add(g:commands, 'syn sync     ')   " current syntax sync mode
call add(g:commands, 'tabs         ')   " tab pages
call add(g:commands, 'tags         ')   " tag stack contents
call add(g:commands, 'undolist     ')   " leaves of the undo tree
call add(g:commands, 'version      ')   " list version and build options
call add(g:commands, 'winpos       ')   " Vim window position (gui)

" Add uppercase versions of above-mentioned redirecting into a new buffer
function! RedirAddUppercaseVersion() abort
    for command in g:commands
        let bufferName = command
        let bufferName = substitute(bufferName, '^verbose ', "", "g")
        let bufferName = substitute(bufferName , '\v\s*$', "", "g")
        let bufferName = substitute(bufferName, '\v(\w+)', '\u\1', 'g')
        let bufferName = substitute(bufferName , '\v\s*', "", "g")
        let bufferName = substitute(bufferName, '\v\W', "x", "g")
        try
            execute "command! -nargs=0 " . bufferName . " :Verbose :" . command
        catch
            echom "error creating command " . bufferName
        endtry
    endfor

endfunction
call RedirAddUppercaseVersion()

" Display all kinds of vim environment information
function! VimEnvironment() abort
    call BufferCreateTemp("VimEnv")
    for command in g:commands
        put='### ' . command . ' #############################'
        call RedirIntoCurrentBuffer(command)
        put=''
    endfor
    normal ggdd
    only
endfunction

command! -nargs=0 CommandLine call CommandLine()
function! CommandLine() abort
    silent execute ':e ' . g:vim.etc.dir . 'command-line.vim'
    normal Go:
    startinsert!

    " clear search register than execute line under cursor
    " nnoremap <silent> <buffer> <CR> :let @/ = "" \| :execute getline(".")<cr>

    nnoremap <silent> <buffer> <CR> :execute getline(".")<cr>
    inoremap <silent> <buffer> <CR> <esc> :execute getline(".")<cr>

    " nnoremap <silent> <buffer> o :normal Go: \| :startinsert!<cr>
endfunction

" Run line under cursor as vim script or shell command depending on leading :
function! RunCursorLine() abort
    let l:cmd = GetRunableCursorLine()
    call RunIntoBuffer(l:cmd)
endfunction
command! -nargs=0 RunCursorLine call RunCursorLine()
nnoremap <silent><leader>vl :RunCursorLine<cr>
nnoremap <silent><leader>vx :call MyHelpersSourceFile()<cr>

function! MyHelpersSourceFile() abort
  let b:winview = winsaveview()
  wall
  source %
  if exists('b:winview')
    call winrestview(b:winview)
  endif
endfunction

" Run current line as vim script
function! RunCursorLineVim() abort
    let l:cmd = GetRunableCursorLine()
    execute l:cmd
endfunction
nnoremap <silent><leader>ev :call RunCursorLineVim()<cr>
nnoremap <silent> <leader>ee :execute g:MyLastCommand<cr>

function! RunCursorLineVimVerbose() abort
    let l:cmd = GetRunableCursorLine()
    execute 'Verbose ' . l:cmd
endfunction
nnoremap <silent><leader>eV :call RunCursorLineVimVerbose()<cr>

function! GetRunableCursorLine() abort
    let l:cmd = getline(".")
    let l:cmd = substitute(l:cmd, '\v^["#/ ]+', "", "")
    " let l:cmd = substitute(l:cmd, '\v^', ":!", "")
    " let l:cmd = substitute(l:cmd, '\v^:!:', ":", "")
    return l:cmd
endfunction

function! EditFileInBufferDir(...) abort
  let l:dir = expand("%:h")
  let l:file = l:dir . '/' . join(a:000)
  let l:file = fnameescape(l:file)
  execute 'edit ' . l:file
endfunction
command! -nargs=* E call EditFileInBufferDir(<f-args>)

function! CdBufferDir() abort
    let l:dir = expand("%:p:h")
    execute 'cd' l:dir
endfunction

function! helpers#touch(path) abort
    if empty(a:path)
        throw "Specify non empty path to create"
    endif
    let l:path = fnamemodify(a:path, ':p')
    let l:dir = fnamemodify(a:path, ':p:h')
    call Mkdir(l:dir, 'p')
    if IsNeoVim()
      call writefile([], l:path, 'a')
    endif
endfunction

if $DEBUG
  silent execute '!echo "==========" > /tmp/vim.log'
endif

function! DEBUG(...) abort
  if $DEBUG
    silent execute '!echo -e "\nDEBUG> ' . join(a:000, ' ') . '\n" >> /tmp/vim.log'
  endif
endfunction

function! INFO(...) abort
  if $DEBUG
    silent execute '!echo -e "\nINFO > ' . join(a:000, ' ') . '\n" >> /tmp/vim.log'
  else
    unsilent echom "INFO > " . join(a:000, ' ')
  endif
endfunction

function! DUMP(input) abort
  Verbose echo _DUMP(a:input)
  silent! only
  normal ggdd
  setlocal filetype=json
  Neoformat
endfunction

" dump any vim structure to json
function! _DUMP(input) abort
    let json = ''
    if type(a:input) == type({})
        let parts = copy(a:input)
        call map(parts, '"\"" . escape(v:key, "\"") . "\":" . _DUMP(v:val)')
        let json .= "{" . join(values(parts), ",") . "}"
    elseif type(a:input) == type([])
        let parts = map(copy(a:input), '_DUMP(v:val)')
        let json .= "[" . join(parts, ",") . "]"
    elseif type(a:input) == 2
      " TODO: how to convert funcrefs to string?
    else
        let json .= '"'.escape(a:input, '"').'"'
    endif
    return json
endfunction

" Copy current buffer to a new file in the buffers directory
function! Copy(dst) abort
  silent execute 'saveas %:p:h/' . a:dst
endfunction
command! -nargs=* Copy call Copy(<f-args>)

" Vim's writefile does not support the append (a) flag (2017-02-21)
" Vim's mkdir complains if directory alread exists (2017-02-21)
function! IsNeoVim() abort
    redir => s
    silent! version
    redir END
    return matchstr(s, 'NVIM') == 'NVIM'
endfunction

" For vim compatibility 
" Vim complains if the directory already exists (2017-02-20)
function! Mkdir(dir, ...) abort
  if glob(a:dir) != ''
    return
  endif
  call mkdir(a:dir, 'p')
endfunction

" Normalize she whitespace in a string...
function! TrimWS (str)
    " Remove whitespace fore and aft...
    let trimmed = substitute(a:str, '^\s\+\|\s\+$', '', 'g')

    " Then condense internal whitespaces...
    return substitute(trimmed, '\s\+', ' ', 'g')
endfunction

" Reduce a range of lines to only the unique ones, preserving order...
function! Uniq (...) range
    " Ignore whitespace differences, if asked to...
    let ignore_ws_diffs = len(a:000)

    " Nothing unique seen yet...
    let seen = {}
    let uniq_lines = []

    " Walk through the lines, remembering only the hitherto unseen ones...
    for line in getline(a:firstline, a:lastline)
        let normalized_line = '>' . (ignore_ws_diffs ? TrimWS(line) : line)
        if !get(seen,normalized_line)
            call add(uniq_lines, line)
            let seen[normalized_line] = 1
        endif
    endfor

    " Replace the range of original lines with just the unique lines...
    exec a:firstline . ',' . a:lastline . 'delete'
    call append(a:firstline-1, uniq_lines)
endfunction

function! helpers#createUniqueSignId() abort
  let id = localtime()
  return id
endfunction

sign define BlinkLine linehl=Todo
function! helpers#blinkLine() abort
  let l:cursorline = &cursorline
  let l:count = 1
  let l:signId = helpers#createUniqueSignId()
  let i = 0
  while i <= l:count
    let i = i + 1
    set nocursorline
    execute 'sign place ' . l:signId . ' name=BlinkLine line='
          \ . line('.') . ' buffer=' . bufnr('%')
    set cursorline
    sleep 60m
    execute 'sign unplace ' . l:signId
    set nocursorline
    sleep 60m
  endwhile
  let &cursorline = l:cursorline
endfunction

" " OR ELSE just highlight the match in red...
" function! HLNext (blinktime)
"     let [bufnum, lnum, col, off] = getpos('.')
"     let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
"     let target_pat = '\c\%#\%('.@/.'\)'
"     let ring = matchadd('Todo', target_pat, 101)
"     redraw
"     exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
"     call matchdelete(ring)
"     redraw
" endfunction

let s:rnd = localtime() % 0x10000
function! helpers#random(n) abort
  let s:rnd = (s:rnd * 31421 + 6927) % 0x10000
  return s:rnd * a:n / 0x10000
endfunction

function! helpers#surroundings() abort
  return split(get(b:, 'commentary_format', substitute(substitute(
        \ &commentstring, '\S\zs%s',' %s','') ,'%s\ze\S', '%s ', '')), '%s', 1)
endfunction

" detect quickfix:
" https://www.reddit.com/r/vim/comments/5ulthc/how_would_i_detect_whether_quickfix_window_is_open/
function! GetQuickfixBufferNumber() abort
  for winnr in range(1, winnr('$'))
    let qflist = filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')
    if len(qflist) == 0
      return 0
    endif
    return qflist[0].bufnr
	endfor
endfunction

" " TODO:
" function! MyGetPreviewBufferNumber() abort
"   for winnr in range(1, winnr('$'))
"     let blist = filter(getwininfo(winnr), 'v:val.previewwindow')
"     if len(blist) == 0
"       return 0
"     endif
"     return blist[0].bufnr
" 	endfor
" endfunction

function! MyHelpersQuickfixIsOpen() abort
  return GetQuickfixBufferNumber() != 0
endfunction

function! GetLoclistBufferNumber() abort
  for winnr in range(1, winnr('$'))
    let qflist = filter(getwininfo(), 'v:val.quickfix && v:val.loclist')
    if len(qflist) == 0
      return 0
    endif
    return qflist[0].bufnr
	endfor
endfunction

function! BufferIsQuickfix(...) abort
  let bufnr = bufnr('%')
  if a:0 != 0
    let bufnr = a:1
  endif
  return bufnr == GetQuickfixBufferNumber()
endfunction

function! BufferIsLoclist(...) abort
  let bufnr = bufnr('%')
  if a:0 != 0
    let bufnr = a:1
  endif
  return bufnr == GetLoclistBufferNumber()
endfunction

function! MyHelpersBufferlist() abort
  let lastBuffer = bufnr('$')
  let currentBuffer = bufnr('%')
  let before = []
  let current = ''
  let after = []
  let found = 0
  let i = 0
  while i <= lastBuffer
    let i = i + 1
    if buflisted(i) != 1
      continue
    endif
    if BufferIsQuickfix(i)
      continue
    endif
    if BufferIsLoclist(i)
      continue
    endif
    let bufferName = bufname(i)
    if bufferName == ''
      let bufferName = '[No Name]'
    else
      let bufferName = fnamemodify(bufferName, ':p:t')
    endif
    if i == currentBuffer
      let current = bufferName
      let found = 1
      continue
    endif
    if found
      let after += [bufferName]
    else
      let before += [bufferName]
    endif
  endwhile
  return [ join(before, '  ') , current, join(after, '  ') ]
endfunction

" nmap <silent>L :bnext<cr>
" nmap <silent>H :bprev<cr>

nnoremap <silent> L :silent! call MyHelpersNextBuffer()<cr>
function! MyHelpersNextBuffer() abort
  let lastBuffer = bufnr('$')
  let currentBuffer = bufnr('%')
  let i = currentBuffer
  if MyBufferIsSpecial(currentBuffer)
    return
  endif
  pclose
  while i <= lastBuffer
    let i = i + 1
    if buflisted(i) != 1
      continue
    endif
    if MyBufferIsSpecial(i)
      continue
    endif
    execute 'buffer' i
    return
  endwhile
endfunction

nnoremap <silent> H :silent! call MyHelpersPreviousBuffer()<cr>
function! MyHelpersPreviousBuffer() abort
  let currentBuffer = bufnr('%')
  let i = currentBuffer
  if MyBufferIsSpecial(currentBuffer)
    return
  endif
  pclose
  while i > 0
    let i = i - 1
    if buflisted(i) != 1
      continue
    endif
    if MyBufferIsSpecial(i)
      continue
    endif
    execute 'buffer' i
    break
  endwhile
endfunction

function! MyBufferIsSpecial(bufnr) abort
  if BufferIsQuickfix(a:bufnr)
    return 1
  endif
  if BufferIsLoclist(a:bufnr)
    return 1
  endif
  if MyBufferIsVerySpecial(a:bufnr)
    return 1
  endif
  " if  MyBufferIsScratch(a:bufnr)
  "   return 1
  " endif
  return 0
endfunction

" Skip Mundo buffers etc
function! MyBufferIsVerySpecial(bufnr) abort
  return bufname(a:bufnr) =~ '\v^__.+__$'
endfunction

" function! MyBufferIsScratch(bufnr) abort
"   return bufname(a:bufnr) == ''
" endfunction

" TODO: remap
nnoremap <silent> <leader>O :call MyHelpersOpenOrg()<cr>
function! MyHelpersOpenOrg() abort
  let fileName = substitute(expand('%:p'), '/txt', '/org', 'g')
  let fileName = substitute(fileName, '\.txt', '', 'g')
  silent! execute '!see ' fileName ' &'
endfunction

function! MyInstall(app, ...) abort
  let cmd = join(a:000)
  if cmd == ''
    let cmd = '!npm install -g ' . a:app
  endif
  if !executable(a:app)
    call INFO('Installing ' . a:app . " via: " . cmd)
    silent execute cmd
  endif
endfunction
command! -nargs=* MyInstall call MyInstall (<f-args>)

" TODO: store and restore state of marks, registers
function! MyHelpersStoreState() abort
  " let save_cursor = getcurpos()
  " call setpos('.', save_cursor)

  " " or
  " let view = winsaveview()
  " call winrestview(view)<cr>
endfunction

" SEE ALSO: https://www.reddit.com/r/vim/comments/88h2wv/substitute_vims_and_with_b_when_you_invoke/dwl5rbg/
function! RegexToPcre(vim_regex) abort
    " Translate vim regular expression to perl regular expression (what grep
    " uses). Only a partial translation. See perl-patterns for more details.
    let search = a:vim_regex
    let search = substitute(search, '\C\\v', '', 'g')
    let was_verymagic = len(search) < len(a:vim_regex)

    let escape = '\\'
    let unescape = ''
    if was_verymagic
        " verymagic flips escaping rules
        let escape = ''
        let unescape = '\\'
    endif

    " Some funky scripting for notgrep_prg may not handle spaces (using xargs
    " to grep a list of files).
    if exists("g:notgrep_replace_space_with_dot") && g:notgrep_replace_space_with_dot
        let search = substitute(search,' ','.','g')
    endif

    " Don't let the shell get confused by quotes.
    let search = substitute(search,"[\"']",'.','g')

    " No easy support for disabling regex so ignore
    let search = substitute(search,'\\V','','g')
    " PCRE word boundaries
    let search = substitute(search,'\('. escape .'<\|'. escape .'>\)','\\b','g')

    " PCRE character classes
    let character_classes = {
                \ 's' : '[[:space:]]',
                \ 'S' : '[^ \\t]',
                \ 'd' : '[[:digit:]]',
                \ 'D' : '[^0-9]',
                \ 'x' : '[[:xdigit:]]',
                \ 'X' : '[^0-9A-Fa-f]',
                \ 'o' : '[0-7]',
                \ 'O' : '[^0-7]',
                \ 'w' : '[0-9A-Za-z_]',
                \ 'W' : '[^0-9A-Za-z_]',
                \ 'h' : '[A-Za-z_]',
                \ 'H' : '[^A-Za-z_]',
                \ 'a' : '[[:alpha:]]',
                \ 'A' : '[^A-Za-z]',
                \ 'l' : '[[:lower:]]',
                \ 'L' : '[^a-z]',
                \ 'u' : '[[:upper:]]',
                \ 'U' : '[^A-Z]',
                \ }
    for vim_class in keys(character_classes)
        " case is very important!
        let search = substitute(search, '\C\\'. vim_class .'\>', character_classes[vim_class], 'g')
    endfor

    if was_verymagic
        " Always need to escape pipe in shell
        let search = substitute(search, '|','\\|','g')
    else
        " PCRE operates a bit like verymagic, so remove some escaping

        " Dot regular unescaped parens
        let search = substitute(search, '\v(\\)@<![()]','.','g')
        " Remove escape from escaped capture parens
        let search = substitute(search, '\v\\([()])','\1','g')

        " Unescape some multis
        let search = substitute(search,'\v\\([+=?])','\1','g')
    endif
    return search
endfunction

command! -nargs=* Web call Web (<f-args>)
command! -nargs=* WebWithFiletype call Web (&filetype, <f-args>)
function! Web(...) abort
  let query = join(a:000, ' ')
  silent execute '!firefox https://duckduckgo.com/?q=' . shellescape(query)
endfunction
" SEE ALSO: https://github.com/kabbamine/zeavim.vim

" https://stackoverflow.com/a/1534347 
function! MyHelpersGetVisualSelection()
  try
    let a_save = @a
    normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction
