" Run any executable that returns a file name
" Spaces have to be quoted i.e.:
" script-file:ls\ -la
 
let s:grep_source = { 'name': 'script-file', 'is_volatile': 1 } 
function! s:grep_source.gather_candidates(args, context) 
  let l:command = get(a:args, 0,
    \ 'echo specify command in unite config')

  let l:candidates = split( 
    \ unite#util#system(printf( 
    \   l:command . ' %s', 
    \   a:context.input, 
    \ )), 
    \  "\n") 
  return map(l:candidates, 
    \ '{  
    \   "word": v:val, 
    \   "source": "script-file", 
    \   "kind": "file", 
    \   "action__path" : v:val,
    \ }') 
endfunction 
  " fnamemodify(v:val, ":p:h")
call unite#define_source(s:grep_source) 
