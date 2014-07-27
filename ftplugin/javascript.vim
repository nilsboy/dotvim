map <silent> W :call JSTidy()<CR>

function JSTidy()
    let _view=winsaveview()
    " installed by cpanm JavaScript::Beautifier
    %!js_beautify.pl -
    call winrestview(_view)
endfunction
