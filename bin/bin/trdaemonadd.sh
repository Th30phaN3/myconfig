#!/bin/bash
#
# Mimeapp script for adding torrent to transmission-daemon, but will also start the daemon first if not running.
# The sleep of 3 seconds is because the transmission-daemon sometimes fails to take remote requests in its first moments.

pgrep -x transmission-da || (transmission-daemon && notify.sh "Starting daemon..." && sleep 3 && pkill -RTMIN+7 i3blocks)
transmission-remote -a "$@" && notify.sh "Transmission:" "$* added."
