if ! IsNeoVim()
  finish
endif

" ALE conflicts with Neomake.
" Uninstall it, or disable this warning with
" `let g:ale_emit_conflict_warnings = 0` in your vimrc file,
" *before* plugins are loaded.
let g:ale_emit_conflict_warnings = 0

" Asynchronous Lint Engine
NeoBundle 'w0rp/ale'
" NOTE: For diagnostics run
" :ALEInfo
" NOTE: Does not report errors from validators

" Does not update on undo?

" use quickfixsigns for signs
" let g:ale_set_signs=0

let g:ale_linters = {}

" TODO: run formatter first?
" let g:ale_lint_delay = 1000

