scriptencoding utf-8
" ----------------------------------------------------------------------------
" File:     ~/.vimrc
" Author:   Greg Fitzgerald <netzdamon@gmail.com>
" Modified: Tue 29 Feb 2010 01:22:55 PM EDT
" ----------------------------------------------------------------------------

" {{{ Settings
" Set encoding
set encoding=utf-8 nobomb    " BOM often causes trouble
" Turn On word-wrapping
set wrap
" autoident
set autoindent
" Turn off backups
set backup
" Turn off swapfile
set noswapfile
" Soft tab 4
set sw=4
" Soft tab stop
set sts=4
" Tab stop
set ts=4
" Show mode
set showmode
" Expand tabs to spaces
set expandtab
" Backups directory if on
set backupdir=~/.backups/
" Line breaks for linewrap
set linebreak
" Backspace over everything
set bs=2
" Auto indent
set autoindent
" No startup messages
set shm+=atmI
" Show matching brackets
set showmatch
" Temporary directory
set dir=~/.tmp/vim/
" Universal clipboard
set clipboard=unnamed
" Movement keys for wrapping
set ww+=<,>,[,]
" Allow unsaved hidden buffers
set nohidden
" I like darkbackgrounds with light colors
set background=dark
" Never let a window be less than 1px
set winminheight=1
" Show last command
set showcmd
" Nice big viminfo file
set viminfo='1000,f1,:1000,/1000
" History size
set history=1000
" Default fileformat
set fileformat=unix
" Display list of matching files for completion
set wildmode=list:longest " Display list of matching files for completion
" character to show that a line is wrapped
set showbreak=>
" Characters to break at for line wrapping
set breakat=\ ^I!@*-+;:,./?
" Do not stay vi compatible
set nocompatible
" Enable wild menu
set wildmenu
" Smart tab
set smarttab
" override ignorecase when there are uppercase characters
set smartcase
" Buffer updates
set lazyredraw
" Faster scrolling updates when on a decent connection.
set ttyfast
" Print line numbers and syntax highlighting
set printoptions+=syntax:y,number:y
" improves performance -- let OS decide when to flush disk
set nofsync
" ruler
set ruler
set undolevels=999
" ignore these in auto complete
set wildignore+=.svn,CVS,.git,*.o,*.a,*.class,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.info,.aux,.log,.dvi,..out
set cmdheight=2
set showtabline=1               " display tabbar
" Set some global options for spell check
set spelllang=en_us
set spellfile=~/.vim/spell/spellfile.add
set switchbuf=usetab
set scrolloff=2 " minlines to show around cursor
set sidescrolloff=4 " minchars to show around cursor
" Search
set wrapscan   " search wrap around the end of the file
set ignorecase " ignore case search
set smartcase  " override 'ignorecase' if the search pattern contains upper case
set incsearch  " incremental search
set hlsearch   " highlight searched words


" {{{ Set a shell
set shell=sh
" }}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
  let is_bash=1
endif
" }}}

" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        if has("gui_running")
            set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
        else
            " xterm + terminus hates these
            set list listchars=tab:»·,trail:·,extends:>,nbsp:_
        endif
    else
        set list listchars=tab:»·,trail:·,extends:…
    endif
else
    if v:version >= 700
        set list listchars=tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:>-,trail:.,extends:>
    endif
endif


"Include $HOME in cdpath
if has("file_in_path")
    let &cdpath=','.expand("$HOME").','.expand("$HOME").'/code'
endif

" Enable fancy % matching
if has("eval")
    runtime! macros/matchit.vim
endif

" enable syntax highlightning (must come after autocmd!)
" vim-tiny doesn't support syntax
if has("syntax")
    syntax on
endif
" }}}

" {{{ Enable folding
set nofoldenable
set foldmethod=marker
"set foldlevelstart=0
set foldnestmax=3       "deepest fold is 3 levels
" }}}

" {{{iabbrev
iabbrev xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

iabbrev #p #!/usr/bin/perl
iabbrev #e #!/usr/bin/env
iabbrev #r #!/usr/bin/ruby
iabbrev #b #!/bin/bash

iabbrev sdef definitely
" }}}

" {{{ Plugin settings

" rails.vim
let g:rails_dbext=1
let g:rails_default_database='sqlite3'
let g:rails_gnu_screen=1
let g:rails_mappings=1
let g:rails_statusline=1
let g:rails_subversion=0
let g:rails_syntax=1
let g:browser = 'firefox -new-tab '

" Supertab
let g:SuperTabMappingForward = '<S-Tab>'
let g:SuperTabLongestHighlight = 1
let g:SuperTabMidWordCompletion = 1
let g:SuperTabRetainCompletionType = 1

" Settings for NERDCommenter
let g:NERDShutUp=1
" Settings for git status bar plugin
let g:git_branch_status_head_current=1
" NERDTree settings
let NERDChristmasTree = 1
let NERDTreeQuitOnOpen = 0
let NERDTreeHighlightCursorline = 1
let NERDTreeMapActivateNode='<CR>'
let g:NERDTreeChDirMode = 1
let NERDTreeIgnore=['\.git','\.DS_Store', '\.svn', '\.cvs', '\.log']

" Append status line if enough room
let g:fastgit_statusline = 'a'

let g:gist_clip_command = 'xclip -selection clipboard'

let g:git_branch_status_nogit=""

let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1


" Hightlight redundent spaces
highlight RedundantSpaces ctermbg=red guibg=red
match     RedundantSpaces /\s\+$\| \+\ze\t/

" Disable modelines, use securemodelines.vim instead
set nomodeline
let g:secure_modelines_verbose = 0
let g:secure_modelines_modelines = 15

let g:secure_modelines_allowed_items = [
            \ "textwidth",   "tw",
            \ "softtabstop", "sts",
            \ "tabstop",     "ts",
            \ "shiftwidth",  "sw",
            \ "expandtab",   "et",   "noexpandtab", "noet",
            \ "filetype",    "ft",
            \ "foldmethod",  "fdm",
            \ "readonly",    "ro",   "noreadonly", "noro",
            \ "rightleft",   "rl",   "norightleft", "norl"
            \ ]
" }}}

" {{{ Nice statusbar
"statusline setup
set statusline=%f       "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag

" display current git branch
set statusline+=%{GitBranchInfoString()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

" }}}

" {{{ Window title
if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                                              " file name
    set titlestring+=%h%m%r%w                                         " flags
    set titlestring+=\ -\ %{v:progname}                               " program name
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}  " working directory
endif

"highlight the current line
if v:version > 700
    set cursorline
    hi Cursorline ctermbg=Red guibg=#771c1c
else
    syntax match CurrentLine /.*\%#.*/
    hi CurrentLine guifg=white guibg=lightblue
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
    set fileencodings+=utf-8
else
    set fileencodings+=default
endif

" {{{ Terminal fixes
if &term ==? "xterm" || &term  ==? "rxvt"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif

" }}}

" {{{ Key maps

" Set map leader to ,
let mapleader = ","
noremap <silent> <C-z> :undo<CR>
noremap <silent><C-L> :NERDTreeToggle<CR>
map <leader>nh :nohls <CR>
nmap <silent> <C-H> :silent nohls<CR>
noremap <Leader>res :call Restart()<CR>
noremap <silent> <C-F12> :call UpdateDNSSerial()<CR>
noremap <Leader>ss :call StripTrailingWhitespace()<CR>
" Setup mini ide for a project of mine
noremap <Leader>md :call Mideo()<CR>
noremap <Leader>at :call Athenry()<CR>
noremap <Leader>sw :call Swindle()<CR>
noremap <Leader>sa :call Sass()<CR>
" Reformat everything
noremap <Leader>gq gggqG
" Reformat paragraph
noremap <Leader>gp gqap
" Clear lines
noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>
" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>
" Don't make a # force column zero.
inoremap # X<BS>#
noremap <Leader>rr :w\|!ruby %<cr>
noremap <Leader>rb :w\|!bash %<cr>
noremap <Leader>xd :w\|!xrdb -load ~/.Xdefaults %<cr>
noremap <Leader>p :set paste<CR>
noremap <Leader>nu :set invnumber<CR>
noremap <Leader>sp :set spell<CR>
noremap <Leader>nsp :set nospell<CR>
noremap <Leader>pp :s/:/ /g<CR>:nohl<CR>
noremap <Leader>cache :call ClearCache()<CR>
noremap <Leader>doc :!rake documentation:generate<CR>
noremap :close :bd!<CR>
" Quick sudo saving from tpope
command! -bar -nargs=0 SudoW :silent exe "write !sudo tee % >/dev/null" | silent edit!
noremap <Leader>su :SudoW<CR>
command! -nargs=+ PopupMap call s:popupMap(<f-args>)

" This group is stolen from mislav's vimrc
" http://github.com/mislav/dotfiles/blob/master/vimrc

" Format the current paragraph according to
" the current 'textwidth' with CTRL-J:
nmap <C-J> gqap
vmap <C-J> gq
imap <C-J> <C-O>gqap

" Delete line with CTRL-K
map <C-K> dd
imap <C-K> <C-O>dd

" Use CTRL-S for saving, also in Insert mode
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

nnoremap <silent> <C-f> :call FindInNERDTree()<CR>

noremap <leader>q ZQ
noremap <leader>qa :qa<CR>

" convert word into ruby symbol
imap <C-k> <C-o>b:<Esc>Ea
nmap <C-k> lbi:<Esc>E

" bind control-l to hashrocket
imap <C-l> <Space>=><Space>"
" Hide search highlighting
map <Leader>h :set invhls <CR>

" Leader shortcuts for Rails commands
map <Leader>m :Rmodel
map <Leader>c :Rcontroller
map <Leader>v :Rview
map <Leader>u :Runittest
map <Leader>f :Rfunctionaltest
map <Leader>tm :RTmodel
map <Leader>tc :RTcontroller
map <Leader>tv :RTview
map <Leader>tu :RTunittest
map <Leader>tf :RTfunctionaltest
map <Leader>sm :RSmodel
map <Leader>sc :RScontroller
map <Leader>sv :RSview
map <Leader>su :RSunittest
map <Leader>sf :RSfunctionaltest

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vmap P p :call setreg('"', getreg('0')) <CR>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" }}}

" {{{ Functions

function UseRubyIndent ()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal expandtab
    setlocal autoindent

    imap <buffer> <CR> <C-R>=PMADE_RubyEndToken()<CR>
endfunction

" Shift-Enter inserts 'end' for ruby scripts
" Copyright (C) 2005-2007 pmade inc. (Peter Jones pjones@pmade.com)
function PMADE_RubyEndToken ()
    let current_line = getline('.')
    let braces_at_end = '{\s*\(|\(,\|\s\|\w\)*|\s*\)\?\(\s*#.*\)\?$'
    let stuff_without_do = '^\s*\<\(class\|if\|unless\|begin\|case\|for\|module\|while\|until\|def\)\>'
    let with_do = '\<do\>\s*\(|\(,\|\s\|\w\)*|\s*\)\?\(\s*#.*\)\?$'

    if getpos('.')[2] < len(current_line)
        return "\<CR>"
    elseif match(current_line, braces_at_end) >= 0
        return "\<CR>}\<C-O>O"
    elseif match(current_line, stuff_without_do) >= 0
        return "\<CR>end\<C-O>O"
    elseif match(current_line, with_do) >= 0
        return "\<CR>end\<C-O>O"
    else
        return "\<CR>"
    endif
endfunction

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

command! -nargs=0 RDocPreview call RDocRenderBufferToPreview()

function! RDocRenderBufferToPreview()
  let rdocoutput = "/tmp/vimrdoc/"
  call system("rdoc " . bufname("%") . " --op " . rdocoutput)
  call system("firefox ". rdocoutput . "index.html")
endfunction

"If possible, try to use a narrow number column.
if v:version >= 700
    try
        setlocal numberwidth=2
    catch
    endtry
endif

if (version >= 700)
    set completeopt=menu,longest,preview
    map :bn :tabn
    map :bp :tabp
    set showtabline=2
    set tabline=%!MyTabLine()

    function MyTabLabel(n)
        let buflist = tabpagebuflist(a:n)
        let winnr = tabpagewinnr(a:n)
        let bufname = bufname(buflist[winnr - 1])

        if !strlen(bufname)
            let bufname = '(nil)'
        endif

        let label = ''
        " Add '+' if one of the buffers in the tab page is modified
        let bufnr = 0
        while bufnr < len(buflist)
            if getbufvar(buflist[bufnr], "&modified")
                let label = '+'
                break
            endif
            let bufnr = bufnr + 1
        endwhile
        if !strlen(label)
            let label = ' '
        endif
        let label .= bufname
        return label
    endfunction

    function MyTabLine()
        let s = ''
        let i = 1
        while i <= tabpagenr('$')
            " select the highlighting
            if i == tabpagenr()
                let s .= '%#TabLineSel#'
            else
                let s .= '%#TabLine#'
            endif

            " set the tab page number (for mouse clicks)
            let s .= '%' . i . 'T'

            " the label is made by MyTabLabel()
            let s .= ' %{MyTabLabel(' . i . ')} '

            let i = i + 1
        endwhile

        " after the last tab fill with TabLineFill and reset tab page nr
        let s .= '%#TabLineFill#%T'
        return s
    endfunction
endif

" Update header
fun! <SID>UpdateRcHeader()
    let l:c=col(".")
    let l:l=line(".")
    silent 1,10 s/\(Modified:\).*/\="Modified: ".strftime("%c")/
    call cursor(l:l, l:c)
endfun

if has("eval")
    " If we're in a wide window, enable line numbers.
    fun! <SID>WindowWidth()
        if winwidth(0) > 90
            setlocal foldcolumn=0
            setlocal number
        else
            setlocal nonumber
            setlocal foldcolumn=0
        endif
    endfun
endif

function Athenry()
    chdir /home/gregf/code/projects/active/athenry/
    open TODO.md
    NERDTreeFromBookmark athenry
endfunction

function Swindle()
    chdir /home/gregf/code/projects/active/swindle/
    open TODO.mkd
    NERDTreeFromBookmark swindle
endfunction

function Mideo()
    chdir /home/gregf/code/projects/active/mideo/
    open TODO
    NERDTreeFromBookmark mideo
endfunction

function Sass()
    chdir /home/gregf/rewrite/blueprint/
    NERDTree
endfunction

function ClearCache()
    !rm -rf public/cache/*
endfunction

function Restart()
    !touch $PWD/tmp/restart.txt
endfunction

" Removes unnecessary whitespace
function StripTrailingWhitespace()
    %s/[ \t]\+$//ge
    %s!^\( \+\)\t!\=StrRepeat("\t", 1 + strlen(submatch(1)) / 8)!ge
endfunction

function RemoveBlankLines()
    %s/^[\ \t]*\n//g
endfunction

" }}}

" {{{ auto commands

if isdirectory(expand("$VIMRUNTIME/ftplugin"))
    if has("eval")
        filetype on
        filetype plugin on
        filetype indent on
    endif
endif


if has("autocmd")
    au VimEnter * nohls
    au VimLeave * set nospell

    " Automagic line numbers
    autocmd BufEnter * :call <SID>WindowWidth()

    " Always do a full syntax refresh
    autocmd BufEnter * syntax sync fromstart

    "recalculate the tab warning flag when idle and after writing
    autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

    autocmd BufWritePre .Xdefaults :!xrdb -load ~/.Xdefaults

    autocmd BufWritePre *.cpp,*.hpp,*.i,
                \ *.rb,*.pl,*.sh,*.bash,*.plx,
                \ *.ebuild,*.exheres-0,*.exlib,
                \ *.e{build,class} 
                \ :call StripTrailingWhitespace()

    " Gentoo-specific settings for ebuilds.  These are the federally-mandated
    " required tab settings.  See the following for more information:
    " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
    " Note that the rules below are very minimal and don't cover everything.
    " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
    " filetype and indent settings for all things Gentoo.
    autocmd BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
    autocmd BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

    " In text files, limit the width of text to 78 characters, but be careful
    " that we don't override the user's setting.
    autocmd BufNewFile,BufRead *.txt
                \ if &tw == 0 && ! exists("g:leave_my_textwidth_alone") |
                \     setlocal textwidth=78 |
                \ endif

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
                \ if ! exists("g:leave_my_cursor_position_alone") |
                \     if line("'\"") > 0 && line ("'\"") <= line("$") |
                \         exe "normal g'\"" |
                \     endif |
                \ endif

    " When editing a crontab file, set backupcopy to yes rather than auto. See
    " :help crontab and bug #53437.
    autocmd FileType crontab set backupcopy=yes
endif


" }}}

" {{{ GUI Options & Colorschemes

"improve autocomplete menu color
highlight pmenu ctermbg=238 gui=bold

if &term ==? 'xterm' || &term ==? 'screen' || &term ==? 'rxvt'
    set t_Co=256 " Let ViM know we have a 256 color capible terminal
    colorscheme candyman
else
    colorscheme jammy
endif

if (has("gui_running"))
    colorscheme two2tango
    "set guifont=Droid\ Sans\ Mono\ 12
    set guifont=inconsolata\ 14
    set mousem=popup 
    set selection=exclusive " Allow one char past EOL
    set ttymouse=xterm2 " Terminal type for mouse code recognition
    set mousehide
    " Make shift-insert work like in xterm
    map <S-Insert> <MiddleMouse>
    map! <S-Insert> <MiddleMouse>
    " set some gui options
    set guioptions=a
    set mouse=a
endif

"Extra terminal things
if &term ==? 'xterm' || &term ==? 'screen' || &term ==? 'rxvt' && (&termencoding == "")
    set termencoding=utf-8
    if has('title')
        set title
    endif
    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
        let &t_EI = "\<Esc>]12;grey80\x7"
    endif
endif

" Source local vimrc
if exists(expand("~/.vim/vimrc.local"))
    source ~/.vim/vimrc.local
endif

" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120 :
