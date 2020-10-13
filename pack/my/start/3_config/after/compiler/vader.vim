let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = 'vader ' .. expand('%:p') .. ' 2>&1'

" │     ( 8/10) [EXECUTE] previous cursor moved
" │     ( 8/10) [EXECUTE] (X) Assertion failure

let &makeprg .= " \\| errorformatregex --filename " .. expand('%:p')
let &makeprg .= " 'r/execute\\] (.*)$[\\s\\n].*execute\\] \\(X\\) .+$/igm'"
