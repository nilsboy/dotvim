" Tern plugin for Vim
NeoBundleLazy 'marijnh/tern_for_vim', {
  \ 'autoload': { 'filetypes': ['javascript'] },
  \ 'build': {
    \ 'unix': 'npm install',
  \ },
\ }

let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'
