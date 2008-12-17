###############################################################################
# Zsh settings file for Greg Fitzgerald <netzdamon@gmail.com>
#
# Most recent update: Wed Oct  8 15:24:37 2008
###############################################################################
# TODO
# . ~/.zsh/config
# . ~/.zsh/aliases
# . ~/.zsh/complete
# [[ -f ~/.localrc ]] && . ~/.localrc
# Split functions into ~/.zsh/functions/functioname
##############################################################################
# Test for an interactive shell. There is no need to set anything
# past this point for scp, and it's important to refrain from
# outputting anything in those cases.
##############################################################################
# by default, we want this to get set.
# Even for non-interactive, non-login shells.
if [ "`id -gn`" = "`id -un`" -a `id -u` -gt 99 ]; then
        umask 002
  else
        umask 022
fi

if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now
	return
fi
#################################################################################
# Create some default files/directories if they don't exist.
################################################################################
if ! [ -d ~/.ssh ]; then
    mkdir -p ~/.ssh
fi

if ! [ -f ~/.ssh/known_hosts ]; then
    touch ~/.ssh/known_hosts
fi

if ! [ -f ~/.viminfo ]; then
    touch ~/.viminfo
fi
##############################################################################
#       Clear screen on logout
##############################################################################
trap clear 0
#############################################################################
#       OS specific settings
#############################################################################
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
        #SSH_ASKPASS="/usr/local/bin/ssh-askpass-gtk2"
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

        if [[ -f /etc/gentoo-release ]]; then
            export RUBYOPT="" #will break gentoo's ebuild for rubygems, if your using it comment this out
            alias ms="mirrorselect -b10 -s5 -D"
            alias python-updater="python-updater -P paludis"
            alias dp="dispatch-conf"

            export ECHANGELOG_USER="Greg Fitzgerald <netzdamon@gmail.com>"
            export PALUDIS_OPTIONS="--show-reasons summary --dl-reinstall-scm weekly --log-level warning --dl-reinstall if-use-changed --show-use-descriptions changed"

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

            function rca {
                sudo /sbin/rc-update add $1 default
            }

            function rcd {
                sudo /sbin/rc-update del $1 default
            }

            function instkernel {
                if ![ -f $PWD/.config ]; then
                    echo "Please run make menuconfig first"
                    exit
                fi
                if ![ EUID == 0 ]; then
                    echo "You must be root to run this"
                    exit
                fi
                mount /boot
                make clean
                make -j3 all && make -j3 modules_install && make -j3 install
                vim /boot/grub/grub.conf
                umount /boot
                echo "You are now ready to reboot."
            }

        fi

        # We Want utf8
        export LC_CTYPE=en_US.utf8
        export LC_ALL=en_US.UTF8

	    #aliases
        alias ls='ls -F --color --human-readable'

        if [ $HOST  = "gila" ]; then
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
	;;
esac

################################################################################
#      Enviroment Variables
################################################################################
unset MAILCHECK
if [[ -d /var/tmp/ccache ]]; then
    (( ${+CCACHE_DIR} )) || export CCACHE_DIR="/var/tmp/ccache"
    (( ${+CCACHE_SIZE} )) || export CCACHE_SIZE="2G"

fi
## (( ${+*} )) = if variable is set don't try to set it again
#(( ${+GREP_OPTIONS} )) || export GREP_OPTIONS="--color=auto -nsi"
(( ${+TZ} )) || export TZ="EST5EDT"
(( ${+MPD_HOST} )) || export MPD_HOST="127.0.0.1"
(( ${+MPD_PORT} )) || export MPD_PORT="6600"
(( ${+GIT_AUTHOR_EMAIL} )) || export GIT_AUTHOR_EMAIL="netzdamon@gmail.com"
(( ${+GIT_AUTHOR_NAME} )) || export GIT_AUTHOR_NAME="Greg Fitzgerald"
(( ${+GIT_COMMITTER_EMAIL} )) || export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

# Some things we want set regardless
export MANPAGER="most"
export PAGER="most"
export EDITOR="vim"
export VISUAL="vim"
export NNTPSERVER="news.gwi.net"

################################################################################
# Resource Limits
################################################################################
limit stack 8192
#limit core unlimited
limit core 0
limit -s
###############################################################################
# Setup History Options
################################################################################
HISTSIZE=10000
HISTFILE=${HOME}/.history_zsh
SAVEHIST=10000
DIRSTACKSIZE=16
################################################################################
# Term Settings
################################################################################
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

case $TERM in
    xterm*|rxvt|(dt|k|E)term|?rxvt-*)
        # display user@host and full dir in *term title
        precmd () { print -Pn  "\033]0;%n@%m %~\007" }
        # display user@host and name of current process in *term title
        preexec () { print -Pn "\033]0;%n@%m <$1> %~\007" }
    ;;
    screen-*)
        # Set screen's window title to the command the user typed.
        preexec() { print -n '\ek'$1'\e\\' }
        # Restore a generic title if no program is running.
        precmd() { print -n '\ek'$HOST:$PWD'\e\\' }
        PROMPT_COMMAND='echo -ne "\033k$HOSTNAME\033\\"'
    ;;
esac

# Enable flow control, prevents ^k^s from locking up my screen session.
stty -ixon
################################################################################
#       Default Aliases
################################################################################
alias xlog="sudo grep --binary-files=without-match --color -nsie '(EE)' -e '(WW)' /var/log/Xorg.0.log"
alias which="whence"
alias sd='export DISPLAY=:0.0'
alias cpan="perl -MCPAN -e shell"
alias cup='cvs -z3 update -Pd'
alias mv='nocorrect /bin/mv'
alias rm='nocorrect /bin/rm -I --preserve-root'
alias shred='nocorrect ionice -c3 /usr/bin/shred -fuzv'
alias wipe='nocorrect ionice -c3 /usr/bin/wipe -l1 -v -r'
alias man='nocorrect man'
alias mkdir='nocorrect /bin/mkdir -p'
alias find='noglob find'
alias wget="wget -c"
alias lsd='ls -Fld *(-/DN)'
alias weather="/home/gregf/code/bin/forecast/forecast.rb"
alias ncmpc="ncmpc -c"
alias fixdbus="dbus-uuidgen --ensure"
alias wp="feh --bg-scale"
alias m="nice -n1 mplayer -af volnorm -stop-xscreensaver"
alias ml="nice -n1 mplayer -loop 0 -af volnorm -stop-xscreensaver"
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
alias g='gthumb'
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
alias d="devtodo -A"
alias zkbd="zsh /usr/share/zsh/4.3.4/functions/Misc/zkbd"
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
alias urb='urbanterror +connect 208.43.15.167:27960'
alias starcraft=' wine ~/.wine/drive_c/Program\ Files/Starcraft/StarCraft.exe'
alias ipager='k ipager; sleep 1; ipager &'
alias devilspie='k devilspie; sleep 1; devilspie &'
alias gis="git status | grep --color=always '^[^a-z]\+\(new file:\|modified:\)' | cut -d'#' -f2-"
alias lk='lynx -dump http://kernel.org/kdist/finger_banner'
alias update-eix='ionice -c3 update-eix'
alias dosbox='dosbox -conf ~/.dosbox.conf -fulscreen'
alias ports='netstat --inet -pln'
alias vim="vim -p"
################################################################################
# Functions and Completion
################################################################################
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

################################################################################
# Custom Functions
################################################################################

function clamscan {
    mkdir -p /tmp/virus
    nice -n 19 clamscan --verbose --max-recursion=20 -m -i --detect-pua --move=/tmp/virus -r
    cd /tmp/virus
    echo -n "Viruses:"
    ls
}

function kvmiso {
    kvm -boot d -m 384 -smp 2 -localtime \
    -net nic \
    -net user \
    -no-fd-bootchk -no-acpi -cdrom $1
}

function kvmimg {
    kvm-img create -e -f qcow2 $i.qcow 10G
}

function kvminst {
    echo "Supply disk.img and path to iso or drive for installing from"
    kvm -boot d -m 384 -smp 2 -localtime \
    -net nic \
    -net user \
    -no-fd-bootchk -no-acpi \
    -hda ~/kvm/$1.qcow -cdrom $2
}

function kvmrun {
    echo "Supply drive image to boot from"
    kvm -boot c -m 512 -smp 2 -localtime \
    -net nic \
    -net user \
    -no-fd-bootchk -no-acpi -hda ~/kvm/$1.qcow
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

function calc() { echo "$*" | bc; }

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

function mps { /bin/ps $@ -u $USER -o pid,%cpu,%mem,command ; }

function ech {
    CHPTH=`eix --only-names -e $1`
    most /usr/portage/$CHPTH/ChangeLog
}

function junk {
    scp -r $* web:~/www/stuff/
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
    cd `ls --color=never | grep $1 | sort | tail -1`
}

function keepempty {
    for i in $(find . -type d -regex ``./[^.].*'' -empty); do touch $i"/.gitignore"; done;
}

function xephyr {
    Xephyr :1 -ac -screen 1024x768 &
    sleep 3
    DISPLAY=:1 $@
}
################################################################################
# Get keys working
#
# For this to work you have to first run 'zsh /usr/share/zsh/4.3.4/functions/Misc/zkbd'.
# The location of this script on your system may vary.
# Also note you must change the 'source' line below to match your zkbd config.
#################################################################################

bindkey -v
case `echo $TERM` in
    linux)
        source ~/.zkbd/linux-pc-linux-gnu
    ;;
    xterm-color)
        source ~/.zkbd/xterm-color-pc-linux-gnu
    ;;
    xterm)
        source ~/.zkbd/xterm-pc-linux-gnu
    ;;
    xterm-xfree86)
        source ~/.zkbd/xterm-xfree86-pc-linux-gnu
    ;;
    rxvt-unicode)
        case `uname` in
            Linux)
                source ~/.zkbd/rxvt-unicode-pc-linux-gnu
            ;;
            OpenBSD)
                source ~/.zkbd/rxvt-unicode-unknown-openbsd4.3
            ;;
            *)
                source ~/.zkbd/rxvt-unicode-pc-linux-gnu
            ;;
        esac
    ;;
    rxvt)
        source ~/.zkbd/rxvt-pc-linux-gnu
    ;;
    screen|screen-*)
        case `uname` in
            OpenBSD)
                source ~/.zkbd/screen-unknown-openbsd4.3
            ;;
            Linux)
                source ~/.zkbd/screen-bce-pc-linux-gnu
            ;;
            FreeBSD)
                source ~/.zkbd/screen-bce-portbld-freebsd7.0
            ;;
        esac
    ;;
esac

#################################################################################
# Set some keybindings
#################################################################################

[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-history
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-history
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char

bindkey "^[[2~" yank
bindkey "^[[3~" delete-char
bindkey "^[[5~" up-line-or-history ## PageUp
bindkey "^[[6~" down-line-or-history ## PageDown
bindkey "^[[4~" end-of-line
bindkey "^[e" expand-cmd-path
bindkey "^[[A" up-line-or-search ## up arrow for back-history-search
bindkey "^[[B" down-line-or-search ## down arrow for fwd-history-search
bindkey " " magic-space ## do history expansion on space
bindkey "^[[1~" beginning-of-line

###############################################################################
# Set prompt based on EUID
################################################################################
if (( EUID == 0 )); then
    PROMPT=$'%{\e[01;31m%}%n@%m%{\e[0m%}[%{\e[01;34m%}%3~%{\e[0;m%}]$(pc_scm_f)%# '
else
    PROMPT=$'%{\e[01;32m%}%n@%m%{\e[0m%}[%{\e[01;34m%}%3~%{\e[0;m%}]$(pc_scm_f)%% '
fi

###############################################################################
# Lots of autocompletion options
################################################################################

# Follow GNU LS_COLORS
zmodload -i zsh/complist
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*' list-colors '=%*=01;31'

autoload -U compinit
compinit

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
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.tmp/zsh/cache/$HOST

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
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes

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

# Set some default options
# http://zsh.sourceforge.net/Doc/Release/zsh_15.html#SEC81
setopt always_to_end append_history auto_continue auto_list auto_menu \
auto_param_slash auto_remove_slash auto_resume bg_nice no_check_jobs no_hup \
complete_in_word csh_junkie_history extended_glob \
glob_complete hist_find_no_dups hist_ignore_all_dups hist_ignore_dups \
hist_ignore_space hist_no_functions hist_save_no_dups list_ambiguous \
long_list_jobs menu_complete rm_star_wait zle inc_append_history \
share_history prompt_subst no_list_beep local_options local_traps \
hist_verify extended_history hist_reduce_blanks

unset beep equals mail_warning

################################################################################
# Setup Path
################################################################################
script_path=(~/code/bin/conky ~/code/bin/clipboard)
path=($path /usr/local/bin /usr/bin /bin /usr/X11R6/bin ${HOME}/code/bin /opt/virtualbox /usr/share/texmf/bin /usr/lib/jre1.5.0_10/bin /usr/games/bin /usr/libexec/git-core $script_path)
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
#cdpath=($cdpath ~/code)
if (( EUID == 0 )); then
    rootpath=(/sbin /usr/sbin /usr/local/sbin)
    # hack to fix "Can not write to history" after leaving sudo or su
    # sudo does not export enviroment vars
    SAVEHIST=1000
    HISTFILE=~root/.history_zsh
    HISTSIZE=1000
    #HOME=/root
fi

################################################################################
# Run devtodo != root
################################################################################

if [ -x /usr/bin/devtodo ]; then
  if (( EUID != 0 )); then
    /usr/bin/devtodo
  fi
fi

# vim: set et fenc=utf-8 ff=unix sts=4 sw=4 ts=4 tw=80 :
