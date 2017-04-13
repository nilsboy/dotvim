" TODO: try git code search:
" https://www.reddit.com/r/vim/comments/5szwgc/made_a_command_for_doing_a_github_code_search/

nnoremap <leader>ih yiw:call online_help#help(@")<cr>

function! online_help#help(term) abort
  let filetype = &filetype
  if filetype != ''
    let filetype = ' -l ' . filetype
  endif
  call Run('howto', 'how2' . filetype
        \ . ' ' . shellescape(a:term))
  " call search('Press SPACE')
  " normal! kdGgg
  normal! gg3dd
endfunction
