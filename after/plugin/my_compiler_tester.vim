" For testing &errorformats.
" For an example see compiler/jest.vim
" Run this when on a compiler file.
" - set errorformat
" - put error output after finish
"
" Based on https://stackoverflow.com/a/29102995
"
" TODO: test positive look ahead to end a multiline match see: :h \@=

function! MyCompilerTesterTest() abort
  silent write
  source %
  call setqflist([])
  /^finish$/+1,$ :cgetbuffer
  copen
endfunction

nnoremap <silent> <leader>vc :call MyCompilerTesterTest()<cr>
