scriptencoding utf-8
"-----------------------------------------------------------------------
" Vim settings file for Greg Fitzgerald
" Most recent update: Fri 10 Oct 2008 05:24:41 PM EDT
"-----------------------------------------------------------------------

"-----------------------------------------------------------------------
" Settings
"-----------------------------------------------------------------------

" Turn Off word-wrapping
set wrap
" Turn off backups
set nobackup
" Turn off swapfile
set noswapfile
" Soft tab 4
set sw=4
" Soft tab stop
set sts=4
" Tab stop
set ts=4
" wrapping
set wm=4
set tw=80
" Expand tabs to spaces
set expandtab
" Highlight search
set hlsearch
" Backup extension if on
set backupext=.bak
" Backups directory if on
set backupdir=~/.backups/
" Line breaks for linewrap
set linebreak
" Backspace over everything
set bs=2
" Case-insensitive search
set ignorecase
" Auto indent
set autoindent
" No startup messages
set shm+=Im
" Use c indenting rules rather than smartindent
set cindent
" Show matching brackets
set showmatch
" Temporary directory
set dir=~/.tmp/vim/
" Universal clipboard
set clipboard=unnamed
" Movement keys for wrapping
set ww+=<,>,[,]
" Allow unsaved hidden buffers
set hidden
" I like darkbackgrounds with light colors
set background=dark
" Never let a window be less than 1px
set winminheight=1
" Show last command
set showcmd
" Nice big viminfo file
set viminfo='1000,f1,:1000,/1000
" History size
set history=900
" Default fileformat
set fileformat=unix
" Display list of matching files for completion
set wildmode=list:longest	" Display list of matching files for completion
" Do not require end-of-line
set noeol
" Characters to break at for line wrapping
set breakat=\ \	!@*-+;:,.?
" Number of lines to jump when cursor reaches bottom
"set scrolloff=5
" Same thing for horizontal
"set sidescroll=5
" Override ignorecase if search has capital letters
"set smartcase
" No visual/audio bells
"set vb t_vb=
set visualbell
" Do not stay vi compatible
set nocompatible
" Default encoding
set encoding=utf-8
" Enable wild menu
set wildmenu
" Smart tab
set smarttab
" Buffer updates
set lazyredraw
" Faster scrolling updates when on a decent connection. 
set ttyfast
" Print line numbers and syntax highlighting
set printoptions+=syntax:y,number:y
" improves performance -- let OS decide when to flush disk
set nofsync
" start the scrolling three lines before the border
set scrolloff=3
" Don't prompt me for crap
set shortmess=atI
" ruler
set ruler
" ignore these in auto complete
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

"-----------------------------------------------------------------------
" Plugin settings
"-----------------------------------------------------------------------

"Settings for HiMTCHBrkt
let g:HiMtchBrkt_surround= 1
let g:HiMtchBrktOn= 1
" Settings for NERDCommenter
let g:NERDShutUp=1
" Settings for git status bar plugin
let g:git_branch_status_head_current=1

" Hightlight redundent spaces
highlight RedundantSpaces ctermbg=red guibg=red
match     RedundantSpaces /\s\+$\| \+\ze\t/

" Disable modelines, use securemodelines.vim instead
set nomodeline
let g:secure_modelines_verbose = 0
let g:secure_modelines_modelines = 15

let loaded_matchparen=1

" http://vim.sourceforge.net/scripts/script.php?script_id=2328
let g:nickname = "gregf"

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

"-----------------------------------------------------------------------
" Nice statusbar
"-----------------------------------------------------------------------

set laststatus=2
set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name
if has("eval")
    let g:scm_cache = {}
    fun! ScmInfo()
        let l:key = getcwd()
        if ! has_key(g:scm_cache, l:key)
            if (isdirectory(getcwd() . "/.git"))
                let g:scm_cache[l:key] = "[" . substitute(readfile(getcwd() . "/.git/HEAD", "", 1)[0],
                            \ "^.*/", "", "") . "] "
            else
                let g:scm_cache[l:key] = ""
            endif
        endif
        return g:scm_cache[l:key]
    endfun
    set statusline+=%{ScmInfo()}             " scm info
endif
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset


" Nice window title
if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                                              " file name
    set titlestring+=%h%m%r%w                                         " flags
    set titlestring+=\ -\ %{v:progname}                               " program name
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}  " working directory
endif

"If possible, try to use a narrow number column.
if v:version >= 700
    try
        setlocal numberwidth=3
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

"Update .*rc header
fun! <SID>UpdateRcHeader()
    let l:c=col(".")
    let l:l=line(".")
    silent 1,10s-\(Most recent update:\).*-\="Most recent update: ".strftime("%c")-e
    call cursor(l:l, l:c)
endfun

""-----------------------------------------------------------------------
"" Key maps
""-----------------------------------------------------------------------

map		:W :w
map		:WQ :wq
map		:wQ :wq
map		:Q :q
nmap <C-N> :tabn<CR>
nmap <C-P> :tabp<CR>
noremap <silent> <C-O> :FuzzyFinderTextMate<CR>
noremap <silent> <F7> :Tlist<CR>
noremap <silent> <F8> :FuzzyFinderMruFile<CR>
noremap <silent> <F9> :NERDTreeToggle<CR>
noremap <silent> <F10> :call <SID>Restart()<CR>
noremap <silent> <C-F12> :call UpdateDNSSerial()<CR>
"cmap w! %!sudo tee > /dev/null %
" Spell check
noremap <silent> <F1> z=
" Spell Check (Reverse)
noremap <silent> <F2> zw
" Add word to word list
noremap <silent> <F3> zg
" Remove word from word list
noremap <silent> <F4> zug
" Split Window Movement
map <F6> :wincmd w<CR> imap <F6> <c-[>:wincmd w<CR> map <S-F6> :wincmd W<CR> imap <S-F6> <c-[>:wincmd W<CR>
" Setup mini ide for a project of mine
noremap <silent> <F5> :call Mideo()<CR>
" Setup a scratch buffer
noremap <silent> <S-I> :tabe scratch<CR>
" Refreshing the screen
map		<C-l>		     :redraw<CR> imap	<C-l>		<Esc>:redraw<CR>
" Set map leader to f12
let mapleader = "\<F12>"
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

""-----------------------------------------------------------------------
"" Functions
""-----------------------------------------------------------------------

if version >= 700
    au TabLeave * let g:MRUtabPage = tabpagenr()
    fun MRUTab()
        if exists( "g:MRUtabPage" )
            exe "tabn " g:MRUtabPage
        endif
    endfun
    noremap <silent> gl :call MRUTab()<Cr>
endif

function Mideo()
    chdir /home/gregf/mideo/
    open TODO
    NERDTreeFromBookmark mideo
endfunction

function <SID>Restart()
    !touch $PWD/tmp/restart.txt
endfunction

" Removes unnecessary whitespace
if has("eval")
    fun! <SID>StripWhite()
        %s/[ \t]\+$//ge
        %s!^\( \+\)\t!\=StrRepeat("\t", 1 + strlen(submatch(1)) / 8)!ge
    endfun

    fun! <SID>RemoveBlankLines()
        %s/^[\ \t]*\n//g
    endfun
endif

""-----------------------------------------------------------------------
"" auto commands
""-----------------------------------------------------------------------

if isdirectory(expand("$VIMRUNTIME/ftplugin"))
    if has("eval")
        filetype on
        filetype plugin on
        filetype indent on
    endif
endif

if has("autocmd")

    autocmd FileType html,xhtml,xml,eruby,mako,ruby,haml,yaml,erb setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 autoindent
    autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
    autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType xslt,xml,xhtml,html set ts=2
    autocmd FileType php set ts=4 complete+=k
    autocmd BufReadPost,BufNewFile,BufRead rsnapshot.conf set noet

    " When editing a file, jump to the last cursor position
    autocmd BufReadPost *
                \	if line("'\"") > 0 && line ("'\"") <= line("$")
                \	|	exe "normal g'\""
                \	| endif

    au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
    au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

    au BufRead,BufNewFile COMMIT_EDITMSG setf git

    autocmd BufNewFile,BufRead /tmp/mutt*
                \ setf mail |
                \ set spell |
                \ set spell spelllang=en_us |
                \ set spellfile=~/.vim/spellfile.add

    au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt* :set ft=mail
    au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,~/.tmp/mutt/mutt* :set ft=mail
    au! BufRead,BufNewFile *.haml :set ft=haml
    au! BufRead,BufNewFile *.sass :set ft=sass
    autocmd BufNewFile,BufRead *.inc
                \		  if getline(1) =~ 'php'
                \		|	setf php
                \		| else
                    \		|	setf perl
                    \		| endif

    autocmd BufNewFile *.pl	set noai | execute "normal a
                \#!/usr/bin/perl -W\<CR>
                \# $Id\$\<CR>
                \\<CR>
                \use strict;\<CR>
                \use warnings;\<CR>
                \\<CR>" | set ai

    autocmd BufNewFile *.htm,*.html	set noai | execute "normal a
                \<!DOCTYPE html PUBLIC \"-//W3C//XHTML 1.0 Transitional//EN\">\<CR>
                \\<CR>
                \<html lang=\"en-US\" xml:lang=\"en-US\" xmlns=\"http://www.w3.org/1999/XHTML\">\<CR>
                \	<head>\<CR>
                \		<title></title>\<CR>
                \		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\<CR>
                \	</head>\<CR>
                \	<body>\<CR>
                \	</body>\<CR>
                \</html>" | set ai
endif

if has("autocmd") && has("eval")
    augroup gregf
        autocmd!

        " Automagic line numbers
        autocmd BufEnter * :call <SID>WindowWidth()

        " StripWhite space on save
        "autocmd FileWritePre * :call <SID>StripWhite()
        "autocmd FileAppendPre * :call <SID>StripWhite()
        "autocmd FilterWritePre * :call <SID>StripWhite()
        "autocmd BufWritePre * :call <SID>StripWhite()

        " Update header in .vimrc and .bashrc before saving
        autocmd BufWritePre *vimrc  :call <SID>UpdateRcHeader()
        autocmd BufWritePre *zshrc :call <SID>UpdateRcHeader()

        " Always do a full syntax refresh
        autocmd BufEnter * syntax sync fromstart

        " For svn-commit, don't create backups
        autocmd BufRead svn-commit.tmp :setlocal nobackup

        " m4 matchit support
        autocmd FileType m4 :let b:match_words="(:),`:',[:],{:}"
    augroup END
endif

" content creation
if has("autocmd")
    augroup content
        autocmd!

        autocmd BufNewFile *.rb 0put = '' |
                    \ 0put ='# vim: set sw=2 sts=2 et tw=80 :' |
                    \ 0put = '# Copyright (c) 2009 Greg Fitzgerald <netzdamon@gmail.com>' |
                    \ 0put = '# Distributed under the terms of the GNU General Public License v2' |
                    \ 0put ='#!/usr/bin/env ruby' | set sw=2 sts=2 et tw=80 |
                    \ norm G

        autocmd BufNewFile *.lua 0put ='# vim: set sw=4 sts=4 et tw=80 :' |
                    \ 0put ='#!/usr/bin/env lua' | set sw=4 sts=4 et tw=80 |
                    \ norm G

        autocmd BufNewFile *.hh 0put ='/* vim: set sw=4 sts=4 et foldmethod=syntax : */' |
                    \ 1put ='' | call MakeIncludeGuards() |
                    \ set sw=4 sts=4 et tw=80 | norm G

        autocmd BufNewFile *.cc 0put ='/* vim: set sw=4 sts=4 et foldmethod=syntax : */' |
                    \ 1put ='' | 2put ='' | call setline(3, '#include "' .
                    \ substitute(expand("%:t"), ".cc$", ".hh", "") . '"') |
                    \ set sw=4 sts=4 et tw=80 | norm G
        autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
        au! BufRead,BufNewFile *.mkd   setfiletype mkd

        "ruby
        autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
        autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
        autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
        autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
        "improve autocomplete menu color
        highlight Pmenu ctermbg=238 gui=bold
        au BufRead,BufNewFile *.js set ft=javascript.jquery
        au BufRead,BufNewFile *.js.haml set ft=javascript.jquery
        au BufRead,BufNewFile *.js.erb set ft=javascript.jquery
        au BufRead,BufNewFile *.pp set ft=puppet
        au BufRead,BufNewFile *.god set ft=ruby
    augroup END
endif

" turn off any existing search and spell checking
if has("autocmd")
    au VimEnter * nohls
    au VimLeave * set nospell
endif

"-----------------------------------------------------------------------
" GUI Options plus colorschemes
"-----------------------------------------------------------------------

if &term == 'xterm' || &term == 'screen-bce' || &term == 'screen' || &term == 'rxvt-unicode' || &term == "xterm-256color"
    set t_Co=256 " Let ViM know we have a 256 color capible terminal
    colorscheme zenburn
    "colorscheme gigamo
    "colorscheme peaksea
    else
    colorscheme jammy
endif

if (has("gui_running"))
    "colorscheme gigamo
    "colorscheme darkspectrum 
    "colorscheme kellys < friggen awesomeness
    "colorscheme wombat " < friggen awesomeness as well
    colorscheme xoria256 " < more awesomeness
    set guifont=Droid\ Sans\ Mono\ 12
    set mousem=popup	" Nice pop-up
    set selection=exclusive	" Allow one char past EOL
    set ttymouse=xterm2	" Terminal type for mouse code recognition
    set mousehide
endif

if has('gui')
    set guioptions-=m
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    set guioptions+=a
endif

" Nice window title
if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                                              " file name
    set titlestring+=%h%m%r%w                                         " flags
    set titlestring+=\ -\ %{v:progname}                               " program name
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}  " working directory
endif

"Extra terminal things
if (&term =~ "xterm") && (&termencoding == "")
    set termencoding=utf-8
endif

if &term =~ "xterm"
    if has('title')
        set title
    endif
    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
        let &t_EI = "\<Esc>]12;grey80\x7"
    endif
endif

"Include $HOME in cdpath
if has("file_in_path")
    let &cdpath=','.expand("$HOME").','.expand("$HOME").'/code'
endif

if has("eval")
    " If we're in a wide window, enable line numbers.
    fun! <SID>WindowWidth()
        if winwidth(0) > 90
            setlocal foldcolumn=2
            setlocal number
        else
            setlocal nonumber
            setlocal foldcolumn=0
        endif
    endfun
endif

" Enable fancy % matching
if has("eval")
    runtime! macros/matchit.vim
endif

"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold


let g:SuperTabMappingForward = '<c-right>'
let g:SuperTabMappingBackward = '<c-left>'
let g:SuperTabLongestHighlight = 1 
let g:SuperTabMidWordCompletion = 1
let g:SuperTabRetainCompletionType = 1 

" Set taglist plugin options
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 0
let Tlist_Inc_Winwidth = 1

" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120 :
