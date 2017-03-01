if ! IsNeoVim()
  finish
endif

" Asynchronous Lint Engine
NeoBundle 'w0rp/ale'

" Does not update on undo?

" use quickfixsigns for signs
" let g:ale_set_signs=0

let g:ale_linters = {}

" TODO: run formatter first?
" let g:ale_lint_delay = 1000

