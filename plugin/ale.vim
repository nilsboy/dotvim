" Asynchronous Lint Engine
" NOTE: For diagnostics run
"   :ALEInfo
" NOTE: Does not report errors from validators
" NOTE: breaks own CursorHoldI autocmds
" NOTE: Does not update on undo?

if ! IsNeoVim()
  finish
endif

" supress error message about this var (2017-05-28)
let g:ale_change_sign_column_color = 0

" ALE conflicts with Neomake.
" Uninstall it, or disable this warning with
" `let g:ale_emit_conflict_warnings = 0` in your vimrc file,
" *before* plugins are loaded.
let g:ale_emit_conflict_warnings = 0

" use quickfixsigns for signs
" let g:ale_set_signs=0

" let g:ale_linters = {}

" TODO: run formatter first?
" let g:ale_lint_delay = 1000

PackAdd w0rp/ale
