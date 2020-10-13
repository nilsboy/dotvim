" based on: https://vi.stackexchange.com/a/2127

function! my_quickfix_buffer_list#list() abort
  let currentBufnr = bufnr('%')
  let list = 
        \ sort(
          \ map(
            \ filter(
              \ range(1, bufnr('$')),
              \ 'buflisted(v:val) && (nb#buffer#isNamed(v:val) || !nb#buffer#isEmpty(v:val))'
            \ ),
            \ function('my_quickfix_buffer_list#buildEntry')
          \ ),
          \ 'my_quickfix_buffer_list#cmp'
        \ )
  if len(list) == 0
    call nb#info('No open buffers.')
    return
  endif
  let i = 0
  let currentFileLine = 0
  for entry in list
    let i = i + 1
    if entry.bufnr == currentBufnr
      let currentFileLine = i
      break
    endif
  endfor
  let g:MyQuickfixFormatOnce = 'NoFile'
  call setqflist(list)
  " current file may not be in the listed
  if currentFileLine != 0
    execute 'silent keepjumps cc ' currentFileLine
  endif
  call setqflist([], 'a', { 'title' : 'buffers' })
  silent! lclose
  copen
endfunction

function! my_quickfix_buffer_list#buildEntry(key, bufnr) abort
  let basename = fnamemodify(bufname(a:bufnr), ":t")
  let bufname = bufname(a:bufnr) != '' ? bufname(a:bufnr) : '[No Name]'
  return {
        \ "bufnr": a:bufnr,
        \ "valid": 1,
        \ "filename": bufname(a:bufnr),
        \ "basename": basename,
        \ "text": bufname,
  \ }
endfunction

function! my_quickfix_buffer_list#cmp(e1, e2) abort
  return a:e1.basename == a:e2.basename ? 0 
        \ : a:e1.basename > a:e2.basename ? 1 : -1
endfunction

nnoremap <silent><cr> :silent call my_quickfix_buffer_list#list()<CR>
vnoremap <silent><cr> :silent call my_quickfix_buffer_list#list()<CR>
