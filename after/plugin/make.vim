" Use for: linting, makeing, testing, formatting, finding stuff
"
" Related plugins:
" - make (builtin)
"   - synchronous
"   - TODO: set makeef
" - neomake
"   - stdin possible with neomake-autolint?
"   - does mess with &makeprg / &errorformat and not respect buffer local
"   - only used it as regular make - makes no difference to buildin :make
"   versions of those?
" - vim-dispatch
"   - no job-api support
" - vim-makejob
"   - no stdin support - add maybe?
" - vim-test
"   - uses vim-dispatch
" - ale
" - asyncrun
" - autoformat
"   - does not have a lot of preconfigured formatters
" - neomake-multiprocess
" see also:
" - vim-qf
" - detect quickfix:
"   https://www.reddit.com/r/vim/comments/5ulthc/how_would_i_detect_whether_quickfix_window_is_open/
" - async.vim:
"   https://github.com/prabirshrestha/async.vim

" Notes
" Note: &shellpipe
" - every line of output from makeprg is listed as an error
" - lines that match errorformat get a valid = 1 in the getqflist()
" - get count of actual errors: len(filter(getqflist(), 'v:val.valid'))
" - see h :signs for the gutter
" - List all defined signs and their attributes:
" :sign list
" - List placed signs in all files:
" :sign place
" Clear quickfix: :cex[]

" See also: 
" :Man scanf
" :h quickfix
" :h errorformat
" - For errorformat debugging see:
" :h neomake
" section: 6.3 How to develop/debug the errorformat setting?
" To send to stdin see:
" :h jobsend()

" TODO: highlight lines with errors: https://github.com/mh21/errormarker.vim
" TODO format quickfix output: https://github.com/MarcWeber/vim-addon-qf-layout
" TODO checkout quickfixsigns for resetting the signes on :colder etc
" TODO use winsaveview to prevent window resizing on copen
" TODO always close buffer of preview window - is there a plugin for that?
" TODO checkout https://github.com/stefandtw/quickfix-reflector.vim
" TODO add description to quickfix window title
" TODO: add error count to statusline
"
" Note: :compiler is only meant to be used for one tool/buffer at a time - 
" is not possible to have several commands e.g. linter, finder, formatter
" see also: https://github.com/LucHermitte/vim-build-tools-wrapper/blob/master/doc/filter.md
" Note: makeprg and errorformat are ether local or global but if you want to
" run something different than the default with make those vars have to be
" saved and restored

" don't echo make output to screen
let &shellpipe = '&>'

" let &makeprg = 'ls'
" let &errorformat = '%f'

" TODO: when using :make save &makeprg and &errorformat the fist time as the
" compiler if set?
" TODO: :make needs pipes escaped / neomake doesn't
command! -nargs=* Make call Make(<f-args>)
function! Make_make() abort
  " echo &l:makeprg | echo &l:errorformat | echo &makeprg | echo &errorformat
  " echom &l:makeprg
  " return
  wall
  silent! make!
  copen
endfunction

let g:neomake_javascript_run_maker = {
    \ 'exe': 'node',
    \ 'errorformat': '%AError: %m,%AEvalError: %m,%ARangeError: %m,%AReferenceError: %m,%ASyntaxError: %m,%ATypeError: %m,%Z%*[\ ]at\ %f:%l:%c,%Z%*[\ ]%m (%f:%l:%c),%*[\ ]%m (%f:%l:%c),%*[\ ]at\ %f:%l:%c,%Z%p^,%A%f:%l,%C%m,%-G%.%#'
    \ }

function! Make() abort
  " :make needs pipes escaped / neomake doesn't
  let &makeprg = substitute(&makeprg, '\\|', '|', 'g')
  " echo &l:makeprg | echo &l:errorformat | echo &makeprg | echo &errorformat
  " echom &makeprg
  " return
  wall
  Neomake!
  copen
endfunction

nnoremap <silent><leader>ee :Neomake run<cr>
nnoremap <silent><leader>el :Neomake lint<cr>
nnoremap <silent><leader>ef :Neomake format<cr>

nnoremap <silent><leader>eh :Verbose echo &makeprg \| echo &errorformat<cr>
nnoremap <silent><leader>ed :edit /tmp/neomake.log <cr>
