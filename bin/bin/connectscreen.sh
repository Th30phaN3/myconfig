#!/bin/bash
#
# This script can be called from udev rules to automatically arrange screens.

# Get the external screen status
SMODE="$(cat /sys/class/drm/card0-DP-2/status)"

LOGFILE="/var/log/coscreen.log"

# If run as root, we need the user Xauthority and default display
export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

echo "INVOCATION connectscreen.sh" >> "$LOGFILE"
date >> "$LOGFILE"
echo "Status: ${SMODE}" >> "$LOGFILE"

if [ "${SMODE}" = disconnected ]; then
  notify.sh "DP2 screen disconnected" "Applying xrandr automatic configuration..."
  # Automatically arrange primary screen if the external screen is disconnected
  xrandr --auto
  echo "DP2 screen disconnected" >> "$LOGFILE"
elif [ "${SMODE}" = connected ]; then
  notify.sh "DP2 screen connected" "Applying xrandr configuration (left of eDP1)"
  # Arrange external screen to be on left of primary screen
  xrandr --output DP2 --left-of eDP1
  echo "DP2 screen connected" >> "$LOGFILE"
else
  notify.sh "DP2 ERROR" "Applying xrandr automatic configuration..." "udev" "critical"
  # Should not happen, use automatic configuration to not be without screens
  xrandr --auto
  echo "DP2 ERROR" >> "$LOGFILE"
fi
