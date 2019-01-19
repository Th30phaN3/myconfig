#!/bin/sh
#
# Change wallpaper, terminal colors, gtk theme and homepage

#json for wal theme
AU_JSON=$HOME/.config/autumn.json
WI_JSON=$HOME/.config/winter.json
SP_JSON=$HOME/.config/spring.json
SU_JSON=$HOME/.config/summer.json
#theme name for gtk
AU_GTK=oomox-Autumn
WI_GTK=oomox-Winter
SP_GTK=oomox-Spring
SU_GTK=oomox-Summer
#icons theme name for gtk
AU_ICONS=Surfn-Orange
WI_ICONS=Surfn-Papirus-Blue
SP_ICONS=Surfn-Luv-Red
SU_ICONS=Surfn-Arch-Blue
#folder name for wallpaper
AU_FOLDER=autumn
WI_FOLDER=winter
SP_FOLDER=spring
SU_FOLDER=summer
#background images used in homepage
AU_WHP=$AU_FOLDER/forest_autumn.jpg
WI_WHP=$WI_FOLDER/winter_forest.jpeg
SP_WHP=$SP_FOLDER/grass.jpg
SU_WHP=$SU_FOLDER/fw_forest.jpg
#script name called in homepage
AU_SCRIPT=leaves
WI_SCRIPT=snow
SP_SCRIPT=flowers
SU_SCRIPT=sunlight
#starting line in color file for dmenu-extended
AU_LINE=2
WI_LINE=3
SP_LINE=4
SU_LINE=5

GTK3_SETTINGS=$HOME/.config/gtk-3.0/settings.ini
DMENU_EXT_SETTINGS=$HOME/myconfig/dmenu-extended/.config/dmenu-extended/config/dmenuExtended_preferences.txt
DMENU_EXT_COLORS=$HOME/.config/dmenu-extended/config/colors
HOMEPAGE=$HOME/.homepage/home.html
CSS_HOMEPAGE=$HOME/.homepage/style.css

while getopts ":awps" option; do
 case "${option}" in
 a) WP_FOLDER=$AU_FOLDER
    THEME=$AU_GTK
    ICONS=$AU_ICONS
    JSON=$AU_JSON
    SCRIPT=$AU_SCRIPT
    WHP=$AU_WHP
    LINE=$AU_LINE
    ;;
 w) WP_FOLDER=$WI_FOLDER
    THEME=$WI_GTK
    ICONS=$WI_ICONS
    JSON=$WI_JSON
    SCRIPT=$WI_SCRIPT
    WHP=$WI_WHP
    LINE=$WI_LINE
    ;;
 p) WP_FOLDER=$SP_FOLDER
    THEME=$SP_GTK
    ICONS=$SP_ICONS
    JSON=$SP_JSON
    SCRIPT=$SP_SCRIPT
    WHP=$SP_WHP
    LINE=$SP_LINE
    ;;
 s) WP_FOLDER=$SU_FOLDER
    THEME=$SU_GTK
    ICONS=$SU_ICONS
    JSON=$SU_JSON
    SCRIPT=$SU_SCRIPT
    WHP=$SU_WHP
    LINE=$SU_LINE
    ;;
 esac
done

#change color scheme
wal -nq -f $JSON
#change wallpaper
feh --bg-scale --randomize --no-fehbg ~/pics/wallpapers/$WP_FOLDER/*
#change gtk settings to reflect new theme
sed -i '2s/.*/gtk-theme-name='"$THEME"'/' $GTK3_SETTINGS
sed -i '3s/.*/gtk-icon-theme-name='"$ICONS"'/' $GTK3_SETTINGS
#replace bakground and script in homepage
sed -i '9s#.*#\t<script src="'"$SCRIPT"'.js"></script>#' $HOMEPAGE
sed -i '16s#.*#\tbackground-image: url("/home/wegeee/pics/wallpapers/'"$WHP"'");#' $CSS_HOMEPAGE
x=1
y=6
#change the 4 colors used in dmenu-extended settings
while [ $x -le 4 ]
do
  #get color from color file
  COLOR=$(sed "${LINE}q;d" $DMENU_EXT_COLORS)
  #replace it in dmenu-extended settings
  sed -i ''"$y"'s/.*/"'"$COLOR"'",/' $DMENU_EXT_SETTINGS
  LINE=$(( $LINE + 6 ))
  y=$(( $y + 2 ))
  x=$(( $x + 1 ))
done