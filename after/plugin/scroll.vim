" https://www.reddit.com/r/vim/comments/4a4b1j/vim_porn_2_post_your_vim_screenshots/d0xam5d?st=itfuckf9&sh=ab73b30b
function! s:scroll()
    let l:save = &scrolloff

    set scrolloff=0 noscrollbind nowrap nofoldenable
    botright vsplit

    normal L
    normal j
    normal zt

    setlocal scrollbind
    exe "normal \<c-w>p"
    setlocal scrollbind

    let &scrolloff = l:save
endfun
command! Scroll call s:scroll()
