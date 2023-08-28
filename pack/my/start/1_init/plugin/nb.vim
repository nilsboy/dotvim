" VimL Helper Libraries
" - l9.vim
" - https://github.com/LucHermitte/lh-vim-lib
" - tomtom/tlib_vim
" - ingo-library

if exists("g:MyHelpersPluginLoaded")
    finish
endif
let g:MyHelpersPluginLoaded = 1

function! nb#mktemp(suffix) abort
  let tempname = tempname() . "/" . a:suffix . "/"
  call mkdir(tempname, "p", 0700)
  return tempname
endfunction

function! nb#mktempSimple(suffix, fileName) abort
  wall
  let tempname = fnamemodify(tempname(), ':p:h') . "/" . a:suffix . "/"
  call mkdir(tempname, "p", 0700)
  let fileName = tempname . a:fileName
  if filereadable(fileName)
    silent! execute "bd " . fileName
    silent! call delete(fileName)
  endif
  return fileName
endfunction

function! BufferListedCount() abort
  let lastBuffer = bufnr('$')
  let listed = 0
  let i = 0
  while i <= lastBuffer
    let i = i + 1
    if nb#buffer#isSpecial() == 1
      continue
    endif
    if buflisted(i) == 1
      let listed = listed + 1
    endif
  endwhile
  return listed
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
  execute 'Redir ' . cmd
endfunction
nnoremap <silent> <leader>vef :call MyHelpersRunVim('source ' . expand('%:p'))<cr>
nnoremap <silent> <leader>vel :call MyHelpersRunVim(getline("."))<cr>
nnoremap <silent> <leader>vee :call MyHelpersRunVim(g:MyHelpersLastVimCommand)<cr>

" augroup MyZ0MyMappingsAugroup
"   autocmd!
"   autocmd CursorHold * silent! :call MyHelpersRunVim('jumps')
" augroup END

function! nb#touch(path) abort
  if empty(a:path)
    throw "Specify non empty path to create"
  endif
  let path = fnamemodify(a:path, ':p')
  let dir = fnamemodify(a:path, ':p:h')
  call nb#mkdir(dir, 'p')
  if nb#isNeovim()
    call writefile([], path, 'a')
  endif
endfunction

let g:nb#logfile = nb#mktemp("vim") . "log"
nnoremap <silent> <leader>vm :call nb#viewLogfile()<cr><cr>
function! nb#viewLogfile() abort
  call writefile(["=== Log messages until " .  strftime("%H:%M:%S") . ' ======================='], g:nb#logfile, 'a') 
 execute 'edit ' . g:nb#logfile
 keepjumps normal G
endfunction

let g:nb#runlogfile = nb#mktemp("vim") . "runlog"
let &makeef = g:nb#runlogfile

nnoremap <silent> <leader>vr :call nb#viewRunLogfile()<cr><cr>
function! nb#viewRunLogfile() abort
  execute 'edit ' . g:nb#runlogfile
  setlocal nowrap
  keepjumps normal G
endfunction

function! nb#debug(msg) abort
  call writefile(["DEBUG> " . a:msg], g:nb#logfile, 'a') 
endfunction

function! nb#info(msg) abort
  call writefile(["INFO > " . a:msg], g:nb#logfile, 'a') 
  echohl MoreMsg | unsilent echom a:msg | echohl None
endfunction

function! nb#warn(msg) abort
  call writefile(["WARN > " . a:msg], g:nb#logfile, 'a') 
  echohl WarningMsg | unsilent echom a:msg | echohl None
endfunction

function! nb#error(msg) abort
  call writefile(["WARN > " . a:msg], g:nb#logfile, 'a') 
  echohl ErrorMsg | unsilent echom a:msg | echohl None
endfunction

function! DUMP(input) abort
  execute 'edit ' . tempname() . '.json'
  keepjumps put =json_encode(a:input)
  silent! only
  call MakeWith({'compiler': 'prettier-json', 'loclist': 1})
  keepjumps normal! gg
endfunction

" " example usage: :call DUMP('g:')
" function! DUMP(input) abort
"   execute 'edit ' . tempname() . '.txt'
"   execute '1PP ' . a:input
"   silent! only
"   keepjumps normal! gg
" endfunction

function! nb#isNeovim() abort
  return has("nvim")
endfunction

" For vim compatibility
" Vim complains if the directory already exists (2017-02-20)
function! nb#mkdir(dir, ...) abort
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
function! Uniq(...) range
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

function! nb#createUniqueSignId() abort
  let id = localtime()
  return id
endfunction

sign define BlinkLine linehl=Todo texthl=Todo
" NOTE: does not work anymore!?!
" cursorline can not be used twice inside a single function!?!
function! nb#blinkLine() abort
  let count = 10
  let signId = nb#createUniqueSignId()
  let i = 0
  while i <= count
    let i = i + 1
    execute 'sign place ' . signId . ' name=BlinkLine line='
          \ . line('.') . ' buffer=' . bufnr('%')
    set cursorline!
    sleep 600m
    execute 'sign unplace ' . signId
    set cursorline!
    sleep 600m
  endwhile
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

function! nb#random(n) abort
  let rnd = localtime() % 0x10000
  let rnd = (rnd * 31421 + 6927) % 0x10000
  return rnd * a:n / 0x10000
endfunction

function! nb#surroundings() abort
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

function! MyHelpersLoclistIsOpen() abort
  return GetLoclistBufferNumber() != 0
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

" nnoremap <silent> L :silent! call MyHelpersNextBuffer()<cr>
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

" nnoremap <silent> H :silent! call MyHelpersPreviousBuffer()<cr>
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
  if &previewwindow == 1
    return 1
  endif
  return 0
endfunction

" Skip Mundo buffers etc
function! MyBufferIsVerySpecial(bufnr) abort
  return bufname(a:bufnr) =~ '\v^__.+__$'
endfunction

" TODO: remap
" nnoremap <silent> <leader>O :call MyHelpersOpenOrg()<cr>
function! MyHelpersOpenOrg() abort
  let fileName = substitute(expand('%:p'), '/txt/', '/pdf/', 'g')
  let fileName = substitute(fileName, '\.txt', '', 'g')
  call nb#debug("Opening " . fileName . " ...")
  silent! execute '!see ' fileName ' &'
endfunction
command! -nargs=* MyOriginal call MyHelpersOpenOrg(<f-args>)

" TODO:
" let nb#triedToInstall = {}
function! nb#install(app, ...) abort
  let cmd = join(a:000)
  if cmd == ''
    let cmd = 'npm install -g ' . a:app
  endif
  if executable(a:app)
    return
  endif
  call nb#info('Installing ' . a:app . ' via: "' . cmd . '"...')
  echo system(cmd)
  echo 
endfunction
command! -nargs=* MyInstall call nb#install(<f-args>)

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

function! nb#shortenPath(str, max) abort
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

let g:my_debug_id = 0
function! DebugId() abort
  let g:my_debug_id = g:my_debug_id + 1
  return g:my_debug_id
endfunction

function! LastDebugId() abort
  return g:my_debug_id
endfunction

command! -nargs=* RemoveTrailingSpaces :silent %s/\s\+$//e
command! -nargs=* RemoveNewlineBlocks
      \ :silent %s/\v\s*\n(\s*\n)+/\r\r/eg
      \ | :silent %s/\n*\%$//eg

function! MyZ0MyrcEnv() abort
  setlocal filetype=vim
  setlocal nowrap
  Redirv verbose command
  RedirAppendv verbose autocmd
  RedirAppendv verbose messages
  RedirAppendv verbose set
  RedirAppendv verbose let
  RedirAppendv verbose function
  keepjumps normal! gg0
  let b:outline = '^### '
endfunction
nnoremap <silent> <leader>vE :call MyZ0MyrcEnv()<cr>

function! Map(...) abort
  let search = join(a:000)
  execute 'Redir       verbose map'
  execute 'RedirAppend verbose map!'
  silent! keeppatterns %s/\v\n\s*(last set from)/xxx \1/ig 
  silent! g/\v<plug>/d
  silent! keepjumps g/no mapping found/ normal! "_dd
  silent! keepjumps g/^$/ normal! "_dd
  silent sort u /\v^\w+/
  silent! keepjumps keeppatterns %s/\v(.+)xxx (last set from) (.+) line (\d+)/\3:\4:1:\1/ig 
  " example /home/...:s  <C-H>       * <C-G>"_c
  silent! execute 'v/\c^\S\+:\S\+\s\+\S*' . search . '.*\*/d'
  set errorformat&
  silent cgetbuffer
  bwipe
  call setqflist([], 'a', { 'title' : 'Mappings for ' . search })
  copen
endfunction
command! -nargs=* Map call Map (<f-args>)

function! nb#findScriptId(path) abort
  let scripts = filter(split(execute('scriptnames'), "\n"), 'v:val =~ "' . a:path . '"')
  if len(scripts) > 1
    throw 'Too many matches.'
  endif
  let sid = split(scripts[0], ":")[0]
  let sid = substitute(sid, '\v\s+', '', 'g')
  return sid
endfunction

function! nb#getScriptFunctionName(scriptPath, name) abort
  let s:sid = nb#findScriptId(a:scriptPath)
  return '<SNR>' . s:sid . '_' . a:name
endfunction

function! nb#getScriptFunction(scriptPath, name) abort
  return function(nb#getScriptFunctionName(a:scriptPath, a:name))
endfunction

