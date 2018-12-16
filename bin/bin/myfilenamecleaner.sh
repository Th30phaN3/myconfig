#!/bin/sh

while getopts ":Rdrulc" option; do
 case "${option}" in
  R) RECURSIVE="y";;
  d) DIRECTORY="y";;
  r) RESOLUTION="y";;
  u) UPPERCASE="y";;
  l) LOWERCASE="y";;
  c) CAMELCASE="y";;
  h|\?) echo "Usage: $0 -Recursive -directories -resolution -uppercase -lowercase -camelcase -help"
        exit;;
 esac
done
shift $((OPTIND -1))

#REGEX="./.*[\ \.\[\(\)\'\,\-].*";
FILETYPE="-type f";

if [ "$RECURSIVE" == "y" ]; then
 echo "WARNING ! This will rename all the files in directory and sub-directories. Type 'y' to proceed, any other character to cancel."
 read OK
 if [ "$OK" != "y" ]; then
  echo "User cancelled"
  exit
 fi
fi

if [ "$DIRECTORY" == "y" ]; then
 FILETYPE="";
fi

find $FILETYPE -regextype posix-extended -regex "./.*[\ \-\.\,\'\[\(\)].*"

#find -name "* *" -print0 | sort -rz | while read -d $'\0' f; do mv -v "$f" "$(dirname "$f")/$(basename "${f// /_}")"; done
#find . -type f -name "* *" -exec bash -c 'mv "$0" "${0// /_}"' {} \;
#find -name "*_-_*" -print0 | sort -rz | while read -d $'\0' f; do mv -v "$f" "$(dirname "$f")/$(basename "${f/_-_/_}")"; done
#find . -type f -name "*_-_*" -exec bash -c 'mv "$0" "${0/_-_/_}"' {} \;