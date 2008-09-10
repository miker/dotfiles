" Vim color file

" Based on evening.vim

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "unlink"

hi Normal ctermbg=DarkGrey ctermfg=White guifg=White guibg=black

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg term=standout ctermbg=DarkRed ctermfg=White guibg=Red guifg=White
hi IncSearch term=reverse cterm=reverse gui=reverse
hi ModeMsg term=bold cterm=bold gui=bold
hi StatusLine term=reverse,bold cterm=bold ctermfg=white ctermbg=lightblue gui=bold guifg=white guibg=slateblue
hi StatusLineNC term=reverse ctermfg=darkgrey ctermbg=lightgrey guifg=grey70 guibg=grey40
hi VertSplit term=reverse cterm=reverse gui=reverse
hi Visual term=reverse ctermbg=black guibg=grey60
hi VisualNOS term=underline,bold cterm=underline,bold gui=underline,bold
hi DiffText term=reverse cterm=bold ctermbg=Red gui=bold guibg=Red
hi Cursor guibg=Green guifg=Black
hi lCursor guibg=Cyan guifg=Black
hi Directory term=bold ctermfg=LightCyan guifg=Cyan
hi LineNr term=underline ctermfg=Yellow guifg=Yellow
hi MoreMsg term=bold ctermfg=LightGreen gui=bold guifg=SeaGreen
hi NonText ctermfg=darkgrey guifg=grey30 guibg=grey10
hi Question term=standout ctermfg=LightGreen gui=bold guifg=Green
hi Search term=reverse ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi SpecialKey term=bold ctermfg=darkgrey guifg=grey30 guibg=grey10
hi Title term=bold ctermfg=LightMagenta gui=bold guifg=Magenta
hi WarningMsg term=standout ctermfg=LightRed guifg=Red
hi WildMenu term=standout cterm=bold ctermfg=white ctermbg=lightcyan guifg=black guibg=Yellow
hi Folded term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=LightGrey guifg=DarkBlue
hi FoldColumn term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Grey guifg=DarkBlue
hi DiffAdd term=bold ctermbg=DarkBlue guibg=DarkBlue
hi DiffChange term=bold ctermbg=DarkMagenta guibg=DarkMagenta
hi DiffDelete term=bold ctermfg=Blue ctermbg=DarkCyan gui=bold guifg=Blue guibg=DarkCyan
hi CursorColumn term=reverse ctermbg=Black guibg=grey40
hi CursorLine term=underline cterm=underline guibg=grey40
hi Pmenu ctermfg=lightgrey ctermbg=darkblue guifg=lightgrey guibg=darkblue
hi PmenuSel cterm=bold ctermfg=white ctermbg=lightcyan gui=bold guifg=white guibg=grey60
hi PmenuSbar ctermbg=darkgrey guibg=darkgrey
hi PmenuThumb ctermbg=lightgrey guibg=lightgrey

" Groups for syntax highlighting
hi Constant term=underline ctermfg=Magenta guifg=lightred guibg=grey20
hi Special term=bold ctermfg=LightRed guifg=Orange guibg=grey5
hi PreProc guifg=lightblue
hi Comment guifg=#a0bac2 guibg=#202c2c

if &t_Co > 8
  hi Statement term=bold cterm=bold ctermfg=Yellow guifg=#ffff60 gui=bold
endif
hi Ignore ctermfg=DarkGrey guifg=grey20

" vim: sw=2
