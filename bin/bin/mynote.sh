#!/bin/sh
# $1 should be a message
# $2 should be the level of importance: low, normal, critical
# $3 should be the app name
# If Dunst is running, shows notification.

[ -z "$2" ] || URG="-u $2"
[ -z "$3" ] || APP="-a $3"
pgrep -x dunst >/dev/null && notify-send $URG $APP "$1"