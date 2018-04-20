finish
" A plugin for deoplete to get flow autocompletion functionality.
" NOTE: flow is not javascript - it needs to be compiled
NeoBundle 'steelsojka/deoplete-flow', 
      \ { 'build': { 'unix': 'npm install -g flow-bin' } }

let g:deoplete#sources#flow#flow_bin = 'flow'
