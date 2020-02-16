#!/bin/bash
#
# Re-fetch every overlays (layman sync bug)

# Ugly trick to run as root (requires sudo rights)
SUDO=''
if (( $EUID != 0 )); then
  SUDO='sudo'
fi

OVERLAYS=$(layman -l | cut -d " " -f 3)
$SUDO layman -d $OVERLAYS
$SUDO layman -a $OVERLAYS