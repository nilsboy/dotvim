" Narrow a region of a buffer into a new buffer updating changes on close.
" SEE ALSO: nrrwrgn
" TAGS: shrink narrow
function! my_narrow#narrow(opts) range abort
  let filetype = get(a:opts, 'filetype', &filetype)
  let lines = getline(a:firstline, a:lastline)
  let bufnr = bufnr()
  let curpos = getpos("'`")
  let curpos[1] = curpos[1] - a:firstline + 1

  let minIndent = -1
  for lnum in range(a:firstline, a:lastline)
    let indent = indent(lnum)
    if minIndent == -1
      let minIndent = indent
    endif
    if minIndent > indent
      let minIndent = indent
    endif
  endfor

  let narrowIndent = minIndent
  let curpos[2] = curpos[2] - narrowIndent

  let tempfile = nb#mktemp("region") 
        \ . fnamemodify(bufname('%'), ':p:t') . ".narrowed" 
  execute 'keepjumps edit ' . tempfile
  execute 'setlocal filetype=' . filetype
  let b:narrowIndent = narrowIndent
  let b:narrowBuffer = bufnr
  let b:narrowFirstline = a:firstline
  let b:narrowLastLine = a:lastline
  keepjumps 0put =lines
  keepjumps normal! G"_dd
  if b:narrowIndent > 0
    keepjumps silent execute '%' . b:narrowIndent . '<'
  endif
  call setpos('.', curpos)
  augroup markdown#augroupWriteBack
    autocmd!
    autocmd BufUnload <buffer> :unsilent call my_narrow#writeBack({})
  augroup END
endfunction

function! my_narrow#writeBack(opts) abort
  let curpos = getpos(".")
  let curpos[1] = b:narrowFirstline - 1 + curpos[1]
  let curpos[2] = b:narrowIndent + curpos[2] 
  if b:narrowIndent > 0
    keepjumps silent execute '%' . b:narrowIndent . '>'
  endif
  let newLines = getline(1, '$')

  let void = deletebufline(b:narrowBuffer, b:narrowFirstline, b:narrowLastLine)
  let void = appendbufline(b:narrowBuffer, b:narrowFirstline - 1, newLines)
  silent bwipeout!
  call setpos('.', curpos)
endfunction

