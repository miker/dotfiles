#!/bin/sh
# ----------------------------------------------------------------------------
# File:     ~/.xinitrc
# Author:   Greg Fitzgerald <netzdamon@gmail.com>
# Modified: Sat 07 Mar 2009 11:27:06 AM EST
# ----------------------------------------------------------------------------

# Set your Default Window Manager
#DEFAULTWM='awesome --config /home/gregf/.awesome/rcshifty.lua'
DEFAULTWM='awesome'
# Used to check awesome for memory leaks
#DEFAULTWM='valgrind --leak-check=full --tool=memcheck --log-file=/home/gregf/.awesome/mem.log /usr/bin/awesome'

# Set some enviroment varibles
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin
export TMP=$HOME/.tmp
export TMDIR=$TMP
export TERMCMD=/usr/bin/xterm
export BROWSER=/usr/bin/firefox
#export BROWSER="/usr/bin/epiphany -n"
#export BROWSER=/usr/bin/opera
export TERMINAL=/usr/bin/xterm
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export MOZILLA_NEWTYPE=tab

unclutter -idle 30 -reset -root &

xset -b -bc +dpms r rate 250 50 &

# Load Xdefaults
xrdb -load ~/.Xdefaults &
xmodmap ~/.Xmodmap &

# Disable repeat for multimediakeys
xset -r 129 -r 231 -r 198 -r 236 -r 160 &

# Make capslock key equal to escape
#xmodmap -e "remove lock = Caps_Lock"
#xmodmap -e "keysym Caps_Lock = Escape"

# Not needed with 180.06 and above.
nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 &

xsetroot -solid black &

# Turn on numlock
numlockx on &

# Ask for keychain password
keychain --clear -q ~/.ssh/id_dsa
source ~/.keychain/`hostname`-sh > /dev/null

if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
  eval `dbus-launch --sh-syntax --exit-with-session`
fi

#sync PRIMARY with clipboard 
autocutsel -s PRIMARY -buttonup -fork &

xsetroot -cursor_name arrow &

RXVT_SOCKET="$HOME/.tmp/rxvt-unicode"
urxvtd -q -o -f &

# Execute window manager into background
exec $DEFAULTWM & wmpid=$!
    nitrogen --restore &
    #~/code/bin/wallpaper/wallpaper.rb &
    #~/gmail.rb start &
    conky &
    nice -n19 ${BROWSER} 
    nice -n19 gpodder &
    xsetroot -cursor_name arrow &
wait $wmpid
