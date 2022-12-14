#!/bin/bash
#
# This script can be called from udev rules to automatically arrange screens.

# Get the external screen status
SMODE="$(/bin/cat /sys/class/drm/card0-DP-2/status)"

LOGFILE="/var/log/coscreen.log"
HOMEUSER="/home/wegeee"

# If run as root, we need the user Xauthority and default display
export DISPLAY=:0
export XAUTHORITY="$HOMEUSER/.Xauthority"

# Delay by 2 seconds
/usr/bin/sleep 2

/bin/echo "INVOCATION connectscreen.sh" >> "$LOGFILE"
/bin/date >> "$LOGFILE"
/bin/echo "Status: ${SMODE}" >> "$LOGFILE"

if [ "${SMODE}" = disconnected ]; then
  "$HOMEUSER"/notify.sh "DP2 screen disconnected" "Applying xrandr automatic configuration..."
  # Automatically arrange primary screen if the external screen is disconnected
  /usr/bin/xrandr --auto
  /bin/echo "DP2 screen disconnected" >> "$LOGFILE"
elif [ "${SMODE}" = connected ]; then
  "$HOMEUSER"/notify.sh "DP2 screen connected" "Applying xrandr configuration (left of eDP1)"
  # Arrange external screen to be on left of primary screen
  #/usr/bin/xrandr --output DP2 --left-of eDP1
  /usr/bin/xrandr --output "eDP-1" --primary --output "DP-2" --left-of "eDP-1"
  /bin/echo "DP2 screen connected" >> "$LOGFILE"
else
  "$HOMEUSER"/notify.sh "DP2 ERROR" "Applying xrandr automatic configuration..." "udev" "critical"
  # Should not happen, use automatic configuration to not be without screens
  /usr/bin/xrandr --auto
  /bin/echo "DP2 ERROR" >> "$LOGFILE"
fi
