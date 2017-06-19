" Generate table of contents for Markdown files
NeoBundle 'mzlogin/vim-markdown-toc'

" TODO: replace with remark formatter?

let g:vmt_dont_insert_fence = 1

" replace toc using header instead of boundaries also add a missing toc
function! MyMarkdownTocAddToc() abort
  let startpos = getcurpos()

  let line = search('# Table of Contents')

  if line == 0
    " remove to always add a missing toc on save
    return
    normal! gg
  else
    normal! dip
  endif

  put! ='# Table of Contents'
  GenTocGF

  if line != 0
    normal! dd
  endif

  call setpos('.', startpos)
endfunction
command! -nargs=* MyMarkdownTocAddToc call MyMarkdownTocAddToc(<f-args>)

augroup MyMarkdownAugroupCreateToc
  autocmd!
  autocmd BufWritePre *.md silent call MyMarkdownTocAddToc()
augroup END

