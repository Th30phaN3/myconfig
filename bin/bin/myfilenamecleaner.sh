#!/bin/sh

# Replace directory and file names with clean, user defined names (work in progress)

while getopts ":bcdlprsuh" option; do
 case "${option}" in
  b) BRACK="y";;
  c) CAMEL="y";;
  d) DIR="y";;
  l) LOWER="y";;
  p) PARE="y";;
  r) RES="y";;
  s) SPACE="y";;
  u) UPPER="y";;
  h|\?) echo "Usage: $0 -[d]irectories -[p]arenthesis -[b]racket -[u]ppercase -[l]owercase -[c]amelcase -[s]pace -[h]elp"
        exit;;
 esac
done
shift $((OPTIND -1))

REGEX=./.*[\ -\.\,\'\[\(\)].*;
FILETYPE="-type f";
REGEX_RES=\[?[0-9]p\]?;
REGEX_HD=[F-Uf-u0-9]\ ?HD;
#
#echo "WARNING ! This will rename all the files in directory and sub-directories. Type 'y' to proceed, any other character to cancel."
#read OK
#if [ "$OK" != "y" ]; then
#  echo "User cancelled"
#  exit
#fi
#
if [ "$DIR" == "y" ]; then
  FILETYPE="";
fi


find $FILETYPE -regextype posix-extended -regex "$REGEX" -print0 | sort -rz | while read -d $'\0' f
do
  COMPLETE="${f##*/}"
  EXT="${COMPLETE##*.}"
  NAME="${COMPLETE%.*}"
  if [ "$BRACK" == "y" ]; then
    NAME=$(echo "$NAME" | sed 's/([^)]*)/ /g')
  fi
  if [ "$PARE" == "y" ]; then
    NAME=$(echo "$NAME" | sed 's/\[[^]]*\]/ /g')
  fi
  NAME=$(echo "$NAME" | sed 's/[[:space:]]\+/ /g' | sed 's/[[:space:]]$//g' | sed 's/^[[:space:]]//g')
  #NAME=$(echo "$NAME" | sed 's/[[:space:]]$//g')
  #NAME=$(echo "$NAME" | sed 's/^[[:space:]]//g')
  echo "|$NAME|"
done

#
#find -name "* *" -print0 | sort -rz | while read -d $'\0' f; do mv -v "$f" "$(dirname "$f")/$(basename "${f// /_}")"; done
#find . -type f -name "* *" -exec bash -c 'mv "$0" "${0// /_}"' {} \;
#find -name "*_-_*" -print0 | sort -rz | while read -d $'\0' f; do mv -v "$f" "$(dirname "$f")/$(basename "${f/_-_/_}")"; done
#find . -type f -name "*_-_*" -exec bash -c 'mv "$0" "${0/_-_/_}"' {} \;
#

#[   # start of character class
#[:space:]  # The POSIX character class for whitespace characters. It's functionally identical to [ \t\r\n\v\f] which matches a space, tab, carriage return, newline, vertical tab or form feed
#]   # end of character class
#\+  # one or more of the previous item (anything matched in the brackets).
#