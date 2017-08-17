" Run your tests at the speed of thought
" NeoBundle 'janko-m/vim-test'
NeoBundle 'nilsboy/vim-test'

nmap <silent> <leader>tf :silent wall \| TestFile<CR>
nmap <silent> <leader>ta :silent wall \| TestSuite<CR>
nmap <silent> <leader>tn :silent wall \| TestNearest<CR>
nmap <silent> <leader>tt :silent wall \| TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

" TODO: <leader>to - open corresponding test file

function! MyTestStrategy(cmd)
  " call INFO('got cmd: ' . a:cmd)
  let cmds = split(a:cmd)
  let path = cmds[0]
  let arguments = join(cmds[1:])
  let compiler = fnamemodify(path, ':t')
  " call INFO('Using compiler: ' . compiler)
  execute 'compiler! ' . compiler
  execute 'silent! make ' . arguments
  " call INFO('Running make ' . arguments)
  silent call MyQuickfixSetNavigationType('quickfix')
  copen
endfunction

let g:test#custom_strategies = {'MyTestStrategy': function('MyTestStrategy')}
let g:test#strategy = 'MyTestStrategy'

" let test#strategy = "neomake"
" let test#strategy = "make"

" let g:test#preserve_screen = 1
" let test#filename_modifier = ':.'
