# Wait a second then load up default session apps
#if [ -f ~/.fehbg ]; then
    #source ~/.fehbg &
#else
    #feh --bg-scale /home/gregf/.wallpaper/cup.jpg &
#fi

nitrogen --restore &

#ssh -f -n -N gila &
#ssh -f -n -N web &
#ssh -f -n -N miker &

dbus-launch --exit-with-session  &
#xscreensaver -no-splash &
lomoco -8 --sms &
#xcompmgr &   # shadows and fades
xcompmgr -cC -t-3 -l-5 -r5 -o.65 &   # shadows
#xcompmgr -cCfF -r7 -o.65 -l-10 -t-8 -D7 &   # shadows and fades
xterm -e "screen -xRD -S $USER.$HOST" &
devilspie &
nice -n15 firefox &
(sleep 4 && ipager &)
nice -n19 liferea &
tint -c ~/.tintrc &
~/code/bin/conky/conky.sh start &
