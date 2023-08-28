let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = "tidy"
let &makeprg .= " --tidy-mark false"
let &makeprg .= " --indent-spaces 2"
let &makeprg .= " --vertical-space 1"
let &makeprg .= " --indent-attributes 1"
let &makeprg .= " --indent 1"
let &makeprg .= " --markup 1"
let &makeprg .= " --sort-attributes alpha"
let &makeprg .= " --tab-size 2"
let &makeprg .= " --wrap 80"
let &makeprg .= " --wrap-attributes 1"
let &makeprg .= " --quiet 1"
let &makeprg .= " -modify"
let &makeprg .= " " . expand("%:p")

" let &makeprg .= " \\| errorformatregex "
