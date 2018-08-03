" Run your tests at the speed of thought
NeoBundle 'janko-m/vim-test'

" Directory from which the first test was run
" Workaround for rerunning tests from outside of project dir
let g:MyTestCwd = ''
let g:MyTestLast = ''
function! MyTestStrategy(cmd)
  silent! wall
  if g:MyTestLast != 1 || ! g:MyTestCwd
    let g:MyTestCwd = getcwd()
  endif
  let g:MyTestLast = 0
  let cwd = getcwd()
  execute 'cd ' . g:MyTestCwd
  " call INFO('got cmd: ' . a:cmd)
  let cmds = split(a:cmd)
  let path = cmds[0]
  let arguments = join(cmds[1:])
  let compiler = fnamemodify(path, ':t')
  " call INFO('Using compiler: ' . compiler)
  execute 'compiler! ' . compiler
  execute 'silent! make! ' . arguments
  execute 'cd ' . cwd
  " call INFO('Running make ' . arguments)
  " call MyQuickfixRemoveWhitspace()
  copen
endfunction

let g:test#custom_strategies = {'MyTestStrategy': function('MyTestStrategy')}
let g:test#strategy = 'MyTestStrategy'

" let test#strategy = "neomake"
" let test#strategy = "make"

" let g:test#preserve_screen = 1
" let test#filename_modifier = ':.'

nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tt :let g:MyTestLast = 1 \| TestLast<CR>
nmap <silent> <leader>tv :execute 'cd ' . g:MyTestCwd \| TestVisit<CR>
" nmap <silent> <leader>te :execute 'edit ' . b:testFile<cr>
" nmap <silent> <leader>tm :execute 'edit ' . b:mainFile<cr>

