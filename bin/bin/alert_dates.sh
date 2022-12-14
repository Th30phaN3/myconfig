#!/bin/bash
#
# Notify important events. Used with fcrontab.

export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

TODAY=$(/usr/bin/birthday -M 1 -f "$HOME/.config/birthday/dates")

if [[ -n "${TODAY}" ]]; then
  "$HOME"/bin/notify.sh "BIRTHDAY" "${TODAY}" "birthday" "critical"
fi
