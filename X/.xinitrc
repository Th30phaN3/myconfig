#!/bin/sh

user_resources=$HOME/.Xresources
user_modmap=$HOME/.Xmodmap
user_profile=$HOME/.xprofile

# Merge in profile, resources and keymaps
if [ -f "$user_profile" ]; then
  source "$user_profile"
fi
if [ -f "$user_resources" ]; then
  xrdb -merge "$user_resources"
fi
if [ -f "$user_modmap" ]; then
  xmodmap "$user_modmap"
fi

# Source additional distribution-specific patches
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?* ; do
    [ -x "$f" ] && source "$f"
  done
  unset f
fi

# Start some applications
# Init compton
compton -b --config "${HOME}/.config/compton/compton.conf"
# Add random wallpaper
feh --bg-scale --randomize --no-fehbg /home/wegeee/pics/wallpapers/desktop/*
# Call wal to set X colors (-R restores the last colorscheme, -n skip setting the wallpaper, -q quiet mode, -o restore config files)
wal -Rnq -o "${HOME}/.config/wal/done.sh"
# Unclutter makes the mouse invisible after a brief period
unclutter -root &
# Starts redshift to adjusts the color temperature
redshift &
# Starts dunst for notifications
dunst &
# Exec autolock with custom lock
xautolock -time 5 -corners ---- -locker "${HOME}/bin/i3lock-color.sh" &
# Enable Razer macros
bwidow -s
# Enable custom touchpad gestures
libinput-gestures &
# Enable keybinds with xbindkeys
xbindkeys
# Enable numlock on X
numlockx

# Launch i3 with dbus (export $DBUS_SESSION_BUS_ADDRESS and $DBUS_SESSION_BUS)
#exec dbus-launch --exit-with-session i3
# Launch i3 (dbus already started by distribution patch in xinitrc.d)
exec i3

# TODO: test xsm loading
#exec xsm
