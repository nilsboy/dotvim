" Run your tests at the speed of thought
NeoBundle 'janko-m/vim-test'

nmap <silent> <leader>ta :wall \| TestSuite<CR>
nmap <silent> <leader>tn :wall \| TestNearest<CR>
nmap <silent> <leader>tt :wall \| TestLast<CR>

finish

let g:test#preserve_screen = 1
let test#filename_modifier = ':p'

nmap <silent> <leader>tt :wall \| :TestLast<CR>
nmap <silent> <leader>tn :wall \| let test#strategy = "TestNeomakeSh" \| :TestNearest<CR>
nmap <silent> <leader>tT :wall \| let test#strategy = "Haha" \| :TestFile<CR>
nmap <silent> <leader>ta :wall \| let test#strategy = "Haha" \| :TestSuite<CR>
nmap <silent> <leader>tg :wall \| let test#strategy = "Haha" \| :TestVisit<CR>
nmap <silent> <leader>tg :wall \| let test#strategy = "Haha" \| :TestVisit<CR>

" TODO: to - open corresponding test file

let test#javascript#mocha#options = 
      \ ' --full-trace --no-colors'

" cmd is i.e. node_modules/.bin/mocha
function! Haha(cmd) abort
  let &l:errorformat = "%f:%l:%c:%m"
  " let &l:makeprg = a:cmd . "| outline --filetype mocha"
  let &l:makeprg = a:cmd
  Neomake!
  copen
endfunction

function! TestNeomakeSh(cmd) abort
  silent execute "RunIntoBuffer " . a:cmd
  " silent! :%s/AssertionError:\ /AssertionError:\r/g
  " silent! :%s/==\ /==\r/g
endfunction

let g:test#custom_strategies = {
    \ 'Haha': function('Haha'),
    \ 'TestNeomakeSh': function('TestNeomakeSh')
\}

" Dicitionary usage currently broken:
" https://github.com/janko-m/vim-test/issues/151
" let test#strategy = {
"   \ 'nearest': 'TestNeomakeSh',
"   \ 'file':    'Haha',
"   \ 'suite':   'Haha',
" \}

" let test#strategy = "dispatch"
" let test#strategy = "make"
" let test#strategy = "neovim"

