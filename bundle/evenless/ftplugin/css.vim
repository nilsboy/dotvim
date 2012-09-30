map <silent> W :call CSSTidy()<CR>

function CSSTidy()
    let _view=winsaveview()
    %!csstidy - --silent=true --template=low --sort_properties=true --sort_selectors=true --preserve_css=true
    call winrestview(_view)
endfunction
