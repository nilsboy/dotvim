finish " #######################################################################
" asynchronous build and test dispatcher
NeoBundle 'tpope/vim-dispatch'
" NOTE: See neomake instead
" NOTE: Needed by vim-test to set compiler

" Notes 2016-11
" - Can not open quickfix after Dispatch! is done
" - When using Dispatch in the foreground a tmux window pops up.
"   So it's not usefull if you don't want to see the output during its
"   execution.
