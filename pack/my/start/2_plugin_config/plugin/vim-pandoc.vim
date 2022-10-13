finish
" vim-pandoc provides facilities to integrate Vim with the pandoc document
" converter and work with documents written in its markdown variant (although
" textile documents are also supported).
" TAGS: markdown
PackAdd vim-pandoc/vim-pandoc

let g:pandoc#keyboard#use_default_mappings = 0
let g:pandoc#modules#enabled = ["folding"]
let g:pandoc#formatting#mode = "h"
let g:pandoc#formatting#textwidth = 80
" let g:pandoc#spell#enabled = 0

set foldenable
set foldlevel=0
let g:pandoc#folding#fdc = 0
" force all headers at foldlevel 1
let g:pandoc#folding#mode = 'stacked'
let g:pandoc#folding#fold_fenced_codeblocks = 1
let g:pandoc#folding#fastfolds = 1

" buffer:
" let b:pandoc_folding_basic = 1

PackAdd vim-pandoc/vim-pandoc-syntax

let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#codeblocks#embeds#use = 0
let g:pandoc#syntax#codeblocks#ignore = [ 'text' ]

" syn match pandocCodeblock /\([ ]\{4}\|\t\).*$/
