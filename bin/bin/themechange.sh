#!/bin/bash
#
# Change wallpaper, xresources colors, gtk theme and web browser homepage.
# -[a]utumn / -[w]inter / -s[p]ring / -[s]ummer

# JSON for wal theme
AU_JSON=$HOME/.themes/autumn16.json
WI_JSON=$HOME/.themes/winter16.json
SP_JSON=$HOME/.themes/spring16.json
SU_JSON=$HOME/.themes/summer16.json
# Theme name for gtk
AU_GTK=oomox-Autumn
WI_GTK=oomox-Winter
SP_GTK=oomox-Spring
SU_GTK=oomox-Summer
# Icons theme name for gtk
AU_ICONS=Surfn-Orange
WI_ICONS=Surfn-Papirus-Blue
SP_ICONS=Surfn-Luv-Red
SU_ICONS=Surfn-Arch-Blue
# Background images used in homepage
AU_WHP=autumn.jpg
WI_WHP=winter.jpeg
SP_WHP=spring.jpg
SU_WHP=summer.jpg
# JS filename called in homepage
AU_SCRIPT=leaves
WI_SCRIPT=snow
SP_SCRIPT=flowers
SU_SCRIPT=sunlight
# Directory name for setting wallpapers
AU_FOLDER=autumn
WI_FOLDER=winter
SP_FOLDER=spring
SU_FOLDER=summer

GTK3_SETTINGS=$HOME/myconfig/gtk/.config/gtk-3.0/settings.ini
HOMEPAGE=$HOME/myconfig/homepage/.homepage/home.html
CSS_HOMEPAGE=$HOME/myconfig/homepage/.homepage/style.css

while getopts ":awps" option; do
 case "${option}" in
 a) WP_FOLDER=$AU_FOLDER
    THEME=$AU_GTK
    ICONS=$AU_ICONS
    JSON=$AU_JSON
    SCRIPT=$AU_SCRIPT
    WHP=$AU_WHP
    ;;
 w) WP_FOLDER=$WI_FOLDER
    THEME=$WI_GTK
    ICONS=$WI_ICONS
    JSON=$WI_JSON
    SCRIPT=$WI_SCRIPT
    WHP=$WI_WHP
    ;;
 p) WP_FOLDER=$SP_FOLDER
    THEME=$SP_GTK
    ICONS=$SP_ICONS
    JSON=$SP_JSON
    SCRIPT=$SP_SCRIPT
    WHP=$SP_WHP
    ;;
 s) WP_FOLDER=$SU_FOLDER
    THEME=$SU_GTK
    ICONS=$SU_ICONS
    JSON=$SU_JSON
    SCRIPT=$SU_SCRIPT
    WHP=$SU_WHP
    ;;
 *) echo "Invalid option: supported options are (s)-p(ring), -s(ummer), -a(utumn), -w(inter)"
    exit
    ;;
 esac
done

# Change color scheme
/usr/bin/wal -nq -f "$JSON" -o "$HOME/.config/wal/done.sh"
# Change wallpapers
/usr/bin/feh --bg-scale --randomize --no-fehbg "$HOME/pics/wallpapers/desktop/$WP_FOLDER/"
# Change gtk settings to reflect new theme
/bin/sed -i '2s/.*/gtk-theme-name='"$THEME"'/' "$GTK3_SETTINGS"
/bin/sed -i '3s/.*/gtk-icon-theme-name='"$ICONS"'/' "$GTK3_SETTINGS"
# Replace bakground and script in homepage
#sed -i '9s#.*#  <script src="'"$SCRIPT"'.js"></script>#' "$HOMEPAGE"
#sed -i '16s#.*#  background-image: url("'"$WHP"'");#' "$CSS_HOMEPAGE"
