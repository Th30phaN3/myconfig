#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi
­
if [ -n /etc/X11/chooser.sh ]; then
  command=/etc/X11/chooser.sh
else
  failsafe=yes
fi

#Start some applications
#Add random wallpaper
feh --bg-scale --randomize --no-fehbg ~/pics/wallpapers/desktop/*
# -R restores the last colorscheme that was in use.
# -n skip setting the wallpaper.
# -q quiet mode, don't print anything
wal -Rnq
#Init compton
compton -b --config /home/wegeee/.config/compton/compton.conf
#Init xbindkeys for blackwidow macros
xbindkeys
#Enable numlock on X
numlockx
#Launch Transmission
#transmission-daemon
#Launch mpd as local user
mpd
#Launch i3
exec i3

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?* ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

if [ -n "$failsafe" ]; then
 twm &
 xclock -geometry 50x50-1+1 &
 xterm -geometry 80x50+494+51 &
 xterm -geometry 80x20+494-0 &
 exec xterm -geometry 80x66+0+0 -name login
else
 exec $command
fi