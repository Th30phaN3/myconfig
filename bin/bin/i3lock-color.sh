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
--time-pos="60:850" \
--date-pos="60:950" \
--date-align 1 \
--time-align 1 \
--insidever-color="00000000" \
--insidewrong-color="00000000" \
--inside-color="00000000" \
--ringver-color=$color4 \
--ringwrong-color=$color1 \
--ring-color=$color13 \
--line-color="00000000" \
--wrong-color=$color1 \
--time-color="ffffffff" \
--date-color="ffffffff" \
--keyhl-color=$color11 \
--bshl-color=$color8 \
--separator-color="00000000" \
--clock \
--time-str='%R' \
--date-str='%A %e %B %Y' \
--verif-text="" \
--wrong-text="Nope" \
--noinput-text="Empty" \
--lock-text="Locking..." \
--lockfailed-text="Failed to lock !" \
--time-font="~/.local/share/fonts/segoe-ui-light.ttf" \
--date-font="~/.local/share/fonts/segoe-ui-light.ttf" \
--verif-font="~/.local/share/fonts/segoe-ui-light.ttf" \
--wrong-font="~/.local/share/fonts/segoe-ui-light.ttf" \
--time-size=100 \
--date-size=60 \
--verif-size=25 \
--wrong-size=25 \
--ring-width=20 \
--radius=130
