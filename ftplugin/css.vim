if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

map <silent> W :call CSSTidy()<CR>

function! CSSTidy()
    let _view=winsaveview()
    %!csstidy - --silent=true --template=low --sort_properties=true --sort_selectors=true --preserve_css=true
    call winrestview(_view)
endfunction
