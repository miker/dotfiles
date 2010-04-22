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
#DEFAULTWM='openbox'
#DEFUALTWM="subtle"


# Set some enviroment varibles
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin
export TMP=$HOME/.tmp
export TMDIR=$TMP
export TERMCMD=/usr/bin/urxvt
#export BROWSER=/usr/bin/chrome
#export BROWSER=/usr/bin/uzbl-browser
export BROWSER=/usr/bin/firefox
export TERMINAL=$TERMCMD
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export MOZILLA_NEWTYPE=tab
export SSH_ASKPASS=/usr/bin/gnome-ssh-askpass
#export XDG_CACHE_DIR="/var/cache/users/gregf/"
RXVT_SOCKET="$HOME/.tmp/rxvt-unicode"
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

unclutter -idle 30 -reset -root &

xset -b +dpms r rate 250 50 &

# Get back ctrl+alt+backspace in new versions of xorg
setxkbmap -option terminate:ctrl_alt_bksp

# Load Xdefaults
if [ -f "$userresources" ]; then
if [ -x /usr/bin/cpp ] ; then
xrdb -merge "$userresources"
  else
xrdb -nocpp -merge "$userresources"
  fi
fi
 
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# Disable repeat for multimediakeys
xset -r 129 -r 231 -r 198 -r 236 -r 160 &

nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 &

xsetroot -solid black &

# Turn on numlock
numlockx on &

if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
  eval `dbus-launch --sh-syntax --exit-with-session`
fi

#sync PRIMARY with clipboard 
autocutsel -s PRIMARY -buttonup -fork &

xsetroot -cursor_name arrow &

urxvtd -q -o -f &

# Ask for keychain password
keychain --agents ssh,gpg --clear -q ~/.ssh/id_rsa
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
*)
	exec $DEFAULTWM & wmpid=$1
	;;
esac

# Run these after the window manager has been started
~/code/bin/wallpaper/wallpaper.rb &
nice -n10 ${BROWSER} & 
nice -n19 gpodder &
xsetroot -cursor_name left_ptr &
orage &
caffeine &
conky -d &

wait $wmpid
