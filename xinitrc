#!/bin/sh
# ----------------------------------------------------------------------------
# File:     ~/.xinitrc
# Author:   Greg Fitzgerald <netzdamon@gmail.com>
# Modified: Mon 17 Aug 2009 01:54:04 PM EDT
# ----------------------------------------------------------------------------

rm -f ~/.recently-used.xbel
rm -f ~/.recently-used

# Set your Default Window Manager
DEFAULTWM='awesome'

# Set some enviroment varibles
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin
export TMP="${HOME}/.tmp"
export TMDIR="${TMP}"
export PAGER='most'
export TERMCMD=/usr/bin/urxvt
export BROWSER=/usr/bin/firefox-bin
export TERMINAL=$TERMCMD
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export MOZILLA_NEWTYPE=tab
export SSH_ASKPASS=/usr/bin/gnome-ssh-askpass
errorlog="${HOME}/.xsession-errors"
#export XDG_CACHE_DIR="/var/cache/users/gregf/"
RXVT_SOCKET="$HOME/.tmp/rxvt-unicode"

# {{{ Resource and keymap settings
usermodmap="${HOME}/.Xmodmap"
userresources="${HOME}/.Xresources"
sysmodmap="/etc/X11/xinit/.Xmodmap"
sysresources="/etc/X11/xinit/.Xresources"

# Merge system and user resources and keymaps
[[ -r "${sysresources}" ]]  && xrdb -merge "${sysresources}"
[[ -r "${sysmodmap}" ]]     && xmodmap "${sysmodmap}"
[[ -r "${userresources}" ]] && xrdb -merge "${userresources}"
[[ -r "${usermodmap}" ]]    && xmodmap "${usermodmap}"
# }}}

# Always start X11 with a clean log file
if (cp /dev/null "${errorlog}"); then
  chmod 600 "${errorlog}"
  exec >"${errorlog}" 2>&1
  break
fi

unclutter -idle 5 -root &

xset -b +dpms r rate 250 50 &

# Get back ctrl+alt+backspace in new versions of xorg
setxkbmap -option terminate:ctrl_alt_bksp

# Disable repeat for multimediakeys
xset -r 129 -r 231 -r 198 -r 236 -r 160 &

# Load additional fonts
xset fp+ ~/.fonts/

nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 &

xsetroot -solid black &

# Turn on numlock
numlockx on &

#sync PRIMARY with clipboard 
autocutsel -s PRIMARY -buttonup -fork &

# Pointer appearance
#   - xcb does not support Xcursor yet
xsetroot -cursor_name left_ptr

urxvtd -q -o -f &

# Ask for keychain password
keychain --agents ssh,gpg --clear -q ~/.ssh/id_rsa ~/.ssh/mpd_rsa
source ~/.keychain/$(uname -n)-sh
source ~/.keychain/$(uname -n)-sh-gpg

# Execute window manager into background
case $1 in
awesomewm)
    exec awesome & wmpid=$!
    ;;
openbox)
    exec openbox & wmpid=$!
    ;;
subtle)
    exec subtle & wmpid=$!
    ;;
debug)
    exec valgrind -v "$2"
    ;;
*)
    exec $DEFAULTWM & wmpid=$1
    ;;
esac

# Run these after the window manager has been started
~/code/bin/wallpaper/wallpaper.rb &
nice -n10 ${BROWSER} & 
nice -n19 gpodder &
xsetroot -cursor_name left_ptr &
caffeine &
conky -d &

wait $wmpid
