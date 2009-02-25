#!/bin/sh
# ----------------------------------------------------------------------------
# File:     ~/.xinitrc
# Author:   Greg Fitzgerald <netzdamon@gmail.com>
# Modified: Tue 24 Feb 2009 10:05:46 PM EST
# ----------------------------------------------------------------------------

# Set your Default Window Manager
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

#xmodmap ~/.Xmodmap
xset -b -bc +dpms r rate 250 50
xrdb -load ~/.Xdefaults

# Load multimedia keys
xmodmap ~/.Xmodmap

# Load Xdefaults
xrdb -load ~/.Xdefaults

# Disable repeat for multimediakeys
xset -r 129 -r 231 -r 198 -r 236 -r 160

# Make capslock key equal to escape
#xmodmap -e "remove lock = Caps_Lock"
#xmodmap -e "keysym Caps_Lock = Escape"

# Not needed with 180.06 and above.
nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1

xsetroot -solid black &

# Turn on numlock
numlockx on

# Ask for keychain password
keychain --clear -q ~/.ssh/id_dsa
source ~/.keychain/`hostname`-sh > /dev/null

# Execute window manager into background
exec $DEFAULTWM & wmpid=$!
   nitrogen --restore &
   #~/code/bin/wallpaper/wallpaper.rb &
   #~/gmail.rb start &
   conky &
   xsetroot -cursor_name arrow &
   dbus-launch --exit-with-session &
   nice -n19 ${BROWSER} 
   nice -n19 gpodder &
wait $wmpid
