MyInstall lint-openapi npm install -g ibm-openapi-validator
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "lint-openapi --errors_only --debug "
      \ . " --print_validator_modules --ruleset " . $CONTRIB . "/openapirc "

let &makeprg .= expand('%:p')

" TBD: deprecated format - transition to ruleset to lower the severity of a
" lot of errors - currently produces a lot of them:
      " \ . " --config " . $CONTRIB . "/openapirc " . expand('%:p')

let &makeprg .= " \\| errorformatregex --filename='" . expand("%:p") . "'"

" let &makeprg .= " 'e/^\\s*Message\\s*\\:\\s*[\\s\\S]*?Line\\s*\\:\\s*(?<row>\\d+)/gm'"

" │ YAMLException: bad indentation of a mapping entry at line 119, column 5:
" let &makeprg .= " 'e/^.*?Exception.*?at\\s+line\\s+(?<row>\\d+).*?column\\s+(?<col>\\d+).*/gm'"

let &makeprg .= " 'e/^\\s*\[Error\].*$/gm'"
let &makeprg .= " 'e/Error/gm'"
