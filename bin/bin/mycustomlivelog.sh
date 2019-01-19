#!/bin/sh
#
# Display a log including all errors from multiple log files

multitail -D -Cs -E "[Ee]rror" --no-repeat --mergeall \
/var/log/Xorg.0.log \
/var/log/Xorg.1.log \
/var/log/Xorg.2.log \
/var/log/Xorg.3.log \
/var/log/Xorg.4.log \
/var/log/Xorg.5.log \
/var/log/Xorg.6.log \
/var/log/Xorg.7.log \
/var/log/Xorg.8.log \
/var/log/Xorg.9.log \
/var/log/auth.log \
/var/log/daemon.log \
/var/log/debug \
/var/log/dmesg \
/var/log/docker.log \
/var/log/emerge.log \
/var/log/kern.log \
/var/log/lpr.log \
/var/log/messages \
/var/log/mpd \
/var/log/syslog \
/var/log/user.log \
/var/log/wpa_supplicant.log \
/var/log/portage/elog/summary.log