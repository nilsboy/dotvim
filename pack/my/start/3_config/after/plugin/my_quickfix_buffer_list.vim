" based on: https://vi.stackexchange.com/a/2127

nnoremap <silent> <leader>b :call my_quickfix_buffer_list#list()<cr>
function! my_quickfix_buffer_list#list() abort
  call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr": v:val, "valid": 1}'))
  call setqflist([], 'a', { 'title' : 'buffer list' })
  copen
endfunction
