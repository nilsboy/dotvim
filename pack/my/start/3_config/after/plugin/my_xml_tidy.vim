function! MyXmlTidy()
    let _view=winsaveview()
    %!tidy 
        \ --indent-spaces 2
        \ --vertical-space 1
        \ --indent-attributes 1
        \ --indent 1
        \ --markup 1
        \ --sort-attributes alpha
        \ --tab-size 4
        \ --wrap 80
        \ --wrap-attributes 1
        \ --quiet 1
        \ --input-xml 1
    call winrestview(_view)
endfunction
