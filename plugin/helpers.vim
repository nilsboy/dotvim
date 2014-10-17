" Close a buffer writing its content and closing vim if appropriate.
function! BufferClose()

    if BufferIsEmpty() == 1
    elseif BufferIsUnnamed() == 1
    elseif &modified && &write
        :w
    endif

    if BufferIsLast() == 1
        :q!
    else
        :bdelete!
    endif

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

function! BufferCreateTemp()

    execute ":e " . tempname()
    setlocal buftype=nowrite
    normal ggdd

endfunction

command! -nargs=+ Redir call Redir("<args>")
function! Redir(command)
    echom a:command
    call BufferCreateTemp()
    call RedirIntoCurrentBuffer(a:command)
    normal ggdddd
endfunction

function! RedirIntoCurrentBuffer(command)

    let output = ""

    " Redirect output to a variable.
    redir => output

    " Execute the specified command
    try
        silent execute a:command
    catch
        put='command failed'
    finally
        " Turn off redirection.
        redir END

        " Place the output in the destination buffer.
        silent put=output
    endtry

endfunction

command! -nargs=0 RunIntoBuffer call RunIntoBuffer()
function! RunIntoBuffer()

    write
    let l:file = expand("%:p")

    call BufferCreateTemp()

    silent execute ":r!run-and-capture " . l:file
    normal <cr>
    normal ggdd
    AnsiEsc
    cbuffer
    set buftype=quickfix
    " :copen 999

endfunction

command! -nargs=1 Grep call Grep("~/src", "<args>")
function! Grep(path, ...)
    silent execute ':LAck "' . join(a:000, " ") . '" ' . a:path
endfunction

command! -nargs=+ GrepFile call GrepFile("<args>")
function! GrepFile(...)
    silent execute ':LAck "' . join(a:000, " ") . '" ' . expand("%")
endfunction

command! -nargs=+ FFF call Find("~/src/bin", "<args>")
function! Find(path, grep_args)

    let grepprg_bak = &grepprg
    let grepformat_bak = &grepformat

    let &grepprg="abs=1 find-and"
    let &grepformat="%f"

    try
        silent execute "cd " . a:path
        silent execute "lgrep! " . a:grep_args
    catch
    finally
        let &grepprg=grepprg_bak
        let &grepformat=grepformat_bak
    endtry

    lopen

endfunction

command! -nargs=1 Tree call Tree("<args>")
function! Tree(path)

    call BufferCreateTemp()

    setlocal listchars=
    nnoremap <buffer> <CR> gf
    execute ":r!tree --no-colors --exclude '\class$' " . a:path
    normal gg

endfunction

nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    " silent execute "grep! -R " . shellescape(@@) . " ~/src/"
    " copen 999
    " silent execute ':LAck "' . join(a:000, " ") . '"<cr>'
    execute ':LAck! "' . @@ . '" ~/src/'

    let @@ = saved_unnamed_register
endfunction

let g:commands = []

call add(g:commands, 'abbreviate   ')   " list abbreviations
call add(g:commands, 'args         ')   " argument list
call add(g:commands, 'augroup      ')   " augroups
call add(g:commands, 'autocmd      ')   " list auto-commands
call add(g:commands, 'buffers      ')   " list buffers
call add(g:commands, 'breaklist    ')   " list current breakpoints
call add(g:commands, 'cabbrev      ')   " list command mode abbreviations
call add(g:commands, 'changes      ')   " changes
call add(g:commands, 'cmap         ')   " list command mode maps
call add(g:commands, 'command      ')   " list commands
call add(g:commands, 'compiler     ')   " list compiler scripts
call add(g:commands, 'digraphs     ')   " digraphs
call add(g:commands, 'file         ')   " print filename, cursor position and status (like Ctrl-G)
call add(g:commands, 'filetype     ')   " on/off settings for filetype detect/plugins/indent
call add(g:commands, 'function     ')   " list user-defined functions (names and argument lists but not the full code)
call add(g:commands, 'highlight    ')   " highlight groups
call add(g:commands, 'history c    ')   " command history
call add(g:commands, 'history =    ')   " expression history
call add(g:commands, 'history s    ')   " search history
call add(g:commands, 'history      ')   " your commands
call add(g:commands, 'iabbrev      ')   " list insert mode abbreviations
call add(g:commands, 'imap         ')   " list insert mode maps
call add(g:commands, 'intro        ')   " the Vim splash screen, with summary version info
call add(g:commands, 'jumps        ')   " your movements
call add(g:commands, 'language     ')   " current language settings
call add(g:commands, 'let          ')   " all variables
call add(g:commands, 'let g:       ')   " global variables
call add(g:commands, 'let v:       ')   " Vim variables
call add(g:commands, 'list         ')   " buffer lines (many similar commands)
call add(g:commands, 'lmap         ')   " language mappings (set by keymap or by lmap)
call add(g:commands, 'ls           ')   " buffers
call add(g:commands, 'ls!          ')   " buffers, including unlisted buffers
call add(g:commands, 'map!         ')   " Insert and Command-line mode maps (imap, cmap)
call add(g:commands, 'map          ')   " Normal and Visual mode maps (nmap, vmap, xmap, smap, omap)
call add(g:commands, 'map<buffer>  ')   " buffer local Normal and Visual mode maps
call add(g:commands, 'map!<buffer> ')   " buffer local Insert and Command-line mode maps
call add(g:commands, 'marks        ')   " marks
call add(g:commands, 'menu         ')   " menu items
call add(g:commands, 'messages     ')   " message history
call add(g:commands, 'nmap         ')   " Normal-mode mappings only
call add(g:commands, 'omap         ')   " Operator-pending mode mappings only
call add(g:commands, 'print        ')   " display buffer lines (useful after :g or with a range)
call add(g:commands, 'reg          ')   " registers
call add(g:commands, 'scriptnames  ')   " all scripts sourced so far
call add(g:commands, 'set all      ')   " all options, including defaults
call add(g:commands, 'setglobal    ')   " global option values
call add(g:commands, 'setlocal     ')   " local option values
call add(g:commands, 'set          ')   " options with non-default value
call add(g:commands, 'set termcap  ')   " list terminal codes and terminal keys
call add(g:commands, 'smap         ')   " Select-mode mappings only
call add(g:commands, 'spellinfo    ')   " spellfiles used
call add(g:commands, 'syntax       ')   " syntax items
call add(g:commands, 'syn sync     ')   " current syntax sync mode
call add(g:commands, 'tabs         ')   " tab pages
call add(g:commands, 'tags         ')   " tag stack contents
call add(g:commands, 'undolist     ')   " leaves of the undo tree
call add(g:commands, 'verbose      ')   " show info about where a map or autocmd or function is defined
call add(g:commands, 'version      ')   " list version and build options
call add(g:commands, 'vmap         ')   " Visual and Select mode mappings only
call add(g:commands, 'winpos       ')   " Vim window position (gui)
call add(g:commands, 'xmap         ')   " visual mode maps only

" Add uppercase versions of above-mentioned redirecting into a new buffer
function! RedirAddUppercaseVersion()

    for command in g:commands
        let command = substitute(command, '\v\s.*', "", "g")
        let command = substitute(command, '\v\W.*', "", "g")
        let uppercase_command = substitute(command, '\v(\w+)', '\u\1', '')
        try
            silent execute "command! -nargs=0 " . uppercase_command . " :Redir :" . command
        catch
        endtry
    endfor

endfunction
call RedirAddUppercaseVersion()

" Display all kinds of vim environment information
command! -nargs=0 VimEnvironment call VimEnvironment()
function! VimEnvironment()

    call BufferCreateTemp()

    for command in g:commands
        put='### ' . command . ' #############################'
        call RedirIntoCurrentBuffer(command)
        put=''
    endfor

    normal ggdd

endfunction

command! -nargs=0 Notes call Notes()
function! Notes()

    silent execute ':e ' . g:MY_VIM . 'notes.vim'

    nohlsearch

    nnoremap <buffer> j /\v^([^\s"])<cr>
    nnoremap <buffer> k ?\v^([^\s"])<cr>

    " clear search register than execute line under cursor
    nnoremap <silent> <buffer> <CR> :let @/ = "" \| :RunCursorLine<cr>

endfunction

" Run line under cursor as vim script or shell command depending on leading :
command! -nargs=0 RunCursorLine call Redir(GetRunableCursorLine())
function! GetRunableCursorLine()

    let l:cmd = getline(".")
    let l:cmd = substitute(l:cmd, '\v^["# ]+', "!", "")
    let l:cmd = substitute(l:cmd, '\v^!:', ":", "")

    return l:cmd

endfunction
