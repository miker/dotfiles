#!/bin/sh
# ----------------------------------------------------------------------------
# File:     ~/.xinitrc
# Author:   Greg Fitzgerald <netzdamon@gmail.com>
# Modified: Fri 07 Aug 2009 10:07:29 PM EDT
# ----------------------------------------------------------------------------

# Set your Default Window Manager
DEFAULTWM='awesome'
#DEFAULTWM='subtle -c ~/.config/subtle/subtle.rb'


# Set some enviroment varibles
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin
export TMP=$HOME/.tmp
export TMDIR=$TMP
export TERMCMD=/usr/bin/urxvt
export BROWSER=/usr/bin/firefox
export TERMINAL=$TERMCMD
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export MOZILLA_NEWTYPE=tab
RXVT_SOCKET="$HOME/.tmp/rxvt-unicode"
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

unclutter -idle 30 -reset -root &

xset -b -bc +dpms r rate 250 50 &

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

# Make capslock key equal to escape
#xmodmap -e "remove lock = Caps_Lock"
#xmodmap -e "keysym Caps_Lock = Escape"

nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 &

xsetroot -solid black &

# Turn on numlock
numlockx on &

# Ask for keychain password
keychain --agents ssh,gpg --clear -q ~/.ssh/id_dsa
source ~/.keychain/$(uname -n)-sh
source ~/.keychain/$(uname -n)-sh-gpg


if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
  eval `dbus-launch --sh-syntax --exit-with-session`
fi

#sync PRIMARY with clipboard 
autocutsel -s PRIMARY -buttonup -fork &

xsetroot -cursor_name arrow &

urxvtd -q -o -f &

# Execute window manager into background
exec $DEFAULTWM & wmpid=$!
    nitrogen --restore &
    conky -d &
    nice -n19 ${BROWSER} & 
    nice -n19 gpodder &
    orage &
wait $wmpid
