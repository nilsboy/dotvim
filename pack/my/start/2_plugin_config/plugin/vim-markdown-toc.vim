" Generate table of contents for Markdown files
PackAdd mzlogin/vim-markdown-toc

" TODO: replace with remark formatter?

let g:vmt_dont_insert_fence = 1

" replace toc using header instead of boundaries also add a missing toc
function! MyMarkdownTocAddToc() abort
  mark v

  call MyMarkdownTocRemove()

  " put! ='## Table of Contents'
  let line = search('# Table of Contents')
  if line == 0
    return
  endif
  GenTocGF

  silent! normal! `v
endfunction
command! -nargs=* MyMarkdownTocAddToc call MyMarkdownTocAddToc(<f-args>)

function! MyMarkdownTocRemove() abort
  let line = search('# Table of Contents')
  keepjumps normal! $
  let lineTo = search('^#')

  if line == 0
    return
  endif
  if lineTo == 0
    return
  endif
  if line + 1 == lineTo
    return
  endif
  if lineTo <= line
    return
  endif
  let line = line + 1
  let lineTo = lineTo - 1

  keepjumps execute line . ',' . lineTo . 'd _'
endfunction

augroup MyMarkdownAugroupCreateToc
  autocmd!
  autocmd BufWritePre *.md silent call MyMarkdownTocAddToc()
augroup END

