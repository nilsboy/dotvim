" Script for testing &errorformats
" - set errorformat
" - put error output after finish
" - run :source %
" based on https://stackoverflow.com/a/29102995
" TODO: test positive look ahead to end a multiline match see: :h \@=

let &l:errorformat  = ''
let &l:errorformat .= '%Enot ok %n %.%#,'
let &l:errorformat .= '%Z\ %#at\ %f:%l:%c,'
let &l:errorformat .= '%Z\ %#at\ %.%#\ (%f:%l:%c),'
let &l:errorformat .= '%C\ %#%m,'
let &l:errorformat .= '%-G%.%#,'

" let &l:errorformat .= '%-Eok %n %.%#,'
" let &l:errorformat .= '%Z\ %#at\ %f:%l:%c,'
" let &l:errorformat .= '%Z\ %#at\ %.%#\ (%f:%l:%c),'
" let &l:errorformat .= '%C\ %#%m,'

" let &l:errorformat .= '\ %#at\ %.%#\ (%f:%l:%c),'
" let &l:errorformat .= '%-G%.%#,'
" let &l:errorformat .= ',%Z%\ %#hhahat\ %#%f:%l:%c'

call setqflist([])
silent! :/^finish$/+1,$ :cbuffer

" Prefix valid entries
let list = getqflist()
for item in list
  if item.valid
    let item.text = 'VALID ' . item.text
  endif
endfor
call setqflist(list)

finish
1..50
not ok 1 manager .create should create a new model
  AssertionError [ERR_ASSERTION]: Car should have ID 1
      at test/manager.create.js:19:16
      at tryCatcher (node_modules/bluebird/js/release/util.js:16:23)
      at Promise._settlePromiseFromHandler (node_modules/bluebird/js/release/promise.js:512:31)
      at Promise._settlePromise (node_modules/bluebird/js/release/promise.js:569:18)
      at Promise._settlePromise0 (node_modules/bluebird/js/release/promise.js:614:10)
      at Promise._settlePromises (node_modules/bluebird/js/release/promise.js:693:18)
      at Async._drainQueue (node_modules/bluebird/js/release/async.js:133:16)
      at Async._drainQueues (node_modules/bluebird/js/release/async.js:143:10)
      at Immediate.Async.drainQueues (node_modules/bluebird/js/release/async.js:17:14)
ok 2 manager .create should create a new collection
ok 3 manager .create should create a new, populated model
Error: No entry found in cars with customCarId = 3
    at Child.<anonymous> (/home/nilsb/src/bookshelf-manager/lib/manager.js:246:17)
    at Child.tryCatcher (/home/nilsb/src/bookshelf-manager/node_modules/bluebird/js/release/util.js:16:23)
ok 4 manager .create should throw if existing model could not be found
