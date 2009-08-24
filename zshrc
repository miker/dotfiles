# ----------------------------------------------------------------------------
# File:     ~/.zshrc
# Author:   Greg Fitzgerald <netzdamon@gmail.com>
# Modified: Mon 24 Aug 2009 07:12:08 PM EDT
# ----------------------------------------------------------------------------

# {{{ Clear screen on logout
trap clear 0
# }}}

# {{{ unmask
if [ "`id -gn`" = "`id -un`" -a `id -u` -gt 99 ]; then
    umask 002
else
    umask 022
fi
# }}}

# {{{ Return if non-interactive
if [[ ! -o interactive ]]; then
        return
fi
# }}}

# {{{ Create some default files/directories if they don't exist.
if ! [ -d ~/.ssh ]; then
    mkdir -p ~/.ssh
fi

if ! [ -f ~/.ssh/known_hosts ]; then
    touch ~/.ssh/known_hosts
fi

if ! [ -f ~/.viminfo ]; then
    touch ~/.viminfo
fi
# }}}

# {{{ OS specific settings
case `uname` in
    OpenBSD)
        # Enviroment Varibles
        export PKG_PATH=ftp://ftp.openbsd.org/pub/OpenBSD/`uname -r`/packages/`machine -a`/

        # which version of ls should we use?
        if [ -x /usr/local/bin/gls ]; then
            alias ls='/usr/local/bin/gls -F --color --human-readable'
            export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;3:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"
        else
            if [ -x /usr/local/bin/colorls ]; then
                alias ls='/usr/local/bin/colorls -G -F'
                export LSCOLORS="ExGxFxDxCxDxDxxbadacad"
            fi
        fi
        # Aliases
        alias cvsup="cd /usr && cvs -qd anoncvs@anoncvs1.usa.openbsd.org:/cvs checkout -P -rOPENBSD_4_5 src"
        alias srcup="cd /usr/src && cvs -q up -rOPENBSD_4_5 -Pd"
        alias portsup="cd /usr &&  cvs -qd anoncvs@anoncvs1.usa.openbsd.org:/cvs get -rOPENBSD_4_5 -P ports"
        alias cvsrun="sudo cvsup -g -L 2 /etc/cvs-supfile"
        alias killall="pkill"
        alias shred="rm -P"
    ;;
    FreeBSD)
        SSH_ASKPASS="/usr/local/bin/ssh-askpass-gtk2"
        LSCOLORS=ExCxFxFxBxGxGxababaeae
        CLICOLOR=$LSCOLORS

        alias ls='ls -GF'
        alias portu="sudo csup -L 2 /etc/ports-cvsup"
        alias srcu="sudo csup -L 2 /etc/src-cvsup"
        export LANG="en_US.UTF-8"
        export LC_CTYPE="en_US.UTF-8"
        export LC_ALL="en_US.UTF-8"

    ;;
    Linux)
        #export SSH_ASKPASS="/usr/bin/gtk2-ssh-askpass"

        # We Want utf8
        export LC_CTYPE=en_US.utf8
        export LC_ALL=en_US.UTF8

        #aliases
        alias ls='ls -F --color --human-readable'
        alias rm='nocorrect /bin/rm -I --preserve-root'

        if [ $HOST  = "mail" ]; then
            export RAILS_ENV="production"
        fi

        #############################################################################
        # colors for ls, etc.  Prefer ~/.dir_colors
        #############################################################################
        if [[ -f ~/.dir_colors ]]; then
            eval `dircolors -b ~/.dir_colors`
        else
            eval `dircolors -b /etc/DIR_COLORS`
        fi

        if [[ -f /etc/gentoo-release ]]; then
            alias ms="mirrorselect -b10 -s5 -D"
            alias python-updater="python-updater -P paludis"
            alias module-rebuild="module-rebuild -P paludis $@"
            alias dp="dispatch-conf"
            alias keywords='sudo vim /etc/paludis/keywords.conf'
            alias use='sudo vim /etc/paludis/use.conf'
            alias mask='sudo vim /etc/paludis/package_mask.conf'
            alias unmask='sudo vim /etc/paludis/package_unmask.conf'
            alias bashrc='sudo vim /etc/paludis/bashrc'
            alias df='df -hT'
            alias pq='paludis -q'
            alias lf='paludis --contents'
            alias ex='paludis --executables'
            alias puu='paludis --permit-unsafe-uninstalls -u'

            export PALUDIS_RESUME_DIR="${HOME}"/.resume-paludis
            export PALUDIS_OPTIONS="--resume-command-template ${PALUDIS_RESUME_DIR}/paludis-resume-XXXXXX --show-reasons summary --log-level warning --show-use-descriptions all --continue-on-failure if-satisfied --dl-reinstall if-use-changed --dl-reinstall-scm weekly"
            export RECONCILIO_OPTIONS="--continue-on-failure if-satisfied"

            function paludis-scm {
                PALUDIS_OPTIONS="--dl-reinstall-scm daily"
                paludis $@
            }

            function explainuseflag {
                sed -ne "s,^\([^ ]*:\)\?$1 - ,,p" \
                /usr/portage/profiles/use.desc \
                /usr/portage/profiles/use.local.desc
             }

            function edesc {
                cat *.ebuild | sed -ne 's-^DESCRIPTION="\(.*\)".*-\1-1p' | sort -u
            }

            function ewww {
                cat *.ebuild | sed -ne 's-^HOMEPAGE="\(.*\)".*-\1-1p' | sort -u
            }

            function svcs {
                sudo /etc/init.d/$1 start
            }

            function svce {
                sudo /etc/init.d/$1 stop
            }

            function svcr {
                sudo /etc/init.d/$1 restart
            }

            function svcz {
                sudo /etc/init.d/$1 zap
            }

            function rca {
                sudo /sbin/rc-update add $1 default
            }

            function rcd {
                sudo /sbin/rc-update del $1 default
            }
        fi
    ;;
esac
# }}}

# {{{ Enviroment Variables
unset MAILCHECK

watch=(notme)  ## watch for everybody but me
LOGCHECK=60  ## check every ... seconds for login/logout activity
WATCHFMT='%n %a %l from %m at %t.'


if [[ -d /var/tmp/ccache ]]; then
    (( ${+CCACHE_DIR} )) || export CCACHE_DIR="/var/tmp/ccache"
    (( ${+CCACHE_SIZE} )) || export CCACHE_SIZE="2G"

fi

## If nonnegative, commands whose combined user and system execution times
## (measured in seconds) are greater than this value have timing
## statistics printed for them.
REPORTTIME=2

# To many stupid scripts don't unset this so I'm using an alias for now
#export GREP_OPTIONS="--color=auto -nsi"
(( ${+TZ} )) || export TZ="EST5EDT"
#export MPD_HOST="/home/gregf/.mpd/socket"
export MPD_HOST="localhost"
export MPD_PORT="6600"
export GIT_AUTHOR_EMAIL="netzdamon@gmail.com"
export GIT_AUTHOR_NAME="Greg Fitzgerald"
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

# Some settings for autotest
export AUTOFEATURE="true" 
export RSPEC="true"

# Some things we want set regardless
export MANPAGER="most"
export PAGER="most"
export EDITOR="vim"
export VISUAL="vim"
export NNTPSERVER="news.gwi.net"
export GPG_TTY=`tty` #backticks required

#custom exports for coloured less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# }}}

# {{{ Resource Limits
limit stack 8192
#limit core unlimited
limit core 0
limit -s
# }}}

# {{{ Setup History Options
HISTSIZE=10000
HISTFILE=${HOME}/.history_zsh
SAVEHIST=10000
DIRSTACKSIZE=16
# }}}

# {{{ Term Settings
#auto logout after timeout in seconds

if [[ $TERM == "linux" ]]; then
    TMOUT=1800
fi

## if we are in X then disable TMOUT
case $TERM in
    xterm*|rxvt|(dt|k|E)term|rxvt-*)
    unset TMOUT
    ;;
esac

# format titles for screen and rxvt
function title() {
    # escape '%' chars in $1, make nonprintables visible
    a=${(V)1//\%/\%\%}

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")

    case $TERM in
        screen-*)
        print -Pn "\ek$a:$3\e\\"      # screen title (in ^A")
        ;;
        xterm*|rxvt-*)
        print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title
        ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd() {
    title "zsh" "$USER@%m" "%55<...<%~"
}

# preexec is called just before any command line is executed
function preexec() {
    title "$1" "$USER@%m" "%35<...<%~"
}

# Enable flow control, prevents ^k^s from locking up my screen session.
stty -ixon
# }}}

# {{{ Default Aliases
alias xlog="sudo grep --binary-files=without-match --color -nsie '(EE)' -e '(WW)' /var/log/Xorg.0.log"
alias which="whence"
alias z='vim ~/.zshrc;src'
alias sd='export DISPLAY=:0.0'
alias cpan="perl -MCPAN -e shell"
alias cup='cvs -z3 update -Pd'
alias mv='nocorrect /bin/mv'
alias shred='nocorrect ionice -c3 /usr/bin/shred -fuzv'
alias wipe='nocorrect ionice -c3 /usr/bin/wipe -l1 -v -r'
alias man='nocorrect man'
alias mkdir='nocorrect /bin/mkdir -p'
alias find='noglob find'
alias wget="wget -c"
alias ll="ls -l"
alias l.='ls -d .[^.]*'
alias lsd='ls -ld *(-/DN)'
alias weather="~/code/bin/forecast/forecast.rb"
alias ncmpc="ncmpc -c"
alias fixdbus="dbus-uuidgen --ensure"
alias wp="feh --bg-scale"
alias wp="~/code/bin/wallpaper/wallpaper.rb"
alias m="nice -n1 mplayer"
alias ml="nice -n1 mplayer -loop 0"
alias mls="nice -n1 mplayer -loop 0 -shuffle"
alias mn="nice -n1 mplayer -nosound"
alias e="gvim"
alias v="vim"
alias t="thunar"
alias repo='cd /var/paludis/repositories'
alias ov='cd /home/gregf/code/active/gregf-overlay'
alias sc='script/console'
alias sp='script/plugin'
alias db='script/dbconsole'
alias sgmo="sg model $@"
alias sgmi="sg migration $@"
alias setmid='rm -f db/*.sqlite3 ; rake db:migrate && rake admin:create'
alias a='autotest -rails'
alias tlog='tail -f log/development.log'
alias rst='touch tmp/restart.txt'
alias migrate='rake db:migrate db:test:clone'
alias gi='sudo gem install --no-ri --include-dependencies'
alias gs='gem search -b'
alias burniso='wodim -v dev=/dev/cdrw'
alias burndvdiso='growisofs -speed=8 -dvd-compat -Z /dev/dvdrw=$1'
alias usepretend='sudo paludis -ip --dl-reinstall if-use-changed'
alias usedo='sudo paludis -i --dl-reinstall if-use-changed'
alias ketchup='ketchup -G'
alias biosinfo='sudo dmidecode'
alias pwgen='pwgen -sBnc 10'
alias la="ls -a"
alias l="ls"
alias d="devtodo"
alias gnp="git-notpushed"
alias s="sudo"
alias ej="eject"
alias k="killall"
alias poweroff='sudo poweroff'
alias reboot='sudo reboot'
alias savage="~/code/bin/savage/savage.sh"
alias wcyy="mplayer http://68.142.81.164:80/citadelcc_WCYY_FM\?MSWMExt\=.asf"
alias wkit="mplayer http://64.92.199.73/WKIT-FM"
alias dropcache='sudo echo 3 > /proc/sys/vm/drop_caches'
alias lock='alock -auth pam -bg blank:color=black'
alias lsnoext="ls | grep -v '\.'"
alias gis="git status | grep --color=always '^[^a-z]\+\(new file:\|modified:\)' | cut -d'#' -f2-"
alias lk='lynx -dump http://kernel.org/kdist/finger_banner'
alias dosbox='dosbox -conf ~/.dosbox.conf -fulscreen'
alias vim="vim -p"
alias g='grep -Hn --color=always'
alias ra="echo 'awful.util.restart()' | awesome-client -"
alias sv="gvim --remote-tab-silent"
alias lvim="vim -c \"normal '0\""
alias geminstaller='sudo geminstaller -s -c $HOME/.geminstaller.yaml'
alias c="clear"
alias smv="sudo mv"
alias srm="sudo rm"
alias installed='qlist -I | most'
alias lg='ls | grep -i $1'
alias n="nitrogen ~/media/images/wallpaper/"
alias grm='git rm $(git ls-files --deleted)'
alias encrypt="gpg -e -r Greg"
alias decrypt="gpg -d -r Greg"
alias tmux="tmux -2"
alias tmr="tmux attach-session"
alias most="most +s +u"
alias ri="ri -Tf ansi"


# }}}

# {{{ Completion
###############################################################################
# Lots of autocompletion options
################################################################################
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit zrecompile
compinit

# Eat it bc
autoload -z zcalc
autoload -U zmv

# Follow GNU LS_COLORS
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' keep-prefix true tag-order all-expansions

compctl -g '*.Z *.gz *.tgz' + -g '*' zcat gunzip tar open
compctl -g '*.tar.Z *.tar.gz *.tgz *.tar.bz2' + -g '*' tar bzip2 open
compctl -g '*.zip *.ZIP' + -g '*' unzip zip open
compctl -g '*.rar *.RAR' + -g '*' rar unrar open
compctl -g '*.(mp3|MP3|ogg|OGG|WAV|wav|ogv|OGV)' + -g '*(-/)'  ogg123 mpg123 audacious wma123 mplayer vlc
compctl -g '*.(divx|DIVX|m4v|M4V|wmv|WMV|avi|AVI|mpg|mpeg|MPG|MPEG|WMV|wmv|mov|MOV|wma|WMA|w4a|W4A|part|PART|rmvb|RMVB)' + -g '*(-/)'  xine mplayer kmplayer gmplayer vlc
compctl -g '*.(pdf|PDF|ps|PS|tiff|TIFF)' + -g '*(-/)' evince acroread xpdf epdfview
compctl -g '*.(jpg|JPG|jpeg|JPEG|gif|GIF|tiff|TIFF|png|PNG|tga|TGA)' + -g '*(-/)' feh gthumb xv f-spot gqview

# SSH Completion
zstyle ':completion:*:scp:*' tag-order files 'hosts:-domain:domain'
zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-domain:domain'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr

# highlight parameters with uncommon names
zstyle ':completion:*:parameters' list-colors "=[^a-zA-Z]*=$color[red]"
 
# highlight aliases
zstyle ':completion:*:aliases' list-colors "=*=$color[green]"
 
# highlight the original input.
zstyle ':completion:*:original' list-colors "=*=$color[red];$color[bold]"
 
# highlight words like 'esac' or 'end'
zstyle ':completion:*:reserved-words' list-colors "=*=$color[red]"

# With commands like `rm' it's annoying if one gets offered the same filename
# again even if it is already on the command line. To avoid that:
zstyle ':completion:*:rm:*' ignore-line yes

# Manpages, ho!
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# This makes rake autocomplete happy
zstyle ':completion:*' matcher-list 'r:|[:]=*'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*' verbose yes
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#) #([^ ]#)*=$color[cyan]=$color[yellow]=$color[green]"

# Make the nice with git completion and others
zstyle ':completion::*:(git|less|rm|vim|most)' ignore-line true

# Select Prompt
zstyle ':completion:*' menu select

# Expansion options
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
# Cache
#zstyle ':completion:*' use-cache off
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands

zstyle ':completion::complete:*' '\'

# Use menuselection for pid completion
zstyle ':completion:*:*:kill:*' menu yes select
#zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

#  tag-order 'globbed-files directories' all-files
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "- %{${fg[yellow]}%}%d%{${reset_color}%} -"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-separator '#'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:prefix:*' add-space true

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

## Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

## Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

#  tag-order 'globbed-files directories' all-files
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Magically quote urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

compctl -g '*(-/)' + -g '.*(-/)' -v cd pushd rmdir dirs chdir

# completion for "man" by Gossamer <gossamer@tertius.net.au> 980827
compctl -f -x 'S[1][2][3][4][5][6][7][8][9]' -k '(1 2 3 4 5 6 7 8 9)' \
- 'R[[1-9nlo]|[1-9](|[a-z]),^*]' -K 'match-man' \
- 's[-M],c[-1,-M]' -g '*(-/)' \
- 's[-P],c[-1,-P]' -c \
- 's[-S],s[-1,-S]' -k '( )' \
- 's[-]' -k '(a d f h k t M P)' \
- 'p[1,-1]' -c + -K 'match-man' \
-- man

if [ -f ~/.ssh/known_hosts ]; then
    local _myhosts
    _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
    zstyle ':completion:*' hosts $_myhosts
fi

# Set some default options
# http://zsh.sourceforge.net/Doc/Release/zsh_15.html#SEC81
setopt always_to_end append_history auto_continue auto_list auto_menu \
auto_param_slash auto_remove_slash auto_resume bg_nice no_check_jobs no_hup \
complete_in_word csh_junkie_history extended_glob \
glob_complete hist_find_no_dups hist_ignore_all_dups hist_ignore_dups \
hist_ignore_space hist_no_functions hist_save_no_dups list_ambiguous \
long_list_jobs menu_complete rm_star_wait zle inc_append_history \
share_history prompt_subst no_list_beep local_options local_traps \
hist_verify extended_history hist_reduce_blanks chase_links chase_dots \
hash_cmds hash_dirs numeric_glob_sort vi rmstarwait

unset beep equals mail_warning
# }}}

# {{{ Functions
#


## find all suid files
function suidfind {
    ls -l /**/*(su0x) 
}

function install_dotfiles {
    git clone git://github.com/gregf/dotfiles.git $HOME/.dotfiles
    cd $HOME/.dotfiles
    rake install
    cd
}

function zkbd {
    ZVER=(`zsh --version | awk '{print $2}' -`)
    if [[ -f /usr/share/zsh/${ZVER}/functions/Misc/zkbd ]]; then
        zsh /usr/share/zsh/${ZVER}/functions/Misc/zkbd
    elif [[ -f /usr/local/share/zsh/${ZVER}/functions/Misc/zkbd ]]; then
        zsh /usr/local/share/zsh/${ZVER}/functions/Misc/zkbd
    elif [[ -f /usr/local/share/zsh/${ZVER}/functions/zkbd ]]; then
        zsh /usr/local/share/zsh/${ZVER}/functions/zkbd
    fi
}

function clamscan {
    mkdir -p /tmp/virus
    nice -n 19 clamscan --verbose --max-recursion=20 -m -i --detect-pua --move=/tmp/virus -r
    cd /tmp/virus
    echo -n "Viruses:"
    ls
}

function kvmiso {
    kvm -boot d -m 256 -localtime \
    -net nic \
    -net user \
    -no-fd-bootchk -no-acpi -cdrom $1
}

function kvmimg {
    kvm-img create -f qcow2 /storage/kvm/$i.qcow 10G
}

function kvminst {
    echo "Supply disk.img and path to iso or drive for installing from"
    kvm -boot d -m 256 -localtime \
    -net nic \
    -net user \
    -no-fd-bootchk -no-acpi \
    -hda /storage/kvm/$1.qcow -cdrom $2
}

function kvmrun {
    echo "Supply drive image to boot from"
    kvm -boot c -m 256 -localtime \
    -net nic \
    -net user \
    -no-fd-bootchk -no-acpi -hda /storage/kvm/$1.qcow
}

function pskill {
    kill -9 `pgrep $1`
    echo "slaughtered."
}


function kscreen {
    echo -ne "\017"
    reset
}

function spell { echo "$@" | aspell -a }

function calc { echo "$*" | bc; }

function date {
    if [ $# = 0 ]; then
        # format: saturday, december 21, 2002 06:46:38 pm est
        command date +"%a, %b %e %Y %I:%M:%S%P %Z"
    else
        # execute real `date`
        command date $@
    fi
}

function cal {
    if [ $# = 0 ]; then
        command cal -3
    else
        command cal $@
    fi
}


#function to clean up web permissions.
# TODO Move this to a script
function fixwww {
    DIRPERM="0755"
    FILEPERM="0644"
    USER="gregf"
    GROUP="gregf"
    echo " * Are you in the correct directory? (yes/no)"
    pwd
    read input
    if [ "$input" = "yes" ]; then
        echo " ! Fixing up WWW Permissions"
        echo "   Fixing File Permissions"
        find . -type f -print0 | xargs -0 chmod $FILEPERM
        find . -type f -print0 | xargs -0 chown $USER:$GROUP
        echo "   Fixing Directory Permissions"
        find . -type d -print0 | xargs -0 chmod $DIRPERM
        find . -type d -print0 | xargs -0 chown $USER:$GROUP
        echo " * done."
    else
        echo " ! Invalid response."
    fi
}

function mcdrom {
    local mounted
    local cpwd
    mounted=$(grep cdrom /etc/mtab)
    if [[ $mounted = "" ]];then
        mount /cdrom
        echo "-- mounted cdrom --"
        cd /cdrom ; ls
    else
        cpwd=$(pwd|grep cdrom)
        if [[ $cpwd = "" ]];then
            umount /cdrom
            echo "-- umounted cdrom --"
        else
            cd;umount /cdrom
            echo "-- umounted cdrom --"
            pwd
            eject
        fi
    fi
}

function extractrar {
    FILE=$(basename "$1" .rpm)
    rpm2tar "$1"
    mkdir -p ${FILE}
    tar -xvf ${FILE}.tar -C ${FILE}
}

function createlzma {
    lzma -q -9 $1
}

function extractlzma {
    TARFILE=$(basename $1 .lzma)
    unlzma $1
    mkdir -p ${TARFILE}
    tar xvf $TARFILE.tar -C ${TARFILE}
}

function open {
    if [[ -f "$1" ]]
    then
        case "$1" in
            (*.tar.bz2) tar -xvjf "$1" ;;
            (*.tar.gz) tar -xvzf "$1" ;;
            (*.ace) unace e "$1" ;;
            (*.rar) unrar x "$1" ;;
            (*.deb) ar -x "$1" ;;
            (*.bz2) bzip2 -d "$1" ;;
            (*.lzh) lha x "$1" ;;
            (*.gz) gunzip -d "$1" ;;
            (*.tar) tar -xvf "$1" ;;
            (*.rpm) extractrar "$1" ;;
            (*.lzma) extractlzma "$1" ;;
            (*.tgz) gunzip -d "$1" ;;
            (*.tbz2) tar -jxvf "$1" ;;
            (*.zip) unzip "$1" ;;
            (*.Z) uncompress "$1" ;;
            (*.shar) sh "$1" ;;
            (*.7z) 7z x "$1" ;;
            (*) echo "'"$1"' Error. Please go away" ;;
        esac
    else
        echo "'"$1"' is not a valid file"
    fi
}

function mps { /bin/ps $@ -u $USER -o pid,ppid,%cpu,%mem,command ; }

function mpsu { /bin/ps -u $@ -o pid,ppid,%cpu,%mem,command ; }

# $1 should be something like /dev/sdb1
function deviceinfo { udevinfo -a -p $(udevinfo -q path -n $1) }

function ech {
    chpth=`qlist -C -I -e $1`
    if [[ -n $chpth ]]; then
        $PAGER /usr/portage/$chpth/ChangeLog
    else
        echo "No such package named $1"
    fi
}

function junk {
    scp -r $* norush:~/www/stuff/
}

function torrent {
    scp -r $* quad:~/.torrents/
}

function dotfile {
    scp -r $* web:~/blog/shared/dotfiles/
}

function pcache {
    paludis --regenerate-installable-cache
    paludis --regenerate-installed-cache
}

function manifest {
    appareo --log-level warning --master-repository-name gentoo --extra-repository-dir /usr/portage --extra-repository-dir $PWD $1 -m
}

function qa {
    qualudis --log-level warning --master-repository-name gentoo --extra-repository-dir /usr/portage --extra-repository-dir $PWD $1 
}

function gitsearch {
    git grep $* $(git log -g --pretty=format:%h)
}

# http://polatel.wordpress.com/2009/05/05/paludis-resume-files/
function plast {
    local index
    local lastfile
    local cmd
 
    # Sanity check
    if [[ -z "${PALUDIS_RESUME_DIR}" ]]; then
        echo "PALUDIS_RESUME_DIR not set" >&2
        return 1
    elif [[ ! -d "${PALUDIS_RESUME_DIR}" ]]; then
        echo "${PALUDIS_RESUME_DIR} is not a directory" >&2
        return 1
    fi
 
    index=${1:-1}
    lastfile=$(print "${PALUDIS_RESUME_DIR}"/*(om[${index}]))
    if [[ ! -f "${lastfile}" ]]; then
        echo "no file at index ${index}" >&2
        return 1
    fi
 
    eval sudo $(< "${lastfile}")
}
 
function isocdrom {
    dd if=/dev/cdrom of=$1 bs=2048
}

function fix-paludis-perms {
    mkdirs=(/usr/portage/.cache/names /usr/portage/distfiles /var/tmp/paludis /etc/paludis)
    fixdirs=(/usr/portage /var/tmp/paludis /etc/paludis)
    repodir="/var/paludis/repositories"
    for dir in $mkdirs;
    do
        mkdir -p $dir
    done
    for dir in $fixdirs;
    do
        chown -R paludisbuild:paludisbuild $dir
        find $dir -type d -exec chmod g+wrx {} \;
    done
    if [ -d $repodir ]; then
        for repo in `ls --color=never -Fd *(-/DN)`;
        do
            mkdir -p $repo/.cache/names
            chown -R paludisbuild:paludisbuild $repo
            find $repo -type d -exec chmod g+wrx {} \;
        done
    fi
    pcache # see function above
}

function remove_all_gems {
    gem list --no-versions | sed -r '/^(\*|$)/d' | xargs sudo gem uninstall 
}

function confcat {
    grep -vh '^[[:space:]]*#' "$@" | grep -v '^$'
}

function pgrep {
    ps aux | grep $@ | grep -v grep | grep -v "pgrep" | column -t
}

function sg {
    local last_path=`script/generate $@ | awk '/db\/migrate\//{print $NF}'`
    if [ $last_path ]; then $EDITOR $last_path && rake db:migrate; fi
}

function http_headers {
    curl -I -L $@
}

function mktar {
    tar jcvf "${1%%/}.tar.bz2" "${1%%/}/"
}

function sanitize {
    chmod -R u=rwX,go=rX "$@"
    chown -R ${USER}:users "$@"
}

# Start nginx and tail the logfile
# catch ^C and kill nginx
function ss {
    TRAPINT() {
        print "Caught Control C, shutting down nginx"
        sudo /etc/init.d/nginx stop
    }
    sudo /etc/init.d/nginx start
    tail -f log/development.log

}

# Stolen:
# http://cinderwick.ca/files/configs/bashrc

# remindme - a simple reminder
# usage: remindme <time> <text>
# e.g.: remindme 10m "omg, the pizza"
function remindme {
    sleep $1 && zenity --info --text "$2" &
}

function background {
    nohup $1 &> /dev/null &    
}

function cdgem {
    cd `gem env gemdir`/gems
    cd `ls --color=never | grep --color=never $1 | sort | tail -1`
}

function keepempty {
    for i in $(find . -type d -regex ``./[^.].*'' -empty); do touch $i"/.gitignore"; done;
}

function xephyr {
    Xephyr -ac -br -noreset -screen 1024x768 :1 &
    sleep 5
    DISPLAY=:1.0 $@
}

function cpv {
    rsync -rPIhb --backup-dir=/tmp/rsync -e /dev/null -- ${@}
}

function h { 
    history 0 | grep $1 
}

function ports {
case `uname` in
    OpenBSD)
        sudo netstat -at | grep LISTEN
    ;;
    FreeBSD)
        sudo sockstat -4 -l
    ;;
    Linux)
        sudo netstat -lptu
    ;;
    *)
        nmap -sT -O localhost
    ;;
esac
}

# Recompiles .zshrc
src () {
    autoload -U zrecompile
    [ -f ~/.zshrc ] && zrecompile -p ~/.zshrc
    [ -f ~/.zcompdump ] && zrecompile -p ~/.zcompdump
    [ -f ~/.zshrc.zwc.old ] && rm -f ~/.zshrc.zwc.old
    [ -f ~/.zcompdump.zwc.old ] && rm -f ~/.zcompdump.zwc.old
    source ~/.zshrc
}
# }}}

# {{{ zkbd (keybindings)
################################################################################
# Get keys working
#
# For this to work you have to first run 'zsh /usr/share/zsh/4.3.4/functions/Misc/zkbd'.
# The location of this script on your system may vary.
# Also note you must change the 'source' line below to match your zkbd config.
#################################################################################

bindkey -v
if [[ -f ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
    source ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
else
    echo "no zkbd file, run zkbd"
fi

#################################################################################
# Set some keybindings
#################################################################################
# Bind the keys that zkbd set up to some widgets
[[ -n ${key[Home]} ]]      && bindkey "${key[Home]}"      beginning-of-line
[[ -n ${key[Delete]} ]]    && bindkey "${key[Delete]}"    delete-char
[[ -n ${key[End]} ]]       && bindkey "${key[End]}"       end-of-line
[[ -n ${key[Up]} ]]        && bindkey "${key[Up]}"        history-search-backward 
[[ -n ${key[Left]} ]]      && bindkey "${key[Left]}"      backward-char
[[ -n ${key[Down]} ]]      && bindkey "${key[Down]}"      history-search-forward
[[ -n ${key[Right]} ]]     && bindkey "${key[Right]}"     forward-char
[[ -n ${key[PageUp]} ]]    && bindkey "${key[PageUp]}"    history-incremental-search-backward
[[ -n ${key[PageDown]} ]]  && bindkey "${key[PageDown]}"  history-incremental-search-forward
bindkey '^xh' run-help
autoload edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^xx' execute-named-cmd
bindkey "^K"      kill-whole-line                      # ctrl-k
bindkey "^A"      beginning-of-line                    # ctrl-a  
bindkey "^E"      end-of-line                          # ctrl-e
bindkey "^R"      history-incremental-search-backward  # ctrl-r

# }}} 

# {{{ Prompt
for zshrc_snipplet in ~/.zsh/prompt/S[0-9][0-9]*[^~] ; do
   source $zshrc_snipplet
done
if (( EUID == 0 )); then
    PROMPT=$'%{\e[01;31m%}%n@%m%{\e[0m%}[%{\e[01;34m%}%3~%{\e[0;m%}](%?)$(get_git_prompt_info)%# '
else
    PROMPT=$'%{\e[01;32m%}%n@%m%{\e[0m%}[%{\e[01;34m%}%3~%{\e[0;m%}](%?)$(get_git_prompt_info)%% '
fi
# }}}

# {{{ Path
script_path=(~/code/bin/conky ~/code/bin/clipboard)
path=($path /usr/local/bin /usr/bin /bin /usr/local/bin /usr/local/sbin /usr/X11R6/bin ${HOME}/code/bin /opt/virtualbox /usr/share/texmf/bin /usr/lib/jre1.5.0_10/bin /usr/games/bin /usr/libexec/git-core /opt/icedtea6-bin-1.4.1/bin /opt/sun-jre-bin-1.6.0.14/bin /opt/VirtualBox $script_path ~/bin)
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
cdpath=($cdpath ~/code/bin/)
if (( EUID == 0 )); then
    rootpath=(/sbin /usr/sbin /usr/local/sbin)
    # Don't think this is an issue any longer but waiting to find out...
    # hack to fix "Can not write to history" after leaving sudo or su
    # sudo does not export enviroment vars
    #SAVEHIST=1000
    #HISTFILE=~root/.history_zsh
    #HISTSIZE=1000
    #HOME=/root
fi

# remove duplicate entries from path,cdpath,manpath & fpath
typeset -gU path cdpath manpath fpath
# }}}

# {{{ Run devtodo != root

if [ -x /usr/bin/devtodo ]; then
    if (( EUID != 0 )); then
        /usr/bin/devtodo
    fi
fi
# }}}

# vim: set et sw=4 sts=4 ts=4 ft=zsh :
