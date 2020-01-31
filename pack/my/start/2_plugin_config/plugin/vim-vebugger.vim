" Yes, we do need another debugger plugin
"
" NOTE: Need to escape spaces in arguments i.e.: 
" VBGstartNInspect ./node_modules/.bin/jest -i -t "^service\ registered\ the\ service$" test/services/myservice-v1.test.js 

" sign define vebugger_current text=-> linehl=MoreMsg
" sign define vebugger_breakpoint text=** linehl=WarningMsg

" NOTE: debug nodejs: NODE_DEBUG=net - https://github.com/mattinsler/longjohn

call PackAdd('Shougo/vimproc.vim', {'do': {-> system('make')}})
PackAdd idanarye/vim-vebugger

let g:vebugger_view_source_cmd='edit'

nnoremap <silent> <leader>sS :VBGstartNInspect %<cr>
nnoremap <silent> <leader>st :VBGtoggleTerminalBuffer<cr>
nnoremap <silent> <leader>sk :VBGkill<cr>
nnoremap <silent> <leader>sc :VBGcontinue<cr>

nnoremap <silent> <leader>ss :VBGstepOver<cr>
nnoremap <silent> <leader>si :VBGstepIn<cr>
nnoremap <silent> <leader>so :VBGstepOut<cr>

nnoremap <silent> <leader>sb :VBGtoggleBreakpointThisLine<cr>
nnoremap <silent> <leader>sB :VBGclearBreakpoints<cr>

" does not work with nodejs?:
vnoremap <silent> <leader>se :VBGexecuteSelectedText<cr>

" *:VBGexecute* Execute the statement supplied as argument.
" *:VBGevalWordUnderCursor* Evaluate the <cword> under the cursor

augroup MyVebuggerAugroupSetupTerminalWindow
  autocmd!
  autocmd FileType VebuggerTerminal :AnsiEsc
  autocmd FileType VebuggerTerminal :setlocal nowrap
augroup END

