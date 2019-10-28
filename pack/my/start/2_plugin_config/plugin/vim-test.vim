" Run your tests at the speed of thought
PackAdd janko-m/vim-test

" Directory from which the first test was run - workaround for rerunning tests
" from outside of project dir
let g:MyTestCwd = ''
let g:MyTestLast = ''
function! MyTestStrategy(cmd, type)
  silent! wall
  if g:MyTestLast != 1 " || ! g:MyTestCwd
    let g:MyTestCwd = getcwd()
  endif
  let g:MyTestLast = 0
  let cwd = getcwd()
  execute 'cd ' . g:MyTestCwd
  let cmds = split(a:cmd)
  let path = cmds[0]
  let arguments = join(cmds[1:])
  let compiler = fnamemodify(path, ':t')
  " if a:type == 'near'
  "   let compiler = compiler . '-near'
  " endif
  execute 'compiler! ' . compiler
  " call INFO('arguments:', arguments)
  execute 'silent make!' . arguments
  execute 'cd ' . cwd
  " call MyQuickfixRemoveWhitspace()
  copen
  " cwindow
endfunction

function! MyTestStrategyFile(cmd)
  call MyTestStrategy(a:cmd, 'file')
endfunction

function! MyTestStrategyNear(cmd)
  call MyTestStrategy(a:cmd, 'near')
endfunction

let g:test#custom_strategies = {
      \ 'MyTestStrategyFile': function('MyTestStrategyFile'),
      \ 'MyTestStrategyNear': function('MyTestStrategyNear'),
      \ }

" test: :TestFile -strategy=neovim
nmap <silent> <leader>tf :TestFile -strategy=MyTestStrategyFile<CR>
nmap <silent> <leader>tn :TestNearest -strategy=MyTestStrategyNear<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tt :let g:MyTestLast = 1 \| TestLast<CR>
nmap <silent> <leader>tv :execute 'cd ' . g:MyTestCwd \| TestVisit<CR>
" nmap <silent> <leader>te :execute 'edit ' . b:testFile<cr>
" nmap <silent> <leader>tm :execute 'edit ' . b:mainFile<cr>

