#!/bin/bash
#
# Symlink dunst config generated by wal
# and restart dunst with the new color scheme

ln -sf ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc
pkill dunst
dunst &
