" TAGS: gutter

sign define MyQuickfixSignEmpty
augroup MyQuickfixAugroupPersistentSignsColumn
  autocmd!
  autocmd BufEnter * call MyQuickfixShowSignsColumn()
  autocmd FileType qf call MyQuickfixShowSignsColumn()
augroup END

function! MyQuickfixShowSignsColumn() abort
  execute 'execute ":sign place 9999 line=1
        \ name=MyQuickfixSignEmpty buffer=".bufnr("")'
endfunction

let &signcolumn = 'yes:1'
