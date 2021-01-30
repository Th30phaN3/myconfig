#!/bin/bash
#
# Sync all repositories (main portage tree + overlays),
# build eix cache then compare to the previous one to show what packages changed.
# Output varies depending if it's a terminal or not.

SYNCLOG='/var/log/esync.log'
TIMESYNC=$(date +%c)
SUDO=''
if (( EUID != 0 )); then
  SUDO='sudo' # To run as root (requires global sudo rights)
fi

"$SUDO" echo "-----------------" >> "$SYNCLOG"

if [ -t 0 ]; then
  # In terminal, redirect only stdout to log file
  "$SUDO" echo "Portage sync effectued from terminal on $TIMESYNC" >> "$SYNCLOG"
  echo "Saving previous eix cache..."
  "$SUDO" echo "-- COPY PREVIOUS EIX CACHE --" >> "$SYNCLOG"
  "$SUDO" cp -p -- /var/cache/eix/remote.eix /var/cache/eix/previous.eix
  echo "Syncing all repositories..."
  "$SUDO" echo "-- EMERGE SYNC --" >> "$SYNCLOG"
  "$SUDO" emerge --sync --color=n --ask=n >> "$SYNCLOG"
  #echo "Regenerate metadata cache..."
  #"$SUDO" echo "-- EMERGE REGEN --" >> "$SYNCLOG"
  #"$SUDO" emerge --regen --color=n -q >> "$SYNCLOG"
  echo "Updating eix cache..."
  "$SUDO" echo "-- EIX UPDATE --" >> "$SYNCLOG"
  "$SUDO" eix-update -q -H -n >> "$SYNCLOG"
  #echo "Adding remote overlays to new eix cache..."
  #"$SUDO" echo "-- EIX REMOTE --" >> "$SYNCLOG"
  #"$SUDO" eix-remote -X -H -q add >> "$SYNCLOG"
  echo "The following packages were changed since last sync :"
  "$SUDO" echo "-- EIX DIFF TO TERMINAL --" >> "$SYNCLOG"
  eix-diff -- /var/cache/eix/previous.eix /var/cache/eix/remote.eix
else
  # Not in terminal, redirect stdout and stderr to log file
  "$SUDO" echo "Portage sync effectued on $TIMESYNC" >> "$SYNCLOG"
  "$SUDO" echo "-- COPY PREVIOUS EIX CACHE --" >> "$SYNCLOG"
  "$SUDO" cp -p -- /var/cache/eix/remote.eix /var/cache/eix/previous.eix
  "$SUDO" echo "-- EMERGE SYNC --" >> "$SYNCLOG"
  "$SUDO" emerge --sync --color=n --ask=n &>> "$SYNCLOG"
  #"$SUDO" echo "-- EMERGE REGEN --" >> "$SYNCLOG"
  #"$SUDO" emerge --regen --color=n -q &>> "$SYNCLOG"
  "$SUDO" echo "-- EIX UPDATE --" >> "$SYNCLOG"
  "$SUDO" eix-update -q -H -n &>> "$SYNCLOG"
  #"$SUDO" echo "-- EIX REMOTE --" >> "$SYNCLOG"
  #"$SUDO" eix-remote -X -H -q add &>> "$SYNCLOG"
  "$SUDO" echo "-- EIX DIFF --" >> "$SYNCLOG"
  eix-diff -n -- /var/cache/eix/previous.eix /var/cache/eix/remote.eix &>> "$SYNCLOG"
fi

"$SUDO" echo -e "-----------------\n\n\n" >> "$SYNCLOG"
