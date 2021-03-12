let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = 'perltidy -q --profile=$CONTRIB/perltidyrc %'
