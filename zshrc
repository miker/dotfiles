# ----------------------------------------------------------------------------
# File:     ~/.zshrc
# Author:   Greg Fitzgerald <netzdamon@gmail.com>
# Modified: Mon 02 Mar 2009 10:12:35 PM EST
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
        export PKG_PATH=ftp://ftp.openbsd.org/pub/OpenBSD/4.3/packages/`machine -a`/

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
        alias cvsup="cd /usr; cvs -d anoncvs@anoncvs1.usa.openbsd.org:/cvs checkout -P -rOPENBSD_4_3 src"
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
            export RUBYOPT="" #will break gentoo's ebuild for rubygems, if your using it comment this out
            alias ms="mirrorselect -b10 -s5 -D"
            alias python-updater="python-updater -P paludis"
            alias dp="dispatch-conf"
            alias keywords='sudo vim /etc/paludis/keywords.conf'
            alias use='sudo vim /etc/paludis/use.conf'
            alias mask='sudo vim /etc/paludis/package_mask.conf'
            alias unmask='sudo vim /etc/paludis/package_unmask.conf'
            alias bashrc='sudo vim /etc/paludis/bashrc'
            alias df='df -hT'

            export ECHANGELOG_USER="Greg Fitzgerald <netzdamon@gmail.com>"
            export PALUDIS_OPTIONS="--continue-on-failure if-satisfied --show-reasons summary --dl-reinstall-scm weekly --log-level warning --dl-reinstall if-use-changed --show-use-descriptions changed"

            function paludis-scm {
                PALUDIS_OPTIONS="--dl-reinstall-scm daily"
                paludis $@
                PALUDIS_OPTIONS="--dl-reinstall-scm never"
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
if [[ -d /var/tmp/ccache ]]; then
    (( ${+CCACHE_DIR} )) || export CCACHE_DIR="/var/tmp/ccache"
    (( ${+CCACHE_SIZE} )) || export CCACHE_SIZE="2G"

fi

# To many stupid scripts don't unset this so I'm using an alias for now
#export GREP_OPTIONS="--color=auto -nsi"
(( ${+TZ} )) || export TZ="EST5EDT"
export MPD_HOST="/home/gregf/.mpd/socket"
export GIT_AUTHOR_EMAIL="netzdamon@gmail.com"
export GIT_AUTHOR_NAME="Greg Fitzgerald"
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

# Some things we want set regardless
export MANPAGER="most"
export PAGER="most"
export EDITOR="vim"
export VISUAL="vim"
export NNTPSERVER="news.gwi.net"
export GPG_TTY=`tty` #backticks required
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
        xterm*|rxvt)
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
alias mn="nice -n1 mplayer -nosound"
alias e="gvim"
alias v="vim"
alias t="thunar"
alias repo='cd /var/paludis/repositories'
alias scm='cd /home/gregf/code/scm/'
alias ov='cd /home/gregf/code/scm/gregf-overlay'
alias sc='script/console'
alias ss='script/server'
alias sp='script/plugin'
alias db='script/dbconsole'
alias sgmo="sg model $@"
alias sgmi="sg migration $@"
alias setmid='rm -f db/*.sqlite3 ; rake db:migrate && rake admin:create'
alias a='autotest -rails'
alias tlog='tail -f log/development.log'
alias rst='touch tmp/restart.txt'
alias scaffold='script/generate shoulda_scaffold'
alias migrate='rake db:migrate db:test:clone'
alias gi='sudo gem install --no-ri --include-dependencies'
alias giti="vim .gitignore"
alias gs='gem search -b'
alias vmware='VMWARE_USE_SHIPPED_GTK=yes /opt/vmware/workstation/bin/vmware'
alias burniso='wodim -v dev=/dev/cdrw'
alias burndvdiso='growisofs -speed=8 -dvd-compat -Z /dev/dvdrw=$1'
alias usepretend='sudo paludis -ip --dl-reinstall if-use-changed'
alias usedo='sudo paludis -i --dl-reinstall if-use-changed'
alias ketchup='ketchup -G'
alias installed="eix -I --nocolor -c > /tmp/installed.txt && most /tmp/installed.txt && rm /tmp/installed.txt"
alias biosinfo='sudo dmidecode'
alias pwgen='pwgen -sBnc 10'
alias la="ls -a"
alias l="ls"
alias f-spot='dbus-launch f-spot'
alias d="devtodo"
alias gnp="git-notpushed"
alias s="sudo"
alias sx="startx"
alias ej="eject"
alias k="killall"
alias cap='/usr/X11R6/bin/cap'
alias poweroff='sudo poweroff'
alias reboot='sudo reboot'
alias oa='openarena'
alias savage="~/code/bin/savage/savage.sh"
alias wcyy="mplayer http://68.142.81.164:80/citadelcc_WCYY_FM\?MSWMExt\=.asf"
alias wkit="mplayer http://64.92.199.73/WKIT-FM"
alias dropcache='sudo echo 3 > /proc/sys/vm/drop_caches'
alias deploy='cap deploy:migrations'
alias lock='alock -auth pam -bg blank:color=black'
alias lsnoext="ls | grep -v '\.'"
alias cleanliferea="sqlite3 ~/.liferea_1.4/liferea.db vacuum"
alias starcraft=' wine ~/.wine/drive_c/Program\ Files/Starcraft/StarCraft.exe'
alias gis="git status | grep --color=always '^[^a-z]\+\(new file:\|modified:\)' | cut -d'#' -f2-"
alias lk='lynx -dump http://kernel.org/kdist/finger_banner'
alias dosbox='dosbox -conf ~/.dosbox.conf -fulscreen'
alias ports='lsof -i'
alias vim="vim -p"
alias ra3="wine /home/gregf/.wine/drive_c/Program\ Files/Electronic\ Arts/Red\ Alert\ 3/RA3.exe"
alias nfs="cd /home/gregf/.wine/drive_c/Program\ Files/EA\ Games/Need\ for\ Speed\ Undercover/; wine nfs.exe; cd ~"
alias wog="cd /home/gregf/.wine/drive_c/Program\ Files/WorldOfGoo/; wine WorldOfGoo.exe; cd ~ && xrandr -s 0"
alias g='grep -Hn --color=always'
alias cal='cal -3'
alias ra="echo 'awful.util.restart()' | awesome-client -"
alias mutt="TERM=xterm-256color mutt"
alias sv="gvim --remote-tab-silent"
# }}}

# {{{ Completion
###############################################################################
# Lots of autocompletion options
################################################################################
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit zrecompile
compinit

# Follow GNU LS_COLORS
zmodload -i zsh/complist
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*' list-colors '=%*=01;31'

compctl -g '*.Z *.gz *.tgz' + -g '*' zcat gunzip tar open
compctl -g '*.tar.Z *.tar.gz *.tgz *.tar.bz2' + -g '*' tar bzip2 open
compctl -g '*.zip *.ZIP' + -g '*' unzip zip open
compctl -g '*.rar *.RAR' + -g '*' rar unrar open
compctl -g '*.(mp3|MP3|ogg|OGG|WAV|wav|ogv|OGV)' + -g '*(-/)'  ogg123 mpg123 audacious wma123 mplayer vlc
compctl -g '*.(divx|DIVX|m4v|M4V|wmv|WMV|avi|AVI|mpg|mpeg|MPG|MPEG|WMV|wmv|mov|MOV|wma|WMA|w4a|W4A|part|PART)' + -g '*(-/)'  xine mplayer kmplayer gmplayer vlc
compctl -g '*.(pdf|PDF|ps|PS|tiff|TIFF)' + -g '*(-/)' evince acroread xpdf epdfview
compctl -g '*.(jpg|JPG|jpeg|JPEG|gif|GIF|tiff|TIFF|png|PNG|tga|TGA)' + -g '*(-/)' feh gthumb xv f-spot gqview

# Select Prompt
zstyle ':completion:*' menu select=1

# Expansion options
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion:*' use-cache on
#zstyle ':completion:*' cache-path ~/.tmp/zsh/cache


# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands

zstyle ':completion::complete:*' '\'

# Use menuselection for pid completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

#  tag-order 'globbed-files directories' all-files
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# With commands like rm, it's annoying if you keep getting offered the same
# file multiple times. This fixes it. Also good for cp, et cetera..
#zstyle ':completion:*:rm:*' ignore-line yes
#zstyle ':completion:*:cp:*' ignore-line yes

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
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
hash_cmds hash_dirs numeric_glob_sort vi

unset beep equals mail_warning
# }}}

# {{{ Functions

function zkbd {
    ZVER=(`zsh --version | awk '{print $2}' -`)
    zsh /usr/share/zsh/${ZVER}/functions/Misc/zkbd
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
        # execute real `date'
        command date $@
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
            (*) echo "'"$1"' Error. Please go away" ;;
        esac
    else
        echo "'"$1"' is not a valid file"
    fi
}

function mps { /bin/ps $@ -u $USER -o pid,ppid,%cpu,%mem,command ; }

function mpsu { /bin/ps -u $@ -o pid,ppid,%cpu,%mem,command ; }

function ech {
    CHPTH=`eix --only-names -e $1`
    most /usr/portage/$CHPTH/ChangeLog
}

function junk {
    scp -r $* norush:~/www/stuff/
}

function dotfile {
    scp -r $* web:~/blog/shared/dotfiles/
}

function pcache {
    paludis --regenerate-installable-cache
    paludis --regenerate-installed-cache
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
        chgrp -R paludisbuild $dir
        find $dir -type d -exec chmod g+wrx {} \;
    done
    cd $repodir
    if [ $? == 0 ]; then
        for repo in `ls --color=never -Fd *(-/DN)`;
        do
            mkdir -p $repo/.cache/names
            chgrp -R paludisbuild $repo
            find $repo -type d -exec chmod g+wrx {} \;
        done
    fi
    pcache # see function above
}

function confcat {
    grep -vh '^[[:space:]]*#' "$@" | grep -v '^$'
}

function sg {
    local last_path=`script/generate $@ | awk '/db\/migrate\//{print $NF}'`
    if [ $last_path ]; then $EDITOR $last_path && rake db:migrate; fi
}

function http_headers {
    curl='whence curl'
    curl -I -L $@
}

function mktar {
    tar jcvf "${1%%/}.tar.bz2" "${1%%/}/"
}

function sanitize {
    chmod -R u=rwX,go=rX "$@"
    chown -R ${USER}:users "$@"
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
if [[ -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]]; then
    source ~/.zkbd/$TERM-$VENDOR-$OSTYPE
else
    echo "no zkbd file, run zkbd"
fi

#################################################################################
# Set some keybindings
#################################################################################
# Bind the keys that zkbd set up to some widgets
[[ -n ${key[Home]} ]]      && bindkey "${key[Home]}"      beginning-of-line
[[ -n ${key[PageUp]} ]]    && bindkey "${key[PageUp]}"    up-line-or-history
[[ -n ${key[Delete]} ]]    && bindkey "${key[Delete]}"    delete-char
[[ -n ${key[End]} ]]       && bindkey "${key[End]}"       end-of-line
[[ -n ${key[PageDown]} ]]  && bindkey "${key[PageDown]}"  down-line-or-history
[[ -n ${key[Up]} ]]        && bindkey "${key[Up]}"        up-line-or-search
[[ -n ${key[Left]} ]]      && bindkey "${key[Left]}"      backward-char
[[ -n ${key[Down]} ]]      && bindkey "${key[Down]}"      down-line-or-search
[[ -n ${key[Right]} ]]     && bindkey "${key[Right]}"     forward-char
[[ -n ${key[PageUp]} ]]    && bindkey "${key[PageUp]}"    history-incremental-search-backward
[[ -n ${key[PageDown]} ]]  && bindkey "${key[PageDown]}"  history-incremental-search-forward
# }}} 

# {{{ Prompt
for zshrc_snipplet in ~/.zsh/prompt/S[0-9][0-9]*[^~] ; do
        source $zshrc_snipplet
done
#if (( EUID == 0 )); then
    #PROMPT=$'%{\e[01;31m%}%n@%m%{\e[0m%}[%{\e[01;34m%}%3~%{\e[0;m%}](%?)$(get_git_prompt_info)%# '
#else
    #PROMPT=$'%{\e[01;32m%}%n@%m%{\e[0m%}[%{\e[01;34m%}%3~%{\e[0;m%}](%?)$(get_git_prompt_info)%% '
#fi
# }}}

# {{{ Path
script_path=(~/code/bin/conky ~/code/bin/clipboard)
path=($path /usr/local/bin /usr/bin /bin /usr/X11R6/bin ${HOME}/code/bin /opt/virtualbox /usr/share/texmf/bin /usr/lib/jre1.5.0_10/bin /usr/games/bin /usr/libexec/git-core $script_path)
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
cdpath=($cdpath ~/code ~/code/bin/)
if (( EUID == 0 )); then
    rootpath=(/sbin /usr/sbin /usr/local/sbin)
    # hack to fix "Can not write to history" after leaving sudo or su
    # sudo does not export enviroment vars
    SAVEHIST=1000
    HISTFILE=~root/.history_zsh
    HISTSIZE=1000
    #HOME=/root
fi
# }}}

# {{{ Run devtodo != root

if [ -x /usr/bin/devtodo ]; then
    if (( EUID != 0 )); then
        /usr/bin/devtodo
    fi
fi
# }}}

# vim: set et fenc=utf-8 ff=unix sts=4 sw=4 ts=4 tw=80 :
