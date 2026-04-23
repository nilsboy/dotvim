let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

" let &makeprg  = 'mvn clean install -e'
let &makeprg  = 'mvn -DskipTests verify'

" with debug:
" let &makeprg  = 'mvn clean install -X -e'
let &makeprg .= ' 2>&1'

" let &makeprg .= " \\| grep -vFi 'node_modules/'"
let &makeprg .= " \\| errorformatregex"

" foo/bar.ts(13,23): error TS1261: Already included...
" let &makeprg .= " 'e/^(?<file>.+)\\((?<row>\\d+),(?<col>\\d+)\\).*$/igm'"
"
" [INFO] BUILD FAILURE 
let &makeprg .= " 'e/BUILD FAILURE/gm'"

" let &makeprg .= " 'e/error/igm'"

let &makeprg .= " 'e/^[\\w+\\.]+\\w+(Exception\\|Error)/igm'"

let &makeprg .= " 'e/^caused by/igm'"
