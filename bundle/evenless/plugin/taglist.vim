if executable('ctags')

    map <silent> <c-o> :call My_TagList()<CR>gg/

    function My_TagList()

        exe ":TlistToggle"
        exe ":TlistUpdate"

        noremap <buffer> <esc> <esc>:q<cr>

    endfunction

    let Tlist_GainFocus_On_ToggleOpen = 1
    let Tlist_Close_On_Select = 1
    let Tlist_Compact_Format = 1
    let Tlist_Exit_OnlyWindow = 1
    let Tlist_Auto_Highlight_Tag = 1
    let Tlist_Highlight_Tag_On_BufEnter = 1
    let Tlist_Inc_Winwidth = 0
    let Tlist_Auto_Update = 1
    let Tlist_Display_Tag_Scope = 0
    let Tlist_Sort_Type = "name"

else

    let loaded_taglist = 'no'

endif
