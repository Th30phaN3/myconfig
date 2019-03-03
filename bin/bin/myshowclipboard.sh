#!/bin/sh
#
# Display contents of selection via dunst if running.
# Separate script for i3.

! pgrep -x dunst >/dev/null && echo "Dunst is not running." && exit

clip=$(xclip -o -selection clipboard)
prim=$(xclip -o -selection primary)

[ "$prim" != "" ] && notify-send "Clipboard:<br>$clip"
[ "$clip" != "" ] && notify-send "Primary:<br>$prim"