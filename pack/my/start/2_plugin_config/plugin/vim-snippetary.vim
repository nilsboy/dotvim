PackAdd nilsboy/vim-snippetary

" The disabled ultisnips.vim used to define g:UltiSnipsSnippetDirectories;
" snippetary would only see its default ['UltiSnips'] then, so set it here.
let g:snippetary_snippet_dirs = ['UltiSnips', $HOME . '/.vimlocal/UltiSnips']

" j: jump to the definition of the snippet matching the text at the cursor;
" falls back to the filetype's snippet file
nnoremap <silent><leader>js :<C-u>call snippetary#goto_definition()<cr>
" S: jump to the global (all-filetypes) snippet file
nnoremap <silent><leader>jS :<C-u>SnippetaryEditGlobal<cr>
" l: jump to the per-filetype overrides in ~/.vimlocal
nnoremap <silent><leader>jl :<C-u>execute 'edit '
      \ . fnameescape($HOME . '/.vimlocal/UltiSnips/' . &filetype . '.snippets')<cr>
