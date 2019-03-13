#!/bin/sh
#
# Display contents of selection via dunst if running.
# Separate script for i3.

! pgrep -x dunst >/dev/null && exit

clip=$(xclip -o -selection clipboard)
prim=$(xclip -o -selection primary)

[ "$clip" != "" ] && notify-send "Clipboard:<br>$clip"
[ "$prim" != "" ] && notify-send "Primary:<br>$prim"