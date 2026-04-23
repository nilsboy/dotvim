let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let src = expand("%:p") 
let temp = nb#createTempFile('jq')

let &makeprg = 'jq < ' . src . ' > ' . temp . ' ; cp ' . temp . ' ' . src

if exists("jqjson#loaded")
  finish
endif
let jqjson#loaded = 1

MyInstall jq pkexec apt install jq

