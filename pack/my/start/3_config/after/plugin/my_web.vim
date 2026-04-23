" Search the web
" TAGS: internet search
" SEE ALSO: https://github.com/kabbamine/zeavim.vim

command! -nargs=* WebWithFiletype call Web (&filetype, <f-args>)

command! -nargs=* Web call Web(<f-args>)
function! Web(...) abort
  let engine = a:000[0]
  let withType = a:000[1]
  let query = join(a:000[2:], ' ')

  " NOTE: use ,t instead on command line
  let filetype = ''
  if withType == 1
    if &filetype != ''
      let filetype = &filetype .. ' '
    endif
  endif
  let query = input(':' . engine . ': ', filetype .. query) 

  if engine == 'phind'
    silent execute '!firefox -P default https://phind.com/search?q=' . shellescape(query) 
  elseif engine == 'duck'
    silent execute '!firefox -P default https://duckduckgo.com/?q=' . shellescape(query) 
  elseif engine == 'leo'
    silent execute '!firefox -P default https://dict.leo.org/englisch-deutsch/' . shellescape(query) 
  elseif engine == 'grep.app'
    silent execute '!firefox -P default https://grep.app/search?q=' . shellescape(query) 
  elseif engine == 'grep.app-withType'
    silent execute '!firefox -P default https://grep.app/search?' . shellescape('filter[lang][0]=' . &filetype . '&q=' . shellescape(query))
  elseif engine == 'perplexity'
    silent execute '!firefox -P default https://perplexity.ai/search?q=' . shellescape(query) 
  elseif engine == 'youtube'
    silent execute '!firefox -P default https://www.youtube.com/results?search_query=' . shellescape(query) 
 
  elseif engine == 'github'
    silent execute '!firefox -P default https://github.com/search?type=code' . shellescape('&q=' . shellescape(query))
  elseif engine == 'github-withType'
    silent execute '!firefox -P default https://github.com/search?type=code' . shellescape('&l=' . &filetype . '&q=' . shellescape(query))
  else
    throw 'No such search engine: ' . engine
  endif
endfunction

" default keywordprg
let &keywordprg = ':Web'

for [engine, key] in [["perplexity", "" ], ["duck", "d"], ["leo", "t"], ["github", "g"], ["github-withType", "G"], ["grep.app", "c"], ["grep.app-withType", "C"],
      \ ["perplexity", "p"], ["youtube", "y"] ]
  execute 'nnoremap <leader>i' . key . 'i :call Web("' . engine . '", 0)<cr>'
  execute 'vnoremap <leader>i' . key . 'i "zy:call Web("' . engine . '", 0, @z)<cr>'
  execute 'nnoremap <leader>i' . key . 'w "zyiw:call Web("' . engine . '", 0, @z)<cr>'
  execute 'nnoremap <leader>i' . key . 'W "zyiW:call Web("' . engine . '", 0, @z)<cr>'
endfor

