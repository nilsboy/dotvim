" SEE ALSO: http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
" SEE ALSO: https://github.com/inkarkat/vim-UnconditionalPaste

function! Paste(regname, pasteType, pastecmd)
  let reg_type = getregtype(a:regname)
  let reg_content = getreg(a:regname)
  let reg_content = substitute(reg_content, '\v\n+$', '', 'g')
  let reg_content = substitute(reg_content, '\v\s*$', ' ', 'g')
  let reg_content = substitute(reg_content, '\v^\s*', ' ', 'g')
  call setreg(a:regname, reg_content,  a:pasteType)
  execute 'normal "'.a:regname . a:pastecmd
  call setreg(a:regname, reg_content, reg_type)
endfunction
nmap gPl :call Paste(v:register, "l", "P")<CR>
nmap gpl :call Paste(v:register, "l", "p")<CR>
nmap gPc :call Paste(v:register, "v", "P")<CR>
nmap gpc :call Paste(v:register, "v", "p")<CR>

