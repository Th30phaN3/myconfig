#!/bin/bash
#
# Display a notification when Redshift changes the period

export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

case $1 in
  period-changed) notify.sh "Redshift" "Period changed from $2 to $3" "Redshift";
esac
