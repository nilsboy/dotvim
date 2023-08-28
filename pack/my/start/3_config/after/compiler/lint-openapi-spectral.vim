MyInstall spectral npm install -g @stoplight/spectral-cli
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "spectral lint "
let &makeprg .= " --verbose"
let &makeprg .= " --format text"

let &makeprg .= " " . expand('%:p')
let &makeprg .= " --ruleset $CONTRIB/spectralrc"

" let &makeprg .= " \\| errorformatregex --filename='" . expand("%:p") . "'"

"                          " │   Message :   Property names must be snake case
" " api-spec/v1.openapi.yaml │   Path    :   components.schemas.Error.properties.referenceError
"                          " │   Line    :   18631
" let &makeprg .= " 'e/^\\s*Message\\s*\\:\\s*[\\s\\S]*?Line\\s*\\:\\s*(?<row>\\d+)/gm'"

" " │ YAMLException: bad indentation of a mapping entry at line 119, column 5:
" " let &makeprg .= " 'e/^.*?Exception.*?at\\s+line\\s+(?<row>\\d+).*?column\\s+(?<col>\\d+).*/gm'"

" let &makeprg .= " 'e/^\\s*\[Error\].*$/gm'"
" let &makeprg .= " 'e/Error/gm'"
