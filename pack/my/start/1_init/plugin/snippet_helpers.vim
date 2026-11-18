"" snippet_helpers.vim: vimscript ports of the python helpers that used to
"" live in pythonx/snippet_helpers.py (+ file-local ones), for use from
"" snippet interpolations: `!v SnClassName()` etc.
"" t[n]-style helpers read b:snippetary_t (expand-time tabstop contents,
"" provided by the snippetary engine); basename/filename helpers read the
"" buffer being expanded in.
"" All regexes use \C and explicit [A-Za-z0-9_] classes: python \w/\W are
"" ASCII word characters / non-word characters, while the \w and \W
"" equivalents follow the user's 'iskeyword' (often extended with -, $,
"" ...), which would change behavior depending on the buffer.
"" The python semantics of the stripped classes:
""   \w  = [A-Za-z0-9_]     \W = everything else ('-' is \W, '_' is \w)

" ===== basename / filename =====

func! SnBaseName() abort
    return fnamemodify(expand('%'), ':t:r')
endfunc

" ===== case conversions =====

" python str.title(): every [a-zA-Z0-9] run gets its first char
" uppercased and the rest lowercased ('foo-bar' -> 'Foo-Bar')
func! s:TitleCase(v) abort
    return substitute(a:v, '\C\([a-zA-Z0-9]\)\([a-zA-Z0-9]*\)', '\U\1\L\2', 'g')
endfunc

func! SnToCamelCase(v) abort
    " python: re.sub(r'.*/', r'', v), drop all \W after title()
    " (v may also be given as a tabstop number: SnToCamelCase(1))
    let val = type(a:v) ==# type(0) ? SnT(a:v) : a:v
    let val = substitute(val, '\v\C.*/', '', '')
    return substitute(s:TitleCase(val), '\v\C[^A-Za-z0-9_]', '', 'g')
endfunc

func! SnToMethodCase(v) abort
    " python: strip the extension (up to the LAST dot), drop '.' and '/'
    " anywhere, lower the first char of the title-cased rest
    " (v may also be given as a tabstop number: SnToMethodCase(1))
    let val = type(a:v) ==# type(0) ? SnT(a:v) : a:v
    let val = substitute(val, '\v\C(.+)\.[^.]+$', '\1', '')
    let val = substitute(val, '\v\C[./]', '', 'g')
    let t = substitute(s:TitleCase(val), '\v\C[^A-Za-z0-9_]', '', 'g')
    return tolower(strpart(val, 0, 1)) . strpart(t, 1)
endfunc

func! SnToSnakeCase(v) abort
    let v = substitute(a:v, '\C\([a-zA-Z0-9]\)\([A-Z][a-z]\+\)', '\1_\2', 'g')
    return tolower(substitute(v, '\C\([a-z0-9]\)\([A-Z]\)', '\1_\2', 'g'))
endfunc

func! SnToSnailCase(v) abort
    let v = substitute(a:v, '\C\([a-zA-Z0-9]\)\([A-Z][a-z]\+\)', '\1-\2', 'g')
    return tolower(substitute(v, '\C\([a-z0-9]\)\([A-Z]\)', '\1-\2', 'g'))
endfunc

" ===== basename-based (was: className(snip) etc.) =====

func! SnClassName() abort
    " python: first char uppercased, the rest kept as-is
    let v = SnBaseName()
    return toupper(strpart(v, 0, 1)) . strpart(v, 1)
endfunc

func! SnClassNameSing() abort
    return substitute(SnClassName(), 'Contexts$', 'Context', '')
endfunc

func! SnClassNameNoCtx() abort
    return substitute(SnClassName(), 'Context$', '', '')
endfunc

func! SnFncC() abort
    " python fncc(): toCamelCase(cfname(basename)) - cfname() \W -> '_'
    " keeps '_' (python \w includes it), so the result ends up
    " 'My_Thing'-style
    let v = tolower(substitute(SnBaseName(), '\C[^A-Za-z0-9_]', '_', 'g'))
    let v = substitute(v, '^my_', '', '')
    let v = substitute(v, '^vim_', '', '')
    let v = substitute(v, '_vim$', '', '')
    return SnToCamelCase('My_' . v)
endfunc

" ===== t[n]-style (b:snippetary_t from the engine) =====

" text of tabstop n at expand time (the t[n] analog)
func! SnT(n) abort
    return get(get(b:, 'snippetary_t', {}), string(a:n), '')
endfunc

" python enum(t, opts): filter opts that start with the typed text; a
" single survivor wins, otherwise the full cycle list
func! SnEnum(n, opts) abort
    let t = SnT(a:n)
    let opts = t ==# '' ? a:opts
                \ : filter(copy(a:opts), 'v:val =~# "^" . escape(t, "\\")')
    return len(opts) == 1 ? opts[0] : join(a:opts, '|')
endfunc

" python compB(t, opts) (json.snippets): like enum(), but multi survivors
" render as a (toggled) choice hint and a single survivor is inserted
func! SnCompB(n, opts) abort
    let t = SnT(a:n)
    let opts = t ==# '' ? a:opts
                \ : filter(copy(a:opts), 'v:val =~# "^" . escape(t, "\\")')
    return len(opts) == 1 ? opts[0] : '(' . join(opts, '|') . ')'
endfunc

func! SnLcFirst(n) abort
    let t = SnT(a:n)
    return tolower(strpart(t, 0, 1)) . strpart(t, 1)
endfunc

" javascript 'new' snippet: first char lowered of the camel-cased name
" (python: t[1][0:1].lower() + re.sub(r'(\W)', r'', t[1].title()[1:]))
func! SnLcCamel(n) abort
    let t = substitute(s:TitleCase(SnT(a:n)), '\C[^A-Za-z0-9_]', '', 'g')
    return tolower(strpart(t, 0, 1)) . strpart(t, 1)
endfunc

" html attribute glue: emit text only when the tabstop is non-empty
func! SnIf(n, s) abort
    return SnT(a:n) !=# '' ? a:s : ''
endfunc

" help files: self-referencial *file-section* marker, right-aligned so it
" ends in column 78 minus the typed text width (python sec_title). The
" expansion-time approximation uses the placeholder default text.
func! SnSecTitle(n) abort
    let file_start = matchstr(fnamemodify(expand('%'), ':t'), '^[^.]*')
    let t1 = SnT(a:n)
    let sec = tolower(substitute(substitute(t1, '[1234567890. ]', '', 'g'), ' ', '-', 'g'))
    let title = '*' . file_start . '-' . sec . '*'
    let pad = max([0, (78 - strlen(t1)) - strlen(title)])
    return repeat(' ', pad) . title
endfunc

" html.snippets x(snip): a trailing self-closing slash only for xhtml
func! SnHtmlSlash() abort
    return &filetype =~# '^x' ? '/' : ''
endfunc

" all.snippets b64: run base64-my over the ${VISUAL} text
func! SnBase64Visual() abort
    return substitute(system('base64-my ' . shellescape(get(b:, 'snippetary_visual', ''))), '\r\?\n$', '', '')
endfunc
