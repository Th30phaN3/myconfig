#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
userprofile=$HOME/.xprofile
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap

# Merge in defaults, keymaps and profiles
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

if [ -f "$userprofile" ]; then
  . "$userprofile"
fi

if [ -n /etc/X11/chooser.sh ]; then
  command=/etc/X11/chooser.sh
else
  failsafe=yes
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?* ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Start some applications
# Add random wallpaper
feh --bg-scale --randomize --no-fehbg /home/wegeee/pics/wallpapers/desktop/*
# Call wal to set X colors (-R restores the last colorscheme, -n skip setting the wallpaper, -q quiet mode, -o restore config files)
wal -Rnq -o "${HOME}/.config/wal/done.sh"
# Init compton
compton -b --config "${HOME}/.config/compton/compton.conf"
# Enable Razer macros
bwidow -s #TODO: call only when keyboard plugged
# Init xbindkeys
xbindkeys
# Enable numlock on X
numlockx
# Init Bash at X startup
#source ~/.bashrc
# Source dmenu configuration
#source ~/.config/dmenu/dmenurc
# Launch i3 with dbus (export $DBUS_SESSION_BUS_ADDRESS and $DBUS_SESSION_BUS)
exec dbus-launch --exit-with-session i3
