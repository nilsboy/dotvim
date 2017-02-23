if ! IsNeoVim()
  finish
endif

" Dark powered asynchronous completion framework for neovim 
NeoBundle 'Shougo/deoplete.nvim'

" set completeopt-=preview
set nowildmenu
" autocmd CmdwinEnter * let b:deoplete_sources = ['buffer']
  
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_refresh_always = 1

let g:deoplete#enable_ignore_case = 1

let g:deoplete#enable_smart_case = 0
let g:deoplete#enable_camel_case = 1

let g:deoplete#auto_complete_start_length = 1
" let g:deoplete#max_menu_width = 10

if neobundle#tap('deoplete.nvim') 
  function! neobundle#hooks.on_post_source(bundle) abort
    " TODO
    " call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])
		" call deoplete#custom#set('_', 'matchers', ['matcher_head'])

    " close popup and delete backword char.
    inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

    " list all possible copletions even without typing a prefix
    inoremap <silent><expr> <c-space> 
          \ deoplete#mappings#manual_complete()

    " TODO
		let g:deoplete#sources = {}
    " let g:deoplete#sources.javascript = ['ultisnips', 'ternjs']
    " let g:deoplete#sources._ = ['ultisnips']
    let g:deoplete#sources.javascript = []
    " let g:deoplete#sources.javascript = ['ultisnips']
    " let g:deoplete#sources.sh = ['buffer', 'tag']
  endfunction
  call neobundle#untap()
endif

function! DeopleteInfo() abort
  
		let g:deoplete#keyword_patterns = {}
endfunction

finish

" Use tab key to move down in popup menu
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

