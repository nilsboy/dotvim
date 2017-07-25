" Shrink and unshrink part of a buffer to edit fenced code with a different
" filetype.
" see also: fenced code in markdown
function! MyShrinkShrink(options) abort
  if exists("b:shrink_before")
    call INFO('Already shrunk - please unshrink first.')
    return
  endif

  " make sure start end end can be found first
  normal gg
  execute '/' . a:options.start
  normal gg
  execute '/' . a:options.end

  let b:shrink_options = a:options
  let b:shrink_original_filetype = &filetype
  let b:shrink_register_a_org = @a

  normal gg
  execute '/' . b:shrink_options.start

  let b:shrink_indent = indent('.') + &shiftwidth
  normal! "adgg
  let b:shrink_before = @a

  normal gg
  execute '/' . b:shrink_options.end
  normal! "adG
  let b:shrink_after = @a

  let @a = b:shrink_register_a_org

  " remove indentation
  " normal! gg=G
  execute '%s/^\ \{' . b:shrink_indent . ',' . b:shrink_indent . '}//e'

  " remove leading and tailing new lines
  %s/\%^\n*//e
  %s/\n*\%$//e

  setlocal filetype=
  execute 'setlocal filetype=' . b:shrink_options.filetype
  nnoremap <buffer><silent> <esc> :silent call MyShrinkRestore()<cr>

  if exists("b:shrink_options.afterShrink")
    call b:shrink_options.afterShrink()
  endif
endfunction

function! MyShrinkRestore() abort
  let l:indent = repeat(' ', b:shrink_indent)
  execute '%s/^/' . l:indent . '/'

  if exists("b:shrink_options.beforeRestore")
    call b:shrink_options.beforeRestore()
  endif

  let b:shrink_register_a_org = @a

  let @a = b:shrink_before
  normal! gg"aP

  let @a = b:shrink_after
  normal! G"ap

  let @a = b:shrink_register_a_org
  execute "setlocal filetype=" . b:shrink_original_filetype
  unlet b:shrink_before
  nunmap <buffer> <esc>
endfunction

