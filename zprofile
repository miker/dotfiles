# autologin tty2
[ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] && startx
