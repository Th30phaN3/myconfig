#!/bin/bash
#
# Invoke i3lock-color (fork of original i3lock) with custom arguments
# Help: https://github.com/Raymo111/i3lock-color/blob/master/i3lock.1

# Get xresources colors
for x in "$(xrdb -query | grep '*.color' | sed "s/.*\./export /g;s/:\s*/=\"/g;s/$/fa\"/g;s/\#//g")"; do eval "$x"; done

i3lock \
--image="$HOME/pics/wallpapers/desktop/humour/windows_10_default_lock.png" \
--tiling \
--pointer="win" \
--ignore-empty-password \
--pass-media-keys \
--pass-volume-keys \
--timepos="60:850" \
--datepos="60:950" \
--date-align 1 \
--time-align 1 \
--insidevercolor="00000000" \
--insidewrongcolor="00000000" \
--insidecolor="00000000" \
--ringvercolor=$color4 \
--ringwrongcolor=$color1 \
--ringcolor=$color13 \
--linecolor="00000000" \
--wrongcolor=$color1 \
--timecolor="ffffffff" \
--datecolor="ffffffff" \
--keyhlcolor=$color11 \
--bshlcolor=$color8 \
--separatorcolor="00000000" \
--clock \
--timestr='%R' \
--datestr='%A %e %B %Y' \
--veriftext="" \
--wrongtext="Nope" \
--noinputtext="Empty" \
--locktext="Locking..." \
--lockfailedtext="Failed to lock !" \
--time-font="~/.local/share/fonts/segoe-ui-light.ttf" \
--date-font="~/.local/share/fonts/segoe-ui-light.ttf" \
--verif-font="~/.local/share/fonts/segoe-ui-light.ttf" \
--wrong-font="~/.local/share/fonts/segoe-ui-light.ttf" \
--timesize=100 \
--datesize=60 \
--verifsize=25 \
--wrongsize=25 \
--ring-width=20 \
--radius=130
