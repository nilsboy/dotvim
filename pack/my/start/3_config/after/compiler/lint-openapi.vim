MyInstall lint-openapi npm install -g ibm-openapi-validator
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "lint-openapi --errors_only"
      \ . " --config " . $CONTRIB . "/openapirc " . expand('%:p')

let &makeprg .= " \\| errorformatregex --filename " . expand("%:p")

" │ errors
" │
" │   Message :   Parameter objects must have a `description` field.
" │   Path    :   paths./v1/productOfferings.get.parameters.0
" │   Line    :   55

let &makeprg .= " 'e/^\\s*()()Message\\s*\\:\\s*[\\s\\S]*?Line\\s*\\:\\s*(\\d+)/gm'"

" │ YAMLException: bad indentation of a mapping entry at line 119, column 5:

let &makeprg .= " 'e/^()().*?Exception.*?at\\s+line\\s+(\\d+).*?column\\s+(\\d+).*/gm'"
