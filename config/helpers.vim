" Close a buffer writing its content and closing vim if appropriate.
" Use bwipe instead of bdelete - otherwise the buffer stays open as
" an unlisted-buffer.
function! BufferClose()

    if BufferIsCommandLine() == 1
        :q!
        return
    endif

    :lclose
    " :cclose

    if BufferIsEmpty() == 1
    elseif BufferIsUnnamed() == 1
    elseif &modified && &write
        :w
    endif

    if BufferIsLast() == 1
        if BufferIsEmpty() == 1
            :q!
        endif
        :silent bwipe!
        " :MyUniteMru
    else
        :silent bwipe!
    endif

endfunction

" argument: bufspec
function! CheckTime(...)

    let bufspec = ""
    if a:0 != 0
        let bufspec = a:1
    endif

    if BufferIsCommandLine()
        return
    endif

    execute ":checktime " . bufspec
endfunction

function! BufferIsCommandLine()
    if bufname("%") == '[Command Line]'
        return 1
    endif
    return 0
endfunction

function! BufferIsUnnamed()
    if empty(bufname("%"))
        return 1
    else
        return 2
    endif
endfunction

function! BufferIsEmpty()
    if line('$') == 1 && getline(1) == '' 
        return 1
    else
        return 0
    endif
endfunction

function! BufferCanWrite()
    return &write
endfunction

function! BufferIsLast()

    let last_buffer = bufnr('$')

    let listed = 0
    let i = 1
    while i <= last_buffer

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

nnoremap <silent> <ESC> :call BufferClose()<cr>

command! -nargs=1 BufferCreateTemp call BufferCreateTemp(<f-args>)
function! BufferCreateTemp(...)
    execute ":new /tmp/" . split(a:1, " ")[0]
    normal ggdG
    setlocal buftype=nowrite
endfunction

function! RedirNew(name, command)
    call BufferCreateTemp(a:name)
    silent execute ":Redir :" . a:command
endfunction
command! -nargs=+ RedirNew call RedirNew("<args>")

command! -nargs=+ Redir call Redir("<args>")
function! Redir(command)
    call RedirIntoCurrentBuffer(a:command)
    normal ggdddd
endfunction

function! RedirIntoCurrentBuffer(command)

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

command! -nargs=* Run silent! call RunIntoBuffer(<f-args>)
command! -nargs=* RunIntoBuffer call RunIntoBuffer(<f-args>)
function! RunIntoBuffer(...)

    let command = join(a:000)

    wall
    let buffer_name = a:1

    let buffer_name = substitute(buffer_name, '[^a-zA-Z_\-/\.]', "", "g")
    if buffer_name == ""
        let buffer_name = "cmd"
    endif
    let buffer_name = buffer_name . ".output"
    call BufferCreateTemp(buffer_name)

    echom "Running command: " . command
    execute ":r!run-and-capture " . command
    " execute ":r! " . command
    " %!html-strip
    " Remove broken linebreak
    %s/\r//ge

    " hack remove duplicate perl line number
    %s/\v,  line \d+//ge

    " Convert ansi colors
    " AnsiEsc
    " fix invisible ansi white
    " hi ansiWhite ctermfg=black
    setlocal filetype=txt

    normal ggddG
    set wrap
    " lgetbuffer
    " lwindow

    " set buftype=quickfix
    " :copen 999
    :only

    " autocmd BufEnter <buffer> :AnsiEsc!
    " autocmd BufEnter <buffer> hi ansiWhite ctermfg=black

endfunction

command! -nargs=0 RunIntoBufferCurrentBuffer call RunIntoBufferCurrentBuffer()
function! RunIntoBufferCurrentBuffer()
    call RunIntoBufferOrLastCommand("\"$(run-guess-command-by-filename " . expand("%:p"). ")\"")
endfunction

command! -nargs=* RunIntoBufferOrLastCommand call RunIntoBufferOrLastCommand()
function! RunIntoBufferOrLastCommand(...)

    if exists('a:1')
        let g:last_command = a:000
    endif

    call RunIntoBuffer(g:last_command)
endfunction

let g:ack_default_options = '--ignore-file "^\.*"'

command! -nargs=1 Tree call Tree("<args>")
function! Tree(path)

    new tree
    setlocal buftype=nowrite

    setlocal listchars=
    nnoremap <buffer> <CR> gf
    execute ":r! root=$(git-root) && cd $root && tree --no-colors --exclude '\class$' " . a:path
    normal gg

endfunction

let g:commands = []

call add(g:commands, 'verbose map<buffer>  ')   " buffer local Normal and Visual mode maps
call add(g:commands, 'verbose map!<buffer> ')   " buffer local Insert and Command-line mode maps

" ### There are six sets of mappings

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
function! RedirAddUppercaseVersion()

    for command in g:commands
        let bufferName = command
        let bufferName = substitute(bufferName, '^verbose ', "", "g")
        let bufferName = substitute(bufferName , '\v\s*$', "", "g")
        let bufferName = substitute(bufferName, '\v(\w+)', '\u\1', 'g')
        let bufferName = substitute(bufferName , '\v\s*', "", "g")
        let bufferName = substitute(bufferName, '\v\W', "x", "g")
        try
            execute "command! -nargs=0 " . bufferName. 
                \ " :call RedirNew(':" . bufferName . "', '" . command . "')"
        catch
            echom "error creating command " . bufferName
        endtry
    endfor

endfunction
call RedirAddUppercaseVersion()

" Display all kinds of vim environment information
command! -nargs=0 VimEnvironment call VimEnvironment()
function! VimEnvironment()

    call BufferCreateTemp("VimEnv")

    for command in g:commands
        put='### ' . command . ' #############################'
        silent call RedirIntoCurrentBuffer(command)
        put=''
    endfor

    normal ggdd

endfunction

" nmap ,, :CommandLine<cr>

command! -nargs=0 CommandLine call CommandLine()
function! CommandLine()
    silent execute ':e ' . g:vim.etc.dir . 'command-line.vim'
    normal Go:
    startinsert!

    " clear search register than execute line under cursor
    " nnoremap <silent> <buffer> <CR> :let @/ = "" \| :execute getline(".")<cr>

    nnoremap <silent> <buffer> <CR> :execute getline(".")<cr>
    inoremap <silent> <buffer> <CR> <esc> :execute getline(".")<cr>

    nnoremap <silent> <buffer> o :normal Go: \| :startinsert!<cr>
endfunction

command! -nargs=0 Notes call Notes()
function! Notes()

    silent execute ':e ' . g:vim.etc.dir . 'notes.vim'

    nohlsearch

    " nnoremap <buffer> j /\v^([^\s"])<cr>
    " nnoremap <buffer> k ?\v^([^\s"])<cr>

    " clear search register than execute line under cursor
    nnoremap <silent> <buffer> <CR> :let @/ = "" \| :execute getline(".")<cr>

endfunction

" Run line under cursor as vim script or shell command depending on leading :
command! -nargs=0 RunCursorLine call Redir(GetRunableCursorLine())
function! GetRunableCursorLine()

    let l:cmd = getline(".")
    let l:cmd = substitute(l:cmd, '\v^["# ]+', "!", "")
    let l:cmd = substitute(l:cmd, '\v^!:', ":", "")

    return l:cmd

endfunction
