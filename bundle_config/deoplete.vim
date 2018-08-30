finish
NeoBundle 'Shougo/deoplete.nvim'
" tags: complete
" TODO: checkout maralla/completor.vim

" pip3 install --user neovim
" pip3 install --upgrade --user neovim

NeoBundle 'ternjs/tern_for_vim', { 'build': 'npm install' }

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_start_length = 0
let g:deoplete#sources = {}
" let g:deoplete#sources.javascript = ['tern', 'buffer', 'ultisnips']
let g:deoplete#sources.java = ['lsp']
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 0
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
" let g:deoplete#auto_complete_delay = 200

if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

" inoremap <silent><expr> <c-space> 
"       \ deoplete#mappings#manual_complete()

" " close popup and delete backword char.
" inoremap <expr><bs> deoplete#smart_close_popup()."<bs>"

" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" inoremap <expr> <cr> pclose

" tern
autocmd FileType javascript nnoremap <silent> <buffer> gt :TernDef<CR>
