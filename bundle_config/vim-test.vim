" Run your tests at the speed of thought
NeoBundle 'janko-m/vim-test'

nmap <silent> <leader>tf :silent wall \| TestSuite<CR>
nmap <silent> <leader>tn :silent wall \| TestNearest<CR>
nmap <silent> <leader>tt :silent wall \| TestLast<CR>

" TODO: <leader>to - open corresponding test file

let g:test#javascript#patterns = {
      \ 'test': ['\v^\s*%(it|test)\s*[( ]\s*%("|''|`)(.*)%("|''|`)'],
      \ 'namespace': ['\v^\s*%(describe|suite|context)\s*[( ]\s*%("|''|`)(.*)%("|''|`Description)']}

let test#javascript#mocha#options = 
      \ ' --full-trace --no-colors --compilers js:babel-core/register test/'

let test#strategy = "neomake"

finish

let g:test#preserve_screen = 1
let test#filename_modifier = ':p'

