#!/bin/sh
#
#Animated wallpaper (gif) using xwinwrap and mpv

DIR_GIF=~/pics/wallpapers/gif
#Get 1 random file from directory
FILE=$(ls $DIR_GIF | shuf -n 1)
#Kill all xwinwrap process, alternative -> pidof xwinwrap | kill
killall xwinwrap
CMD="xwinwrap -g 1920x1080 -ov -- mpv --no-terminal --loop-file=inf --no-stop-screensaver --no-osc -wid WID $DIR_GIF/$FILE"
#Detach cmd from terminal
nohup $CMD > /dev/null 2>&1 &