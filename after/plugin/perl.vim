function! PerlTidy()
    let _view=winsaveview()
    "%!perltidy -q
    %!perltidier -q
    " %!tidyall --conf-name ~/.tidyallrc -p ~/.tidyallrc
    call winrestview(_view)
endfunction

command! -nargs=0 PerlModuleCreate call PerlModuleCreate()
function! PerlModuleCreate()
    let line = shellescape(getline("."))
    let output = system('perl-module-create ' . line)
    "  CGI
    let file = substitute(output, "\v\s+$", "", "g")
    execute ':edit ' . file
endfunction

