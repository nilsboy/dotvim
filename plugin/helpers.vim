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

command! -nargs=0 WindowCloseOthers call WindowCloseOthers()
function! WindowCloseOthers(...)

    " Save current window number to revert.
    let save_winnr = winnr()
    echo save_winnr

    let nwin = 1
    while 1

        let nbuf = winbufnr(nwin)

        " After all window processed, finish.
        if nbuf == -1
          break
        endif

        " Close window if its buftype is help.  If not help, go to next window.
        if nbuf != save_winnr

            " Correct saved window number if younger window will be closed.
            if save_winnr > nbuf
                let save_winnr = save_winnr - 1
            endif

            execute nwin.'wincmd w'

            " If there is only one help window, quit.
            if nwin == 1 && winbufnr(2) == -1
                quit!
            else
                close!
            endif
        else
            let nwin = nwin + 1
        endif

    endwhile

  " Revert selected window.
  execute save_winnr.'wincmd w'

endfunction

command! -nargs=0 Messages :Redir :messages
command! -nargs=0 Scriptnames :Redir :scriptnames

command! -nargs=1 Redir call Redir("<args>")
function! Redir(command)
    call BufferCreateTemp()
    call RedirIntoCurrentBuffer(a:command)
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

" command! -nargs=1 GB call GrepFile("<cfile>", "<args>")
function! GrepBuffer(path, ...)

    call BufferCreateTemp()

    execute ":r!cd " . a:path . " && find-or-grep " . join(a:000, " ")
    normal ggdd
    nnoremap <buffer> <CR> gf

endfunction

command! -nargs=1 G call Grep("~/src", "<args>")
function! Grep(path, ...)

    call BufferCreateTemp()

    " execute ":r!cd " . a:path . " && find-or-grep " . join(a:000, " ")
    execute ":r!cd / && find-or-grep " . join(a:000, " ")
    normal ggdd
    nnoremap <buffer> <CR> gf

endfunction

command! -nargs=1 F call Find("~/src", "<args>")
function! Find(path, ...)

    call BufferCreateTemp()

    execute ":r!cd " . a:path . " && find-and " . join(a:000, " ")
    normal ggdd
    nnoremap <buffer> <CR> gf

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

    silent execute "grep! -R " . shellescape(@@) . " ~/src/"
    copen

    let @@ = saved_unnamed_register
endfunction

" Display all kinds of vim information in a new buffer
command! -nargs=0 VimEnvironment call VimEnvironment()
function! VimEnvironment()

    call BufferCreateTemp()

    let commands = []

    call add(commands, ':abbreviate   ')   " list abbreviations
    call add(commands, ':args         ')   " argument list
    call add(commands, ':augroup      ')   " augroups
    call add(commands, ':autocmd      ')   " list auto-commands
    call add(commands, ':buffers      ')   " list buffers
    call add(commands, ':breaklist    ')   " list current breakpoints
    call add(commands, ':cabbrev      ')   " list command mode abbreviations
    call add(commands, ':changes      ')   " changes
    call add(commands, ':cmap         ')   " list command mode maps
    call add(commands, ':command      ')   " list commands
    call add(commands, ':compiler     ')   " list compiler scripts
    call add(commands, ':digraphs     ')   " digraphs
    call add(commands, ':file         ')   " print filename, cursor position and status (like Ctrl-G)
    call add(commands, ':filetype     ')   " on/off settings for filetype detect/plugins/indent
    call add(commands, ':function     ')   " list user-defined functions (names and argument lists but not the full code)
    call add(commands, ':highlight    ')   " highlight groups
    call add(commands, ':history c    ')   " command history
    call add(commands, ':history =    ')   " expression history
    call add(commands, ':history s    ')   " search history
    call add(commands, ':history      ')   " your commands
    call add(commands, ':iabbrev      ')   " list insert mode abbreviations
    call add(commands, ':imap         ')   " list insert mode maps
    call add(commands, ':intro        ')   " the Vim splash screen, with summary version info
    call add(commands, ':jumps        ')   " your movements
    call add(commands, ':language     ')   " current language settings
    call add(commands, ':let          ')   " all variables
    call add(commands, ':let g:       ')   " global variables
    call add(commands, ':let v:       ')   " Vim variables
    call add(commands, ':list         ')   " buffer lines (many similar commands)
    call add(commands, ':lmap         ')   " language mappings (set by keymap or by lmap)
    call add(commands, ':ls           ')   " buffers
    call add(commands, ':ls!          ')   " buffers, including unlisted buffers
    call add(commands, ':map!         ')   " Insert and Command-line mode maps (imap, cmap)
    call add(commands, ':map          ')   " Normal and Visual mode maps (nmap, vmap, xmap, smap, omap)
    call add(commands, ':map<buffer>  ')   " buffer local Normal and Visual mode maps
    call add(commands, ':map!<buffer> ')   " buffer local Insert and Command-line mode maps
    call add(commands, ':marks        ')   " marks
    call add(commands, ':menu         ')   " menu items
    call add(commands, ':messages     ')   " message history
    call add(commands, ':nmap         ')   " Normal-mode mappings only
    call add(commands, ':omap         ')   " Operator-pending mode mappings only
    call add(commands, ':print        ')   " display buffer lines (useful after :g or with a range)
    call add(commands, ':reg          ')   " registers
    call add(commands, ':scriptnames  ')   " all scripts sourced so far
    call add(commands, ':set all      ')   " all options, including defaults
    call add(commands, ':setglobal    ')   " global option values
    call add(commands, ':setlocal     ')   " local option values
    call add(commands, ':set          ')   " options with non-default value
    call add(commands, ':set termcap  ')   " list terminal codes and terminal keys
    call add(commands, ':smap         ')   " Select-mode mappings only
    call add(commands, ':spellinfo    ')   " spellfiles used
    call add(commands, ':syntax       ')   " syntax items
    call add(commands, ':syn sync     ')   " current syntax sync mode
    call add(commands, ':tabs         ')   " tab pages
    call add(commands, ':tags         ')   " tag stack contents
    call add(commands, ':undolist     ')   " leaves of the undo tree
    call add(commands, ':verbose      ')   " show info about where a map or autocmd or function is defined
    call add(commands, ':version      ')   " list version and build options
    call add(commands, ':vmap         ')   " Visual and Select mode mappings only
    call add(commands, ':winpos       ')   " Vim window position (gui)
    call add(commands, ':xmap         ')   " visual mode maps only

    for command in commands
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

    nnoremap <silent> <buffer> <CR> :execute getline(".")<cr>
    nnoremap <buffer> j /\v^([^\s"])<cr>
    nnoremap <buffer> k ?\v^([^\s"])<cr>

endfunction
