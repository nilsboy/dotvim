
augroup augroup_MyVimMarkdownToc_createToc
  autocmd!
  autocmd BufWritePre <buffer> :silent call MyVimMarkdownToc_addToc()
augroup END
