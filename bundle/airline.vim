finish

" Lean & mean status/tabline for vim that's light as air.
NeoBundle 'bling/vim-airline'

" it takes anything from :help filename-modifiers.
" let g:airline#extensions#tabline#fnamemod = ':t'

" the separator used on the left side
let g:airline_left_sep=''

" the separator used on the right side
let g:airline_right_sep=''

" enable modified detection
let g:airline_detect_modified=1

" determine whether inactive windows should have the left section collapsed to
" only the filename of that buffer.
let g:airline_inactive_collapse=1

" themes are automatically selected based on the matching colorscheme. this
" can be overridden by defining a value.
" let g:airline_theme=

" Possible Colors: bold, italic, red, green, blue, yellow, orange, purple
" call airline#parts#define_accent('file', 'StatusLine')
"
" function! AirlineInit()
"     let g:airline_section_a = airline#section#create(['file', ' ', 'readonly'])
"     let g:airline_section_b = airline#section#create(['filetype', ' ', 'ffenc'])
"     " let g:airline_section_c = airline#section#create(['%{getcwd()}'])
" endfunction
" autocmd VimEnter * call AirlineInit()

" function! MyAirline(...)
"     call a:1.add_section('StatusLine', '%t')
"     call a:1.add_section('StatusLineNC', '%r')
"     call a:1.split()
"     call a:1.add_section('StatusLine', '%y')
"     call a:1.add_section('StatusLineNC', '%{&fenc}')
"     call a:1.split()
"     call a:1.add_section('StatusLineNC', '%c')
"     call a:1.add_section('StatusLine', '%p%%')
"     return 1
" endfunction
" call airline#add_statusline_func('MyAirline')

