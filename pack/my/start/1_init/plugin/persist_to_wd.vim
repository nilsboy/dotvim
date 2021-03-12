" Persist marks etc to working directory.
" Needs to be loaded before some plugins.

if exists("persist_to_wd#loaded")
  finish
endif
let persist_to_wd#loaded = 1

if ! nb#isNeovim()
  " use viminfo for vim?
  finish
endif

if ! isdirectory('.git')
  finish
endif
let &shadafile = getcwd() .. '/.git/vim.shada'

set shada='100,%
