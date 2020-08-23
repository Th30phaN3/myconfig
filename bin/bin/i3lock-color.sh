#!/bin/bash
#
# Invoke i3lock with custom arguments

# Get xresources colors
for x in "$(xrdb -query | grep '*.color' | sed "s/.*\./export /g;s/:\s*/=\"/g;s/$/fa\"/g;s/\#//g")"; do eval "$x"; done

# i3lock-color (fork of original i3lock)
# Help: https://github.com/Raymo111/i3lock-color/blob/master/i3lock.1
i3lock \
--image="$HOME/pics/wallpapers/desktop/humour/windows_10_default_lock.png" \
--tiling \
--pointer="win" \
--ignore-empty-password \
--insidevercolor="00000000" \
--insidewrongcolor="00000000" \
--insidecolor="00000000" \
--ringvercolor=$color4 \
--ringwrongcolor=$color1 \
--ringcolor=$color13 \
--linecolor="00000000" \
--wrongcolor=$color1 \
--timecolor=$color0 \
--datecolor=$color0 \
--keyhlcolor=$color11 \
--bshlcolor=$color8 \
--separatorcolor="00000000" \
--screen='-1' \
--clock \
--timestr='%T' \
--datestr='%A %e %B %Y' \
--veriftext="" \
--wrongtext="Nope" \
--noinputtext="Empty" \
--locktext="Locking..." \
--lockfailedtext="Failed to lock !" \
--time-font="Anonymice Nerd Font" \
--date-font="Anonymice Nerd Font" \
--verif-font="Anonymice Nerd Font" \
--wrong-font="Anonymice Nerd Font" \
--timesize=35 \
--datesize=18 \
--verifsize=25 \
--wrongsize=25 \
--ring-width=20 \
--radius=115