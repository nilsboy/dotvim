" based on: https://vi.stackexchange.com/a/2127

" TODO: duplicate filenames
" TODO: exclude special buffers quickfix

function! my_quickfix_buffer_list#list() abort
  let currentBufnr = bufnr('%')
  let list = 
        \ sort(
          \ map(
            \ filter(
              \ range(1, bufnr('$')),
              \ 'buflisted(v:val) && !nb#isBufferEmpty(v:val)'
            \ ),
            \ function('my_quickfix_buffer_list#buildEntry')
          \ ),
          \ 'my_quickfix_buffer_list#cmp'
        \ )
  if len(list) == 0
    call INFO('No open files.')
    return
  endif
  let i = 0
  for entry in list
    let i = i + 1
    if entry.bufnr == currentBufnr
      let currentFileLine = i
      break
    endif
  endfor
  let g:MyQuickfixFormatOnce = 'NoFile'
  call setqflist(list)
  execute 'keepjumps cc ' currentFileLine
  call setqflist([], 'a', { 'title' : 'buffers' })
  copen
endfunction

function! my_quickfix_buffer_list#buildEntry(key, bufnr) abort
  let basename = fnamemodify(bufname(a:bufnr), ":t")
  return {
        \ "bufnr": a:bufnr,
        \ "valid": 1,
        \ "filename": bufname(a:bufnr),
        \ "basename": basename,
        \ "text": basename,
  \ }
endfunction

function! my_quickfix_buffer_list#cmp(e1, e2) abort
  return a:e1.basename == a:e2.basename ? 0 
        \ : a:e1.basename > a:e2.basename ? 1 : -1
endfunction

nnoremap <silent><cr> :call my_quickfix_buffer_list#list()<CR>
vnoremap <silent><cr> :call my_quickfix_buffer_list#list()<CR>
