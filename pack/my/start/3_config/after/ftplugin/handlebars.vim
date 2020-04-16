" SEE ALSO: mustache plugin

let &l:comments = 's1://'
let &l:commentstring = '// %s'

" let &l:comments = 's1:{{! ,ex:}}'
" let &l:commentstring = '{{! %s}}'

let b:outline = '\v^\s*".+"\s*\:\s*[{\[]+\s*$'

let b:match_words = '{{#.\+}}:{{else}}:{{/.\+}}'
