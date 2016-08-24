finish
" TODO checkout
" See also ~/bin/sqlbench-setup
" SQL For Vim (provides access from VIM to any DBMS, like dbext)
NeoBundle 'cosminadrianpopescu/vim-sql-workbench', {
            \'depends': 'vim-dispatch',
            \'lazy': 1,
            \'on_ft': 'sql',
            \}

" TODO add build option

SWServerStart 5000
