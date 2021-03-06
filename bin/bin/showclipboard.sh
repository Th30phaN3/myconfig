#!/bin/bash
#
# Display contents of selection via dunst if running.

! pgrep -x dunst >/dev/null && exit

clip=$(xclip -o -selection clipboard)
prim=$(xclip -o -selection primary)

[ "$clip" != "" ] && notify-send "Clipboard:" "$clip"
[ "$prim" != "" ] && notify-send "Primary:" "$prim"