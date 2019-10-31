" Only care about RGB environments - otherwise any default colorscheme is fine.
if !&termguicolors && !has('gui_running')
  finish
endif

if exists('syntax_on')
  syntax reset
endif

let colors_name = 'mine'

set background=light

let s:none = 'NONE'
let s:bg = 'bg'
let s:fg = 'fg'
let s:bold = 'bold'
let s:inverse = 'inverse'

let s:black = '#1C1C1C'
let s:blackLight = '#444444'
let s:brown = '#af5f00'
let s:brownLight = '#aa7733'
let s:blue = '#0963B1'
let s:blueLight = '#CCE5FF'
let s:blueBright = '#82dbf2'
let s:green = '#008700'
let s:greenLight = '#D4EDDA'
let s:greenDark = '#87875F'
let s:grey = '#8A8A8A'
let s:greyLight = '#BCBCBC'
let s:greyBright = '#E2E3E5'
let s:red = '#FF0000'
let s:redLight = '#F8D7DA'
let s:yellow = '#FFDF00'
let s:yellowLight = '#ffffaf'
let s:yellowBright = '#FFF3CD'
let s:purple = '#5F5F87'
let s:purpleLight = '#8787AF'
let s:orange = '#FF8700'
let s:gold = '#87875F'

execute  'hi Normal        guibg='s:none' guifg='s:blackLight' gui='s:none

execute  'hi Comment       guibg='s:none' guifg='s:greyLight' gui='s:none
execute  'hi Constant      guibg='s:none' guifg='s:brown' gui='s:none
execute  'hi Error         guibg='s:redLight' guifg='s:none' gui='s:none
execute  'hi Identifier    guibg='s:none' guifg='s:green' gui='s:none
execute  'hi Ignore        guibg='s:none' guifg='s:bg' gui='s:none
execute  'hi PreProc       guibg='s:none' guifg='s:purple' gui='s:none
execute  'hi Special       guibg='s:none' guifg='s:green' gui='s:none
execute  'hi Statement     guibg='s:none' guifg='s:blue' gui='s:none
execute  'hi Operator      guibg='s:none' guifg='s:brownLight' gui='s:none
execute  'hi String        guibg='s:none' guifg='s:grey' gui='s:none
execute  'hi Todo          guibg='s:yellowLight' guifg='s:blackLight' gui='s:none
execute  'hi Type          guibg='s:none' guifg='s:none' gui='s:none
execute  'hi Underlined    guibg='s:none' guifg='s:none' gui='s:none

execute  'hi LineNr        guibg='s:greyLight' guifg='s:none' gui='s:none
execute  'hi NonText       guibg='s:none' guifg='s:grey' gui='s:none

execute  'hi Pmenu         guibg='s:greyLight' guifg='s:none' gui='s:none
execute  'hi PmenuSbar     guibg='s:grey' guifg='s:none' gui='s:none
execute  'hi PmenuSel      guibg='s:greenLight' guifg='s:none' gui='s:none
execute  'hi PmenuThumb    guibg='s:none' guifg='s:none' gui='s:none

execute  'hi ErrorMsg      guibg='s:redLight' guifg='s:none' gui='s:none
execute  'hi WarningMsg    guibg='s:yellowBright' guifg='s:none' gui='s:none
execute  'hi MoreMsg       guibg='s:greenLight' guifg='s:none' gui='s:none
execute  'hi ModeMsg       guibg='s:greenLight' guifg='s:none' gui='s:none
execute  'hi Question      guibg='s:greenLight' guifg='s:none' gui='s:none

execute  'hi TabLine       guibg='s:greyLight' guifg='s:none' gui='s:none
execute  'hi TabLineFill   guibg='s:greyLight' guifg='s:none' gui='s:none
execute  'hi TabLineSel    guibg='s:greenLight' guifg='s:none' gui='s:none

execute  'hi Cursor        guibg='s:none' guifg='s:none' gui='s:none
execute  'hi CursorLine    guibg='s:greyBright' guifg='s:none' gui='s:none
execute  'hi CursorLineNr  guibg='s:none' guifg='s:none' gui='s:none

execute  'hi helpLeadBlank guibg='s:none' guifg='s:none' gui='s:none
execute  'hi helpNormal    guibg='s:none' guifg='s:none' gui='s:none

execute  'hi StatusLine    guibg='s:greyLight' guifg='s:none' gui='s:none
execute  'hi StatusLineNC  guibg='s:greyLight' guifg='s:none' gui='s:none

execute  'hi Visual        guibg='s:yellow' guifg='s:none' gui='s:none
execute  'hi VisualNOS     guibg='s:greyLight' guifg='s:none' gui='s:none

execute  'hi FoldColumn    guibg='s:greyLight' guifg='s:none' gui='s:none
execute  'hi Folded        guibg='s:greyLight' guifg='s:none' gui='s:none

execute  'hi VertSplit     guibg='s:greyLight' guifg='s:none' gui='s:none
execute  'hi WildMenu      guibg='s:greenLight' guifg='s:none' gui='s:none

execute  'hi Function      guibg='s:none' guifg='s:green' gui='s:bold
execute  'hi Title         guibg='s:greenLight' guifg='s:green' gui='s:none

execute  'hi DiffAdd       guibg='s:greenLight' guifg='s:none' gui='s:none
execute  'hi DiffChange    guibg='s:yellowLight' guifg='s:none' gui='s:none
execute  'hi DiffDelete    guibg='s:redLight' guifg='s:none' gui='s:none
execute  'hi DiffText      guibg='s:redLight' guifg='s:none' gui='s:none

execute  'hi IncSearch     guibg='s:yellow' guifg='s:blackLight' gui='s:none
execute  'hi Search        guibg='s:yellowLight' guifg='s:blackLight' gui='s:none

execute  'hi Directory     guibg='s:none' guifg='s:blue' gui='s:none
execute  'hi MatchParen    guibg='s:redLight' guifg='s:none' gui='s:none

execute  'hi SpellBad      guibg='s:none' guifg='s:none' gui=underline guisp='s:redLight
execute  'hi SpellCap      guibg='s:none' guifg='s:none' gui=underline guisp='s:redLight
execute  'hi SpellLocal    guibg='s:none' guifg='s:none' gui=underline guisp='s:yellowLight
execute  'hi SpellRare     guibg='s:none' guifg='s:none' gui=underline guisp='s:blueLight

execute  'hi ColorColumn   guibg='s:greyLight' guifg='s:none' gui='s:none
execute  'hi SignColumn    guibg='s:greyLight' guifg='s:none' gui='s:none

" TODO:
execute 'hi QuickFixLine guibg='s:blueBright' guifg='s:blackLight' gui='s:none
" execute 'hi QuickFixLine guibg='s:bg' guifg='s:fg' gui='s:inverse
" execute 'hi QuickFixLine guibg='s:none' guifg='s:none' gui='s:none
" hi! QuickFixLine NONE
" hi! link QuickFixLine NONE 
" hi default QuickFixLine NONE 
" hi! link QuickFixLine Normal

execute 'hi qfFileName   guibg='s:none' guifg='s:blackLight' gui='s:none
execute 'hi qfSeparator  guibg='s:none' guifg='s:blackLight' gui='s:none
execute 'hi qfLineNr     guibg='s:none' guifg='s:blackLight' gui='s:none
execute 'hi qfError      guibg='s:none' guifg='s:blackLight' gui='s:none

execute 'hi MyStatusLineProject guibg='s:greyLight' guifg='s:none' gui='s:none
execute 'hi MyStatusLineDirectory guibg='s:greyLight' guifg='s:none' gui='s:none
execute 'hi MyStatuslineFile guibg='s:blueBright' guifg='s:none' gui='s:none

hi link Boolean            Constant
hi link Character          Constant
hi link Conceal            Normal
hi link Conditional        Statement
hi link Debug              Special
hi link Define             PreProc
hi link Delimiter          Special
hi link Exception          Statement
hi link Float              Number
hi link HelpCommand        Statement
hi link HelpExample        Statement
hi link Include            PreProc
hi link Keyword            Statement
hi link Label              Statement
hi link Macro              PreProc
hi link Number             Constant
" hi link Operator           Statement
hi link PreCondit          PreProc
hi link Repeat             Statement
hi link SpecialChar        Special
hi link SpecialComment     Special
hi link StorageClass       Type
hi link Structure          Type
hi link Tag                Special
hi link Typedef            Type

hi link htmlEndTag         htmlTagName
hi link htmlLink           String
hi link htmlSpecialTagName htmlTagName
hi link htmlTag            htmlTagName

hi link diffBDiffer        WarningMsg
hi link diffCommon         WarningMsg
hi link diffDiffer         WarningMsg
hi link diffIdentical      WarningMsg
hi link diffIsA            WarningMsg
hi link diffNoEOL          WarningMsg
hi link diffOnly           WarningMsg

hi link HelpIgnore Ignore
