" Snap has no PCRE support (2020-05-09)
" MyInstall rg pkexec snap install ripgrep --classic
MyInstall rg ripgrep-install

let &errorformat = '%f'

" let filenameTerm = '\Q' . fnameescape(path) . '\E' . '.*' . filenameTerm
let &makeprg = "rg --pcre2 --vimgrep --type-add 'javascript:*.js'"
      \ . ' --files'
      \ . ' ' . fnameescape('.')
