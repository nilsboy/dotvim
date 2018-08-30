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
  let lastBuffer = bufnr('$')
  let i = bufnr(a:current)
  while i * a:direction <= lastBuffer
    let name = bufname(i)

    if name == a:current
      let i = i + a:direction
      continue
    endif

    if name =~ fnameescape(a:name)
      return i
    endif

    let i = i + a:direction
  endwhile
  return 0
endfunction

function! BufferSwitchToNextByName(name) abort
  let unite_buffer = BufferFindNextByName(a:name, expand('%'))
  if unite_buffer == 0
    echo "No next " . a:name . " buffer found."
    return
  endif
  execute ":buffer " . unite_buffer
endfunction

function! BufferSwitchToPreviousByName(name) abort
  let unite_buffer = BufferFindPreviousByName(a:name, expand('%'))
  if unite_buffer == 0
    echo "No previous " . a:name . " buffer found."
    return
  endif
  execute ":buffer " . unite_buffer
endfunction

let g:MyHelpersLastVimCommand = 'echo "Specify vim command."'
function! MyHelpersRunVim(cmd)
  let cmd = a:cmd
  let cmd = substitute(cmd, '\v^["#/ ]+', "", "")
  let g:MyHelpersLastVimCommand = cmd
  wall
  let b:winview = winsaveview()
  Verbose execute cmd
endfunction
nnoremap <silent> <leader>vef :call MyHelpersRunVim('source ' . expand('%:p'))<cr>
nnoremap <silent> <leader>vel :call MyHelpersRunVim(getline("."))<cr>
nnoremap <silent> <leader>vee :call MyHelpersRunVim(g:MyHelpersLastVimCommand)<cr>

" augroup MyZ0MyMappingsAugroup
"   autocmd!
"   autocmd CursorHold * silent! :call MyHelpersRunVim('jumps')
" augroup END

function! EditFileInBufferDir(...) abort
  let dir = expand("%:h")
  let file = dir . '/' . join(a:000)
  let file = fnameescape(file)
  execute 'edit ' . file
endfunction
command! -nargs=* E call EditFileInBufferDir(<f-args>)

function! helpers#touch(path) abort
  if empty(a:path)
    throw "Specify non empty path to create"
  endif
  let path = fnamemodify(a:path, ':p')
  let dir = fnamemodify(a:path, ':p:h')
  call Mkdir(dir, 'p')
  if IsNeoVim()
    call writefile([], path, 'a')
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

" Normalize whitespace in a string...
function! TrimWS(str)
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
  let cursorline = &cursorline
  let count = 1
  let signId = helpers#createUniqueSignId()
  let i = 0
  while i <= count
    let i = i + 1
    set nocursorline
    execute 'sign place ' . signId . ' name=BlinkLine line='
          \ . line('.') . ' buffer=' . bufnr('%')
    set cursorline
    sleep 60m
    execute 'sign unplace ' . signId
    set nocursorline
    sleep 60m
  endwhile
  let &cursorline = cursorline
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

function! helpers#random(n) abort
  let rnd = localtime() % 0x10000
  let rnd = (rnd * 31421 + 6927) % 0x10000
  return rnd * a:n / 0x10000
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
"   endfor
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
        \ 's' : ' ',
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
    " TODO:
    " let search = substitute(search, '|','\\|','g')
  else
    " PCRE operates a bit like verymagic, so remove some escaping

    " Dot regular unescaped parens
    let search = substitute(search, '\v(\\)@<![()]','.','g')
    " Remove escape from escaped capture parens
    let search = substitute(search, '\v\\([()])','\1','g')

    " Unescape some multis
    let search = substitute(search,'\v\\([+=?])','\1','g')
  endif

  " Translate vim sequences: \%[]
  let sequences = []
  call substitute(search, '\v\\\%\[([^\]]+)\]', '\=add(sequences, submatch(0))', 'g')
  for sequence in sequences
    let pcre = sequence[3:-2]
    let sequenceList = []
    let word = ''
    for char in split(pcre, '\zs')
      let word .= char
      call add(sequenceList, word)
    endfor
    let pcre = '(' . join(reverse(sequenceList), '|') . ')'
    let search = substitute(search, '\V' . escape(sequence, '\\'), pcre, '')
  endfor

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

function! MyHelpersShortenPath(str, max) abort
  let str = a:str
  let max = a:max
  let parts = split(str, "/")
  let partMax = max / len(parts)
  let newParts = []
  for part in parts
    if len(str) <= max
      call add(newParts, part)
      continue
    endif
    let length = len(part)
    if length > partMax
      let half = (partMax / 2) - 2
      let part = part[0 : half] . '...' . part[length - half : length]
    endif
    call add(newParts, part)
  endfor
  let newStr = join(newParts, '/')
  if len(newStr) < max
    let newStr = printf('%-' . max . 's', newStr)
  endif
  return newStr
endfunction
