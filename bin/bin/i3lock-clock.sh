#!/bin/bash
#
# Invoke i3lock with custom arguments
# DEPRECATED: use i3lock-color.sh instead
# This script is kept to explain all the options of i3lock-color

# Old i3lock-clock (https://github.com/Lixxia/i3lock)
#i3lock -t -i ~/pics/wallpapers/desktop/art/mountain_lock.png -o "#006700" -w "#a91818" -l "#e5e5e5" -e -f

# i3lock-color (fork of original i3lock)
# Help: https://github.com/Raymo111/i3lock-color/blob/master/i3lock.1
# Base options
i3lock \
--image="$HOME/pics/wallpapers/desktop/humour/windows_10_default_lock.png" \ # fork supports PNG and JPEG images, enable a slideshow if the path is a directory
--tiling \
--pointer="win" \
--ignore-empty-password \
--show-failed-attempts \
# Fork options
--insidevercolor="" \ # default to "006effbf"
--insidewrongcolor="" \ # default to "fa0000bf"
--insidecolor="" \ # default to "000000bf"
--ringvercolor="" \ # default to "3300fabf"
--ringwrongcolor="" \ # default to "7d3300bf"
--ringcolor="" \ # default to "337d00ff"
--linecolor="" \ # default to "000000ff"
--verifcolor="" \ # default to "000000ff"
--wrongcolor="" \ # default to "000000ff"
--layoutcolor="" \ # default to "000000ff"
--timecolor="" \ # default to "000000ff"
--datecolor="" \ # default to "000000ff"
--keyhlcolor="" \ # default to "33db00ff"
--bshlcolor="" \ # default to "db3300ff"
--separatorcolor="" \ # default to "000000ff"
--greetercolor="" \ # default to "000000ff"
--line-uses-ring \ # -r for short, to use the ring colors
--line-uses-inside \ # -s for short, to use the inside colors
--screen="-1" \ # -S for short, define which display the lock indicator should be shown on (-1 for all displays, default is 0)
--blur=5 \ # -B for short, sigma as argument (default is 5)
--clock \ # -k for short, show the clock
--force-clock \ # clock is always displayed
--indicator \ # show indicator
--radius=80 \ # radius must be a positive integer (default is 90)
--ring-width=6 \ # ring width must be a positive integer (default is 7)
--time-align=0 \ # default to 0, must be 0/1/2 (0 = center, 1 = left, 2 = right)
--date-align=0 \ # default to 0, must be 0/1/2 (0 = center, 1 = left, 2 = right)
--verif-align=0 \ # default to 0, must be 0/1/2 (0 = center, 1 = left, 2 = right)
--wrong-align=0 \ # default to 0, must be 0/1/2 (0 = center, 1 = left, 2 = right)
--layout-align=0 \ # default to 0, must be 0/1/2 (0 = center, 1 = left, 2 = right)
--modif-align=0 \ # default to 0, must be 0/1/2 (0 = center, 1 = left, 2 = right)
--greeter-align=0 \ # default to 0, must be 0/1/2 (0 = center, 1 = left, 2 = right)
--timestr="%T" \ # time format, default to "%H:%M:%S", must be 31 characters max
--datestr="%A %e %B %Y" \ # date format, default to "%A, %m %Y", must be 31 characters max
--veriftext="Verifying..." \ # default to "verifying…"
--wrongtext="Wrong password !" \ # default to "wrong!"
--keylayout=2 \ # default to -1
--noinputtext="No input" \ # default to "no input"
--locktext="Locking..." \ # default to "locking…"
--lockfailedtext="Failed to lock !" \ # default to "lock failed!"
--greetertext="Windows 10" \ # default to ""
--time-font="Anonymice Nerd Font" \ # default to "sans-serif"
--date-font="Anonymice Nerd Font" \ # default to "sans-serif"
--verif-font="Anonymice Nerd Font" \ # default to "sans-serif"
--wrong-font="Anonymice Nerd Font" \ # default to "sans-serif"
--layout-font="Anonymice Nerd Font" \ # default to "sans-serif"
--greeter-font="Anonymice Nerd Font" # default to "sans-serif"
--timesize=20 \ # default to 32, must be a positive integer
--datesize=20 \ # default to 14, must be a positive integer
--verifsize=20 \ # default to 28, must be a positive integer
--wrongsize=20 \ # default to 28, must be a positive integer
--layoutsize=20 \ # default to 14, must be a positive integer
--modsize=20 \ # default to 14, must be a positive integer
--greetersize=20 \ # default to 32, must be a positive integer
--timepos=0 \ # default to "ix:iy", must be of the form "x:y"
--datepos=0 \ # default to "tx:ty+30", must be of the form "x:y"
--verifpos=0 \ # default to "ix:iy", must be of the form "x:y"
--wrongpos=0 \ # default to "ix:iy", must be of the form "x:y"
--layoutpos=0 \ # default to "dx:dy+30", must be of the form "x:y"
--statuspos=0 \ # default to "ix:iy", must be of the form "x:y"
--modifpos=0 \ # default to "ix:iy+28", must be of the form "x:y"
--indpos=0 \ # default to "x + (w / 2):y + (h / 2)", must be of the form "x:y"
--greeterpos=0 \ # default to "ix:ix", must be of the form "x:y"
--pass-media-keys \ # enable "AudioPlay", "AudioPause", "AudioStop", "AudioPrev", "AudioNext", "AudioMute", "AudioLowerVolume" and "AudioRaiseVolume" keys
--pass-screen-keys \ # enable "BrightnessUp" and "BrightnessDown" keys
--pass-power-keys \ # enable "PowerDown", "PowerOff" and "Sleep" keys
--bar-indicator \ # enable bar indicator
--bar-direction=0 \ # default to 0, must be 0/1/2 (0 = default, 1 = reversed, 2 = bidirectional)
--bar-width=25 \ # default to 25
--bar-orientation="horizontal" \ # default to "horizontal", must be "vertical" or "horizontal"
--bar-step=15 \ # default to 15
--bar-max-height=25 \ # default to 25
--bar-base-width=25 \ # default to 25
--bar-color="000000ff" \ # default to "000000ff"
--bar-periodic-step=15 \ # default to 15
--bar-position="0" \ # default to "0", must be 31 characters max
--redraw-thread \ # invoke the redraw function in a dedicated thread
--refresh-rate=1 \ # refresh rate in seconds, default to 1, cannot be negative
--composite \ # allows compositing (removed in upstream)
--no-verify \ # do not verify password
--slideshow-interval=6 \ # default to 10 seconds, cannot be negative
--slideshow-random-selection \ # pick a random image in the provided directory
