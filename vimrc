scriptencoding utf-8
" ----------------------------------------------------------------------------
" File:     ~/.vimrc
" Author:   Greg Fitzgerald <netzdamon@gmail.com>
" Author2: Mike Reynolds <reynoldsmike@gmail.com>
" Modified: Tue 5 Sep 2017 21:30 PM EDT
" ----------------------------------------------------------------------------
"
" {{{ Pathogen

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
" }}}

" {{{ Settings
set nocompatible                  " Must come first because it changes other options.

syntax on                         " Turn on syntax highlighting.
filetype plugin on                " Turn on file type detection.
filetype indent on

runtime macros/matchit.vim        " Load the matchit plugin.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set wildmenu                      " Enhanced command line completion.
"set wildmode=list:longest,list:full
set wildmode=list:longest
set wildignore=*.o,*.obj,*~       "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

set ignorecase                    " Case-insensitive searching;
set nosmartcase                   " but case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.
set ruler                         " Show cursor position.

set incsearch                     " Highlight matches as you type.
set hlsearch

set wrap                          " Turn on line wrapping.
set wrapmargin=2

set linebreak
set scrolloff=3                   " Show 3 lines of context around the cursor.

set title                         " Set the terminal's title

set novisualbell                  " No beeping.

if v:version >= 703
    set cryptmethod=blowfish
endif

set expandtab                     " Use spaces instead of tabs

set tabstop=2
set softtabstop=2                 " tab conversion to number of spaces
set shiftwidth=2                  " auto-indent amount when using cindent, >>, <<
set shiftround                    " when at 3 spaces, and I hit > ... go to 4, not 5

set si
set nospell

set autoindent

set lcs=tab:»»,trail:·,eol:·
set nolist

set clipboard=unnamed

set noswapfile

set completeopt=longest,menu,preview
set complete=.,t

set laststatus=2

set mouse=a

" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

set shortmess=atI

" keep some backups
set backup
silent !mkdir ~/.vimbackups > /dev/null 2>&1
set backupdir=~/.vimbackups

if has('persistent_undo')
    silent !mkdir ~/.vimundo > /dev/null 2>&1
    set undodir=~/.vimundo
    set undofile
    set undolevels=10000
    set undoreload=10000
endif

set background=dark

scriptencoding utf-8
set encoding=utf-8

if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                                              " file name
    set titlestring+=%h%m%r%w                                         " flags
    set titlestring+=\ -\ %{v:progname}                               " program name
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}  " working directory
    set title
endif

" Use ack for grepping
set grepprg=ack
set grepformat=%f:%l:%m

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set nohidden

"}}}

"{{{ Plugin Settings
"let g:Powerline_symbols = 'fancy'

let g:color_x11_names = 1

" Better surround
let g:surround_40 = "(\r)"
let g:surround_91 = "[\r]"
let g:surround_60 = "<\r>"

" rails.vim
let g:rails_menu=2
let g:rails_dbext=1
let g:rails_default_database='sqlite3'
let g:rails_gnu_screen=1
let g:rails_mappings=1
let g:rails_statusline=1
let g:rails_subversion=0
let g:rails_syntax=1
let g:browser = 'chromium '

let g:tskelUserName="Mike Reynolds"
let g:tskelUserEmail="reynoldsmike@gmail.com"
let g:tskelUserWWW="http://www.marskreations.com"
let g:tskelDateFormat="%Y"
let g:tskelLicense="MIT"

" Settings for NERDCommenter
let g:NERDShutUp=1
" NERDTree settings
let g:NERDTreeDirArrows=1
let g:NERDTreeWinPos='left'
let g:NERDTreeChDirMode='2'
let g:NERDTreeSortOrder=['^__\.rb$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDChristmasTree = 1
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeMapActivateNode='<CR>'
let g:NERDTreeChDirMode = 1
let g:NERDTreeIgnore=['\.git', '\.svn', '\.cvs', '\.log']

let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

let g:syntastic_enable_signs = 1
let g:syntastic_quiet_messages = {'level': 'warnings'}

let g:gundo_preview_bottom = 1
let g:gundo_preview_height = 20
let g:gundo_width = 30

let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
let g:solarized_bold = 1
let g:solarized_underline = 1
let g:solarized_italic = 1
let g:solarized_contrast = "high"
let g:solarized_visibility= "normal"

"supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabMidWordCompletion = 0

" Hightlight redundent spaces
highlight RedundantWhitespace ctermbg=red guibg=red
match RedundantWhitespace /\s\+$\| \+\ze\t/

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

" {{{ Key maps

" Set map leader to ,
let mapleader = ","

nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>


noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>u :undo<CR>
noremap <leader>ru :redo<CR>
"noremap <silent> <C-F12> :call UpdateDNSSerial()<CR>
"noremap <silent> <leader>uh :call UpdateRcHeader()<CR>
noremap <Leader>ss :call StripTrailingWhitespace()<CR>
noremap <Leader>sb :call RemoveBlankLines()<CR>
" Reformat everything
noremap <Leader>gq gggqG
" have Q reformat the current paragraph (or selected text if there is any):
noremap Q gqap
vnoremap Q gq
" Clear lines
noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>
" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>
" Don't make a # force column zero.
inoremap # X<BS>#
noremap <Leader>rr :w\|!ruby %<cr>
noremap <Leader>rb :w\|!bash %<cr>
noremap <Leader>p :set paste<cr>
noremap <Leader>nu :call ToggleColumns()<CR>
noremap <Leader>sp :set spell<CR>
noremap <Leader>cache :call ClearCache()<CR>
noremap <Leader>doc :!rake documentation:generate<CR>
"Visual undo
" http://bitbucket.org/sjl/gundo.vim/src/tip/plugin/
"nmap <Leader>gu :GundoToggle<CR>
" Quick sudo saving from tpope
command! -bar -nargs=0 SudoW :silent exe "write !sudo tee % >/dev/null"
            \ | silent edit!
noremap <Leader>su :SudoW<CR>
command! -nargs=+ PopupMap call s:popupMap(<f-args>)

" fix a block of XML; inserts newlines, indents properly, folds by indent
nmap <Leader>fx :setlocal filetype=xml<CR>:%s/></>\r</g<CR>:1,$!xmllint--format-
            \ <CR>:setlocal foldmethod=indent<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

nmap <leader>gv :Gitv --all<cr>
nmap <leader>gV :Gitv! --all<cr>
cabbrev git Git

nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" Change EVIL EVIL tabs to spaces
nmap <Leader>rt :call WhitespaceRetab()<CR>

" copy the current line to the clipboard
nmap <leader>Y "*yy
nmap <leader>cp "*p

" gf should use new tab, not current buffer
map gf :tabe <cfile><cr>

" move tab left or right
noremap <C-l> :call MoveTab(0)<CR>
noremap <C-h> :call MoveTab(-2)<CR>

" Clear the search buffer when hitting return
noremap <CR> :nohlsearch<cr>

" This group is stolen from mislav's vimrc
" http://github.com/mislav/dotfiles/blob/master/vimrc

" Format the current paragraph according to
" the current 'textwidth' with CTRL-J:
nmap <C-J> gqap
vmap <C-J> gq
imap <C-J> <C-O>gqap

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
nmap <C-k> [e
nmap <C-j> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
vmap <C-k> [egv
vmap <C-j> ]egv

imap jj <Esc>

"trick to fix shift-tab http://vim.wikia.com/wiki/Make_Shift-Tab_work
map <Esc>[Z <s-tab>
ounmap <Esc>[Z

"Code formatting
map   <silent> <leader>fc mmgg=G'm
imap  <silent> <leader>fc <Esc> mmgg=G'm

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vmap P p :call setreg('"', getreg('0')) <CR>

" Return to visual mode after indenting
xmap < <gv
xmap > >gv

" Jekyll
"map <Leader>jb  :JekyllBuild<CR>
"map <Leader>jn  :JekyllPost<CR>
"map <Leader>jl  :JekyllList<CR>

" }}}

" {{{ Functions
if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

"If possible, try to use a narrow number column.
if v:version >= 700
    try
        setlocal numberwidth=2
    catch
    endtry
endif

" Update *rc header
function UpdateRcHeader()
    let l:c=col(".")
    let l:l=line(".")
    if search("Last update:") != 0
        1,8s-\(Modified:\).*-\="Modified: ".strftime("%c")-
    endif
    call cursor(l:l, l:c)
endfunction

if has("eval")
    " If we're in a wide window, enable line numbers.
    fun! <SID>WindowWidth()
        if winwidth(0) > 90
            setlocal foldcolumn=2
            setlocal foldmethod=marker
            setlocal number
            setlocal nu
        else
            setlocal nonumber
            setlocal foldcolumn=0
        endif
    endfun
endif

function StripTrailingWhitespace()
    %s/[ \t]\+$//ge
    %s!^\( \+\)\t!\=StrRepeat("\t", 1 + strlen(submatch(1)) / 8)!ge
endfunction

function WhitespaceRetab()
    setlocal expandtab
    retab
endfunction

function RemoveBlankLines()
    %s/^[\ \t]*\n//g
endfunction

"make it easy to remove line number column etc. for cross-terminal copy/paste
function! ToggleColumns()
    if &number
        setlocal nonumber
        setlocal foldcolumn=0
        let s:showbreaktmp = &showbreak
        setlocal showbreak=
        setlocal nolist
    else
        setlocal number
        setlocal foldcolumn=2
        let &showbreak = s:showbreaktmp
        setlocal list
    end
endfunction

"tab moving
function! MoveTab(n)
    let which = tabpagenr()
    let which = which + a:n
    exe "tabm ".which
endfunction

function! <sid>LastTab()
    if !exists("g:last_tab")
        return
    endif
    exe "tabn" g:last_tab
endfunction


" }}}

" {{{ auto commands

if has("autocmd")
    au BufEnter * lcd %:p:h

    au VimLeave * set nospell
    au VimEnter * nohl
    au TabLeave * :let g:last_tab=tabpagenr()
    autocmd BufWritePre * :%s/\s\+$//e
    " Always do a full syntax refresh
    autocmd BufEnter * syntax sync fromstart

    " Automagic line numbers
    autocmd BufEnter * :call <SID>WindowWidth()

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
                \     setlocal textwidth=80 |
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
    autocmd Filetype gitcommit set tw=68  spell

    augroup configs
        autocmd!
        autocmd BufWritePre *vimrc :call UpdateRcHeader()
        autocmd BufWritePre *.vim :call UpdateRcHeader()
        autocmd BufWritePre *zshrc :call UpdateRcHeader()
        autocmd BufWritePre */.mutt/* :call UpdateRcHeader()
        autocmd BufWritePre muttrc :call UpdateRcHeader()
    augroup END
endif

" }}}

" {{{ GUI Options & Colorschemes
"{{{ Colors
set t_Co=256 " Let ViM know we have a 256 color capible terminal
colorscheme solarized
"}}}

"{{{ Gui
if (has("gui_running"))
"    set guifont=inconsolata\ for\ powerline\ 12
    colorscheme two2tango
    "colorscheme mustang
    "colorscheme vilight
    "set guifont=Droid\ Sans\ Mono\ 12
    set guifont=inconsolata\ 20
    set mousem=popup
    set selection=exclusive " Allow one char past EOL
    set ttymouse=xterm2 " Terminal type for mouse code recognition
    set mousehide
    " Make shift-insert work like in xterm
    map <S-Insert> <MiddleMouse>
    map! <S-Insert> <MiddleMouse>
    " set some gui options
    set guioptions=ac
    set guioptions+=m
    set guioptions+=T
    set guioptions+=l
    set guioptions+=L
    set guioptions+=r
    set guioptions+=R
    set guioptions+=g
    set mouse=a
endif
"}}}

"{{{ Local

" Source local vimrc
if filereadable(expand('~/.vimrc.local'))
    exec 'source ' . expand('~/.vimrc.local')
endif
"}}}

" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120 :
