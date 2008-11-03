#!/bin/sh

# Set your Default Window Manager
DEFAULTWM='awesome'
#DEFAULTWM='startfluxbox'
#DEFAULTWM='openbox-session'


# Set some enviroment varibles
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin
export TMP=$HOME/.tmp
export TMDIR=$TMP
export TERMCMD=/usr/bin/xterm
export BROWSER=/usr/bin/firefox-bin
export TERMINAL=/usr/bin/xterm
#export MOZ_DISABLE_PANGO=1

unclutter -idle 15 -reset -root &

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
    #dbus-launch --exit-with-session  &
    #lomoco -8 --sms &
    #conky
    #xsetroot -cursor_name arrow &
    xterm &
    #nice -n15 firefox &
    #nice -n19 liferea &
wait $wmpid
