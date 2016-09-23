nnoremap <silent> <buffer>x :call CSSTidy()<CR>

if exists("b:did_ftplugin_css")
    finish
endif
let b:did_ftplugin_css = 1

function! CSSTidy() abort
    let _view=winsaveview()
    %!csstidy - --silent=true --template=low --sort_properties=true --sort_selectors=true --preserve_css=true
    call winrestview(_view)
endfunction
