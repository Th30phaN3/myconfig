#!/bin/bash
#
# Symlink dmenu env variable config, then source it

ln -sf ~/.cache/wal/dmenurc ~/.config/dmenu/dmenurc
. ~/.config/dmenu/dmenurc
