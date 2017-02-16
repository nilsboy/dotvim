" VimL Helper Libraries
" - l9.vim
" - https://github.com/LucHermitte/lh-vim-lib
" - tomtom/tlib_vim
" - ingo-library

" Close a buffer writing its content and closing vim if appropriate.
" Use bwipe instead of bdelete - otherwise the buffer stays open as
" an unlisted-buffer.
" Using bwipe prevents the current postion mark from being saved - so the file
" position can not be restored when loading the file again
function! BufferClose() abort

    if BufferIsCommandLine() == 1
        :q!
        return
    endif

    " :lclose
    " :cclose

    if BufferIsLast() == 1
        if BufferIsEmpty() == 1
            :q!
        endif
    endif

    if BufferIsEmpty() == 1
    elseif BufferIsUnnamed() == 1
    elseif &write
        update
    endif

    bdelete!

endfunction

" argument: bufspec
function! CheckTime(...) abort

    let bufspec = ""
    if a:0 != 0
        let bufspec = a:1
    endif

    if BufferIsCommandLine()
        return
    endif

    execute ":checktime " . bufspec
endfunction

function! BufferIsCommandLine() abort
    if bufname("%") == '[Command Line]'
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

function! BufferFindByFiletype() abort

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

function! BufferFindByName(name) abort
    let last_buffer = bufnr('$')
    let i = 1
    while i <= last_buffer
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
    let l:last_buffer = bufnr('$')
    let l:i = bufnr(a:current)
    while l:i * a:direction <= last_buffer
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
    echom buffer_name
    silent execute ":e " . buffer_name
    setlocal buftype=nowrite
    silent execute ":r! " . command
endfunction

" Checkout: https://github.com/thinca/vim-quickrun
command! -nargs=* RunIntoBuffer call RunIntoBuffer(<f-args>)
function! RunIntoBuffer(...) abort

    wall

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

command! -nargs=0 RunIntoBufferCurrentBuffer call RunIntoBufferCurrentBuffer()
function! RunIntoBufferCurrentBuffer() abort
    call RunIntoBufferOrLastCommand("\"$(run-guess-command-by-filename " . expand("%:p"). ")\"")
endfunction

command! -nargs=* RunIntoBufferOrLastCommand call RunIntoBufferOrLastCommand()
function! RunIntoBufferOrLastCommand(...) abort

    if exists('a:1')
        let g:last_command = a:000
    endif

    call RunIntoBuffer(g:last_command)
endfunction

let g:ack_default_options = '--ignore-file "^\.*"'

command! -nargs=1 Tree call Tree("<args>")
function! Tree(path) abort

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
            execute "command! -nargs=0 " . bufferName. 
                \ " :call RedirNew(':" . bufferName . "', '" . command . "')"
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

" Run current buffer
command! -nargs=0 RunCurrentBuffer call RunCurrentBuffer()
function! RunCurrentBuffer() abort
    call RunIntoBuffer(expand("%:p"))
endfunction

" Run line under cursor as vim script or shell command depending on leading :
command! -nargs=0 RunCursorLine call RunCursorLine()
function! RunCursorLine() abort
    let l:cmd = GetRunableCursorLine()
    call RunIntoBuffer(l:cmd)
endfunction

" Run current line as vim script
nnoremap <silent><leader>ev :call RunCursorLineVim()<cr>
nnoremap <silent><leader>eV :call RunCursorLineVimVerbose()<cr>
function! RunCursorLineVim() abort
    let l:cmd = GetRunableCursorLine()
    execute l:cmd
endfunction

function! RunCursorLineVimVerbose() abort
    let l:cmd = GetRunableCursorLine()
    execute 'Verbose ' . l:cmd
endfunction

function! GetRunableCursorLine() abort
    let l:cmd = getline(".")
    let l:cmd = substitute(l:cmd, '\v^["#/ ]+', "", "")
    " let l:cmd = substitute(l:cmd, '\v^', ":!", "")
    " let l:cmd = substitute(l:cmd, '\v^:!:', ":", "")
    return l:cmd
endfunction

command! -nargs=* E call EditFileInBufferDir(<f-args>)
function! EditFileInBufferDir(...) abort
  let l:dir = expand("%:h")
  let l:file = l:dir . '/' . join(a:000)
  let l:file = fnameescape(l:file)
  execute 'edit ' . l:file
endfunction

function! CdProjectRoot() abort

    " " see vim-rooter
    " let l:dir = FindRootDirectory()
    " if empty(l:dir)
    "     let l:dir = expand("%:p:h")
    " endif

    let l:dir = expand("%:p:h")
    execute 'cd' l:dir
    let l:project_dir = system("git-root")
    execute 'cd' l:project_dir
endfunction

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
    call mkdir(l:dir, 'p')
    call writefile([], l:path, 'a')
endfunction

command! -nargs=* Help call Help(<f-args>)
function! Help(...) abort
  execute "help " a:1
  silent only
  set buflisted
endfunction

function! DEBUG(...) abort
  unsilent echom "DEBUG> " . join(a:000, ' ')
endfunction

function! INFO(...) abort
  unsilent echom "INFO> " . join(a:000, ' ')
endfunction

function! DUMP(input) abort
  Verbose echo _DUMP(a:input)
  only
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
command! -nargs=* Copy call Copy(<f-args>)
function! Copy(dst) abort
  silent execute 'saveas %:p:h/' . a:dst
endfunction
