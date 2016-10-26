finish
" Dark powered asynchronous unite all interfaces
" Needs vim8 or neovim
NeoBundle 'Shougo/denite.nvim'

":h Denite

nnoremap <silent> <tab> :Denite -resume<cr>

if neobundle#tap('denite.nvim') 
    function! neobundle#hooks.on_post_source(bundle)

denite#custom#map("normal", "<tab>", "<quit>")
denite#custom#map("insert", "<tab>", "<quit>")

nnoremap <silent> <leader>ff :call Find_Unite()<cr>
function! Find_Unite() abort
    call CdProjectRoot()
    :Denite
      \ -buffer-name=find-project-unite
      \ -mode=normal file_rec
      " \ script-file:find-and
endfunction

" MRU plugin includes unite.vim MRU sources
NeoBundle 'Shougo/neomru.vim'

" call unite#custom#source('neomru/file', 'converters', 
"     \ ['converter_file_directory_pretty'])
" call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

let g:neomru#file_mru_limit=3000

nnoremap <silent> <leader>rg :Denite file_mru<cr>

  endfunction
  call neobundle#untap()
endif
