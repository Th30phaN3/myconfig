#!/bin/bash
#
# If Dunst is running, shows notification.
# $1 should be the summary
# $2 should be the message
# $3 should be the software name
# $4 should be the level of importance: low, normal, critical

export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

[ -z "$3" ] || APP="-a $3"
[ -z "$4" ] || URG="-u $4"
/usr/bin/pgrep -x dunst >/dev/null && /usr/bin/notify-send $URG $APP -- "$1" "$2"
