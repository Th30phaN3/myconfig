#!/bin/bash
#
# Execute scripts to update configuration.

if [ -e ~/.config/dunst/wal.sh ]; then
  ~/.config/dunst/wal.sh
fi

if [ -e ~/.config/dmenu/wal.sh ]; then
  ~/.config/dmenu/wal.sh
fi
