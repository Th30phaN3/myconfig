#!/bin/sh
#
# Change wallpaper, terminal colors, gtk theme and homepage

#json for wal theme
AU_JSON=$HOME/.themes/autumn.json
WI_JSON=$HOME/.themes/winter.json
SP_JSON=$HOME/.themes/spring.json
SU_JSON=$HOME/.themes/summer.json
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
#background images used in homepage
AU_WHP=forest_autumn.jpg
WI_WHP=forest_winter.jpeg
SP_WHP=grass.jpg
SU_WHP=summer.jpg
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

GTK3_SETTINGS=$HOME/myconfig/gtk/.config/gtk-3.0/settings.ini
DMENU_EXT_SETTINGS=$HOME/myconfig/dmenu-extended/.config/dmenu-extended/config/dmenuExtended_preferences.txt
DMENU_EXT_COLORS=$HOME/myconfig/dmenu-extended/.config/dmenu-extended/config/colors
HOMEPAGE=$HOME/myconfig/homepage/.homepage/home.html
CSS_HOMEPAGE=$HOME/myconfig/homepage/.homepage/style.css
DUNST_SETTINGS=$HOME/myconfig/dunst/.config/dunst/dunstrc

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
#change wallpapers
feh --bg-scale --randomize --no-fehbg $HOME/pics/wallpapers/desktop/$WP_FOLDER/*
#change gtk settings to reflect new theme
sed -i '2s/.*/gtk-theme-name='"$THEME"'/' $GTK3_SETTINGS
sed -i '3s/.*/gtk-icon-theme-name='"$ICONS"'/' $GTK3_SETTINGS
#replace bakground and script in homepage
sed -i '9s#.*#  <script src="'"$SCRIPT"'.js"></script>#' $HOMEPAGE
sed -i '16s#.*#  background-image: url("$HOME/.homepage/'"$WHP"'");#' $CSS_HOMEPAGE
#change the frame color for dunst notifications
COLORFRAME=$((LINE + 12))
COLOR=$(sed "${COLORFRAME}q;d" $DMENU_EXT_COLORS)
sed -i '67s/.*/    frame_color = "'"$COLOR"'"/' $DUNST_SETTINGS
x=1
y=6
#change the 4 colors used in dmenu-extended settings
while [ $x -le 4 ]
do
  #get color from color file
  COLOR=$(sed "${LINE}q;d" $DMENU_EXT_COLORS)
  #replace it in dmenu-extended settings
  sed -i ''"$y"'s/.*/\t"'"$COLOR"'",/' $DMENU_EXT_SETTINGS
  LINE=$(( $LINE + 6 ))
  y=$(( $y + 2 ))
  x=$(( $x + 1 ))
done