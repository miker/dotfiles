scriptencoding utf-8
" ----------------------------------------------------------------------------
" File:     ~/.vimrc
" Author:   Greg Fitzgerald <netzdamon@gmail.com>
" Modified: Sat 27 Jun 2009 09:03:15 PM EDT
" ----------------------------------------------------------------------------

" {{{ Settings

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
set history=900
" Default fileformat
set fileformat=unix
" Display list of matching files for completion
set wildmode=list:longest	" Display list of matching files for completion
" Do not require end-of-line
set noeol
" Characters to break at for line wrapping
set breakat=\ \	!@*-+;:,.?
" Do not stay vi compatible
set nocompatible
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
set wildignore+=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.git,.info,.aux,.log,.dvi,.bbl,.out
set showcmd
set cmdheight=2
set winminheight=0              " let windows shrink to filenames only
set showtabline=1               " display tabbar 
" Set some global options for spell check
set spell spelllang=en_us
set spellfile=~/.vim/spellfile.add


" {{{ Set a shell
if has("unix")
  set clipboard=autoselect
    if "" == &shell
      if executable("zsh")
        set shell=zsh
      elseif executable("bash")
        set shell=bash
      elseif executable("sh")
        set shell=sh
      endif
    endif
endif
" }}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
  let is_bash=1
endif
" }}}

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
set foldenable
set foldmethod=marker
set foldlevelstart=0
" }}}

" {{{ Plugin settings

" gist
let g:github_user="gregf"
let g:github_token="c063595c9d2dca14f8115509cce8a228"

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

" }}}

" {{{ Window title
if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                                              " file name
    set titlestring+=%h%m%r%w                                         " flags
    set titlestring+=\ -\ %{v:progname}                               " program name
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}  " working directory
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

imap <C-l> <Space>=><Space>
nmap <C-P> :tabp<CR>
noremap <silent> <C-z> :undo<CR>
noremap <silent> <C-O> :FuzzyFinderMruFile<CR>
noremap <silent> <F9> :NERDTreeToggle<CR>
noremap <Leader>res :call <SID>Restart()<CR>
noremap <silent> <C-F12> :call UpdateDNSSerial()<CR>
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
noremap <Leader>s :call Sass()<CR>
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
noremap <Leader>xd :w\|!xrdb -load ~/.Xdefaults %<cr>
noremap <Leader>p :set paste<CR>
noremap <Leader>nu :set nonumber<CR>
noremap <Leader>pp :s/:/ /g<CR>
noremap <Leader>cache :call ClearCache()<CR>
noremap :close :bd!<CR>
" Quick sudo saving from tpope
command! -bar -nargs=0 SudoW :silent exe "write !sudo tee % >/dev/null" | silent edit!
" }}}

" {{{ Functions

command! -nargs=0 RDocPreview call RDocRenderBufferToPreview()

function! RDocRenderBufferToPreview()
  let rdocoutput = "/tmp/vimrdoc/"
  call system("rdoc " . bufname("%") . " --op " . rdocoutput)
  call system("firefox ". rdocoutput . "index.html")
endfunction

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
            setlocal foldcolumn=2
            setlocal number
        else
            setlocal nonumber
            setlocal foldcolumn=0
        endif
    endfun
endif

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
    chdir /home/gregf/code/active/mideo/
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

    autocmd BufWritePre *  :call <SID>UpdateRcHeader()

    autocmd BufWritePre .Xdefaults :!xrdb -load ~/.Xdefaults

    " For svn-commit, don't create backups
    autocmd BufRead svn-commit.tmp :setlocal nobackup

    autocmd FileType html,xhtml,xml,eruby,mako,ruby,haml,yaml,erb setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 autoindent
    autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
    autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType xslt,xml,xhtml,html set ts=2
    autocmd FileType php set ts=4 complete+=k
    autocmd BufReadPost,BufNewFile,BufRead rsnapshot.conf set noet
    autocmd BufReadPost,BufNewFile,BufRead nginx.conf set syntax=nginx
    autocmd BufReadPost,BufNewFile,BufRead TODO set syntax=todolist

    au BufRead,BufNewFile COMMIT_EDITMSG setf git

    autocmd BufNewFile,BufRead /tmp/mutt/mutt*
                \ setf mail |
                \ set spell 

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

    "ruby
    autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
    autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
    autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
endif

augroup gentoo
  au!

  " Gentoo-specific settings for ebuilds.  These are the federally-mandated
  " required tab settings.  See the following for more information:
  " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
  " Note that the rules below are very minimal and don't cover everything.
  " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
  " filetype and indent settings for all things Gentoo.
  au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
  au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

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

augroup END

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

        "ruby
        autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
        autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
        autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
        autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
        
        au BufRead,BufNewFile *.js set ft=javascript.jquery
        au BufRead,BufNewFile *.js.haml set ft=javascript.jquery
        au BufRead,BufNewFile *.js.erb set ft=javascript.jquery
        au BufRead,BufNewFile *.pp set ft=puppet
        au BufRead,BufNewFile *.god set ft=ruby
    augroup END
endif

" }}}

" {{{ GUI Options & Colorschemes

"improve autocomplete menu color
highlight pmenu ctermbg=238 gui=bold

if &term ==? 'xterm' || &term ==? 'screen' || &term ==? 'rxvt'
    set t_Co=256 " Let ViM know we have a 256 color capible terminal
    colorscheme mustang 
    else
    colorscheme jammy
endif

if (has("gui_running"))
    colorscheme mustang
    ""set guifont=Droid\ Sans\ Mono\ 12
    set guifont=inconsolata\ 14
    set mousem=popup	" Nice pop-up
    set selection=exclusive	" Allow one char past EOL
    set ttymouse=xterm2	" Terminal type for mouse code recognition
    set mousehide
    " Make shift-insert work like in xterm
    map <S-Insert> <MiddleMouse>
    map! <S-Insert> <MiddleMouse>
    " set some gui options
    set guioptions=a
    set mouse=a
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

" set vim to chdir for each file
let os = substitute(system('uname'), "\n", "", "")
if os ==? "Linux" || os ==? "OpenBSD"
    au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif
    set autochdir
endif
" }}}

" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120 :
