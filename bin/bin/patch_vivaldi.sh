#!/bin/bash
#
# Author: GwenDragon
# Patch the browser.html and copy custom.js and custom.css in a selected Vivaldi installation

if [ $UID != 0 ] ; then
  echo "This script requires root permission."
  exit 255
fi

# Default directory for custom files
MOD_DIR=$HOME/VivaldiPatch
if [ ! "$1" = "" ] ; then
  MOD_DIR=$1
fi
INSTALL_PATH=$(dirname $(find /opt -name "vivaldi-bin" )) ;
INSTALL_DIRS=( $INSTALL_PATH ) ;
echo "---------------------"
COUNT=1
SELECTED=0
echo "Found installations:"
for DIR in $INSTALL_PATH ; do
  echo "$DIR: $COUNT"
  ((COUNT++)) ;
done
read -p "
Which installation patch?
Please enter the number and press Enter or X for abort.
Enter selection: " SELECTED ;
if [ "$SELECTED" = "X" ] ; then
  exit
fi
((SELECTED--)) ;
if [ $SELECTED -ge ${#INSTALL_DIRS[@]} ] ; then
  echo "Invalid choice."
fi
DIR=${INSTALL_DIRS[$SELECTED]} ;
echo "---------------------"
echo "Patch of "${MOD_DIR}" for "${INSTALL_DIRS[$SELECTED]} ;
cp "$DIR/resources/vivaldi/browser.html" "$DIR/resources/vivaldi/browser.html-$(date +%Y-%m-%dT%H-%M-%S)"
ALREADY_PATCHED=$(grep '<link rel="stylesheet" href="style/custom.css" />' $DIR/resources/vivaldi/browser.html);
if [ "$ALREADY_PATCHED" = "" ] ; then
  echo "Patching browser.html..."
  sed -i -e 's/<\/head>/<link rel="stylesheet" href="style\/custom.css" \/> <\/head>/' "$DIR/resources/vivaldi/browser.html"
  sed -i -e 's/<\/body>/<script src="custom.js"><\/script> <\/body>/' "$DIR/resources/vivaldi/browser.html"
else
  echo "browser.html is already patched."
fi
if [ -f "$MOD_DIR/custom.css" ] ; then
  echo "Copying custom.css..."
  cp -f "$MOD_DIR/custom.css" "$DIR/resources/vivaldi/style/custom.css"
else
  echo "custom.css copied in $MOD_DIR"
fi
if [ -f "$MOD_DIR/custom.js" ] ; then
  echo "Copying custom.js..."
  cp -f "$MOD_DIR/custom.js" "$DIR/resources/vivaldi/custom.js"
else
  echo "custom.js copied in $MOD_DIR"
fi