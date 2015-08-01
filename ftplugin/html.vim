map <silent> W :call HTMLTidy()<CR>

" ignore all unknown tags to support web components
let g:syntastic_quiet_messages = {
    \ "regex":   '\(is not recognized\|discarding unexpected\)' }

function! HTMLTidy()
    let _view=winsaveview()

    %!html-beautify
        \  --file -
        \ --indent-size 2
        \ --indent-inner-html
        \ --wrap-line-length 80
        \ --preserve-newlines
        \ --max-preserve-newlines 2
        " \ --wrap-attributes force
  
"  -b, --brace-style                 [collapse|expand|end-expand] ["collapse"]

    call winrestview(_view)
endfunction

" html-beautify@1.5.5
" 
" CLI Options:
"   -f, --file       Input file(s) (Pass '-' for stdin)
"   -r, --replace    Write output in-place, replacing input
"   -o, --outfile    Write output to file (default stdout)
"   --config         Path to config file
"   --type           [js|css|html] ["js"]
"   -q, --quiet      Suppress logging to stdout
"   -h, --help       Show this help
"   -v, --version    Show the version
" 
" Beautifier Options:
"   -s, --indent-size             Indentation size [4]
"   -c, --indent-char             Indentation character [" "]
"   -b, --brace-style                 [collapse|expand|end-expand] ["collapse"]
"   -I, --indent-inner-html           Indent body and head sections. Default is false.
"   -S, --indent-scripts              [keep|separate|normal] ["normal"]
"   -w, --wrap-line-length            Wrap lines at next opportunity after N characters [0]
"   -A, --wrap-attributes             Wrap html tag attributes to new lines [auto|force] ["auto"]
"   -i, --wrap-attributes-indent-size Indent wrapped tags to after N characters [indent-level]
"   -p, --preserve-newlines           Preserve line-breaks (--no-preserve-newlines disables)
"   -m, --max-preserve-newlines       Number of line-breaks to be preserved in one chunk [10]
"   -U, --unformatted                 List of tags (defaults to inline) that should not be reformatted
