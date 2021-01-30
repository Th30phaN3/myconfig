#!/bin/bash
#
# Author: GwenDragon (Vivaldi forum)
# License: GPL
# Patch the browser.html and copy custom.js and custom.css in a selected Vivaldi installation

if [ $UID != 0 ] ; then
    echo "Please use 'sudo' or log in as root."
    exit 255
fi

# Default directory for custom files
mod_dir=$HOME/.themes/vivaldi/custom
if [ ! "$1" = "" ] ; then
    mod_dir=$1
fi

vivaldi_installs=$(dirname $(find /opt -name "vivaldi-bin" )) ;
vivaldi_install_dirs=( $vivaldi_installs ) ;

echo "---------------------"
count=1
selected=0
echo "Installations found:"
for dir in $vivaldi_installs ; do
 echo "$dir: $count" ;
 ((count++)) ;
done
read -p "
Select installation to patch.
Input number and press [Enter] or [X] to cancel.
Input selection: " selected ;
if [ "$selected" = "X" ] ; then
 exit ;
fi
((selected--)) ;
if [ $selected -ge ${#vivaldi_install_dirs[@]} ] ; then
    echo "Selection too large!"
fi
dir=${vivaldi_install_dirs[$selected]} ;
echo "---------------------"
echo "Patch originating from "${mod_dir}" targeting "${vivaldi_install_dirs[$selected]} ;

cp "$dir/resources/vivaldi/browser.html" "$dir/resources/vivaldi/browser.html-$(date +%Y-%m-%dT%H-%M-%S)"

alreadypatched=$(grep '<link rel="stylesheet" href="style/custom.css" />' $dir/resources/vivaldi/browser.html);
if [ "$alreadypatched" = "" ] ; then
  echo "Patching browser.html..."
  sed -i -e 's/<\/head>/<link rel="stylesheet" href="style\/custom.css" \/> <\/head>/' "$dir/resources/vivaldi/browser.html"
  sed -i -e 's/<\/body>/<script src="custom.js"><\/script> <\/body>/' "$dir/resources/vivaldi/browser.html"
else
  echo "browser.html has already been patched!"
fi

if [ -f "$mod_dir/custom.css" ] ; then
    echo "Copying custom.css..."
    cp -f "$mod_dir/custom.css" "$dir/resources/vivaldi/style/custom.css"
else
    echo "custom.css missing in $mod_dir"
fi

if [ -f "$mod_dir/custom.js" ] ; then
    echo copying custom.js
    cp -f "$mod_dir/custom.js" "$dir/resources/vivaldi/custom.js"
else
    echo "custom.js missing in $mod_dir"
fi
