" Warn when n or N arrive back at the match that was visited first: a
" search run records the match it landed on (/c lands on c2 - that first
" match) as the origin of the cycle, a later press arriving back at (or
" crossing) the origin echoes a warning and highlights the visited match
" itself (WarningMsg) until the cursor moves again. The origin is kept
" until a new search is started, even when the cursor leaves the match
" position. Based on ~/search_wrap_warning.vim.
"
" Lives in after/plugin/ so that the n/N mappings below override the ones
" from plugins, e.g. <Plug>(incsearch-nohl-n) mapped in
" pack/my/start/2_plugin_config/plugin/incsearch.vim.
"
" Fixes compared to ~/search_wrap_warning.vim:
" - the press count is respected, e.g. 3n moves three matches at once
" - a cycle origin from another buffer resets (the buffer is stored with
"   the origin and compared)

let g:search_wrap_active = 0
let g:search_wrap_start = []
let g:search_wrap_match = -1
let g:search_wrap_pattern = ''
" Fixed id for the highlight match, replaces it on re-fire and cleans up
" leftovers from an earlier load of this script
let g:search_wrap_match_id = 2000002
silent! call matchdelete(g:search_wrap_match_id)
" Position of the arrival, to keep the warning for the move that caused
" it, some events for it may arrive deferred after the match was placed;
" the origin itself is remembered until a new search is started even when
" the cursor leaves the match position
let g:search_wrap_pos = []
let g:search_wrap_buf = -1

function! ClearSearchWrapWarning() abort
    if !g:search_wrap_active
        return
    endif

    let g:search_wrap_active = 0
    echo ''

    if g:search_wrap_match != -1
        call matchdelete(g:search_wrap_match)
        let g:search_wrap_match = -1
        silent! call matchdelete(g:search_wrap_match_id)
    endif
endfunction

function! SearchWithWrapWarning(forward, ...) abort
    if a:0 > 0
        let l:count = a:1
    else
        let l:count = 1
    endif

    call ClearSearchWrapWarning()

    let l:start = getpos('.')
    let l:flags = a:forward ? '' : 'b'

    " Search for next match, allowing wrapping.
    for l:i in range(l:count)
        let l:result = search(@/, l:flags)
        if l:result == 0
            return
        endif
    endfor

    let l:current = getpos('.')

    " Start a cycle when the pattern or the buffer changed (a new search
    " resets the cycle earlier, see CmdlineEnter below): the position the
    " cursor had then is the origin of the cycle, the first match of the
    " search run landed on by /, ?, *, #. Visiting it for the second time
    " warns. The origin is remembered even when the cursor leaves the
    " match position.
    let l:new_cycle = g:search_wrap_pattern !=# @/
                \ || empty(g:search_wrap_start)
                \ || g:search_wrap_start[0] != bufnr('%')
    if l:new_cycle
        let g:search_wrap_start = l:start
        " getpos('.') has 0 as bufnum for '.', store the real buffer number
        let g:search_wrap_start[0] = bufnr('%')
        let g:search_wrap_pattern = @/
        return
    endif

    let l:origin = g:search_wrap_start

    " Detect arriving back at the origin or crossing the original
    " starting position.
    let l:reached_start = l:current[1] == l:origin[1] && l:current[2] == l:origin[2]
                \ || (a:forward
                \ ? (l:start[1] < l:origin[1]
                \   || (l:start[1] == l:origin[1]
                \       && l:start[2] < l:origin[2]))
                \   && (l:current[1] > l:origin[1]
                \   || (l:current[1] == l:origin[1]
                \       && l:current[2] >= l:origin[2]))
                \ : (l:start[1] > l:origin[1]
                \   || (l:start[1] == l:origin[1]
                \       && l:start[2] > l:origin[2]))
                \   && (l:current[1] < l:origin[1]
                \   || (l:current[1] == l:origin[1]
                \       && l:current[2] <= l:origin[2])))

    if l:reached_start
        let g:search_wrap_active = 1
        let g:search_wrap_pos = getpos('.')
        let g:search_wrap_buf = bufnr('%')

        echohl WarningMsg
        echo 'Search completed a full cycle'
        echohl None

        " Highlight the visited match itself (the one under the cursor) until
        " the cursor moves again; anchored to the exact arrival position,
        " cursor anchors (\%#) are not supported in match patterns
        let l:pos = getpos('.')
        silent! call matchdelete(g:search_wrap_match_id)
        let g:search_wrap_match = matchadd('WarningMsg',
                    \ '\%'.l:pos[1].'l\%'.l:pos[2].'c\%('.@/.'\)', 10, g:search_wrap_match_id)
    endif
endfunction

function! CheckSearchWrapMovement() abort
    if !g:search_wrap_active
        return
    endif

    " Keep the warning for the movement to the arrival position, its events
    " may arrive deferred, clear only on a different position or buffer.
    if bufnr('%') != g:search_wrap_buf
                \ || getpos('.')[1:2] != g:search_wrap_pos[1:2]
        call ClearSearchWrapWarning()
    endif
endfunction

function! s:onSearchStarted() abort
    " A new search resets the cycle, even with the same pattern
    if getcmdtype() == '/' || getcmdtype() == '?'
        let g:search_wrap_start = []
        let g:search_wrap_pattern = ''
        call ClearSearchWrapWarning()
    endif
endfunction

augroup SearchWrapWarning
    autocmd!
    autocmd CursorMoved,CursorMovedI * call CheckSearchWrapMovement()
    autocmd CmdlineEnter * call s:onSearchStarted()
augroup END

nnoremap <silent> n :<C-u>call SearchWithWrapWarning(1, v:count1)<CR>
nnoremap <silent> N :<C-u>call SearchWithWrapWarning(0, v:count1)<CR>
