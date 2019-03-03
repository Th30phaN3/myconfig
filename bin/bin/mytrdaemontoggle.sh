#!/bin/sh
#
# If transmission-daemon is running, will ask to kill, else will ask to start.

[ ! -f /usr/bin/transmission-daemon ] && notify-send "Transmission daemon not installed." && exit

if  pgrep -x transmission-da >/dev/null ;
then
	yn=$(printf "No\\nYes" | dmenu -i -p "Kill Transmission daemon?")
	[ "$yn" = "Yes" ] && killall transmission-da
else
	yn=$(printf "No\\nYes" | dmenu -i -p "Start Transmission daemon?")
	[ "$yn" = "Yes" ] && transmission-daemon
fi
sleep 3 && pkill -RTMIN+7 i3blocks