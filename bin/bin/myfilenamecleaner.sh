#!/bin/sh
#
# Replace directory and file names with clean, user defined names

while getopts ":bcdlpqsuxh" option; do
 case "${option}" in
  b) BRACK="y";; # Remove brackets and everything inside them
  c) if [ -n "$LOWER" ] || [ -n "$UPPER" ]; then
       echo "Only one capitalization option can be used"
       exit
     fi
     CAMEL="y";; # Uppercase for the first letter of each words, rest in lowercase
  d) DIR="y";; # Also rename directories
  l) if [ -n "$CAMEL" ] || [ -n "$UPPER" ]; then
       echo "Only one capitalization option can be used"
       exit
     fi
     LOWER="y";; # All words are lowercase
  p) PARE="y";; # Remove parenthesis and everything inside them
  q) QUAL="y";; # Strip everything related to quality
  s) SAFE="y";; # Safe mode: print what the script would do
  u) if [ -n "$CAMEL" ] || [ -n "$LOWER" ]; then
       echo "Only one capitalization option can be used"
       exit
     fi
     UPPER="y";; # All words are uppercase
  x) POSIX="y";; # Separate words with underscores, replace every accents, strip special characters
  h|\?) echo "Usage: $0 -[b]racket -[c]amelcase -[d]irectories -[l]owercase -[p]arenthesis -[q]uality -[s]afe -[u]ppercase -posi[x] -[h]elp"
        exit;;
 esac
done
shift $((OPTIND -1))

# Only select filenames containing special characters
REGEX=./.*[\&\:\ -\.\,\'\[\(\)].*;
# Only rename regular files by default
FILETYPE=$([ "$DIR" == "y" ] && echo "" || echo "-type f")
INCDIR=$([ "$DIR" == "y" ] && echo " AND DIRECTORIES" || echo "")
# Words are separated by spaces by default
SEP=$([ "$POSIX" == "y" ] && echo "_" || echo " ")
MULTI=$([ "$POSIX" == "y" ] && echo "_" || echo "[[:space:]]")

if [ "$SAFE" != "y" ]; then
  printf "WARNING ! This will rename ALL THE FILES$INCDIR in directory and sub-directories.\nRun this script with -s to see what would happen.\nType 'y' to proceed, any other character to cancel.\n"
  read OK
  if [ "$OK" != "y" ]; then
    echo "User cancelled"
    exit
  fi
fi

# Find files, sort them to list deep recursed files first (regular files first then directory)
find $FILETYPE -regextype posix-extended -regex "$REGEX" -print0 | sort -rz | while read -d $'\0' f
do
  # File path
  PATHFILE=$(dirname "$f")
  # Filename without path
  COMPLETE=$(basename "$f")
  # Filename without path and extension
  NAME=$([[ "$COMPLETE" = *.* ]] && echo "${COMPLETE%.*}" || echo "$COMPLETE")
  # Extension
  EXT=$([[ "$COMPLETE" = *.* ]] && echo "${COMPLETE##*.}" || echo '')
  # Convert extensions to lowercase (temporary)
  TMPEXT=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
  # Declare an associative array with major valid extensions (but not all !)
  declare -A ARRAY=([7z]= [apk]= [avi]= [bat]= [bak]= [batch]= [bmp]= [bz2]= [bookmark]= [c]= [cpp]= [cbr]= [cbz]= [conf]= [cp]= [cs]= [css]= [cxx]= [d]= [db]= [deb]= [diff]= [dump]= [epub]= [exe]= [flac]= [flv]= [gem]= [gif]= [go]= [gz]= [gzip]= [h]= [htm]= [html]= [ico]= [ini]= [java]= [jpeg]= [jpg]= [js]= [json]= [less]= [log]= [lua]= [markdown]= [md]= [mkv]= [mov]= [mp3]= [mp4]= [m4a]= [mpeg]= [mpg]= [nfo]= [ogg]= [pdf]= [php]= [png]= [py]= [rar]= [rb]= [rc]= [rpm]= [rss]= [scala]= [scss]= [sh]= [slim]= [sln]= [sql]= [srt]= [sub]= [suo]= [tmp]= [tar]= [tgz]= [ts]= [twig]= [txt]= [vim]= [vimrc]= [wav]= [webm]= [wmv]= [xml]= [xz]= [yml]= [zip]=)
  if [[ ! -z "$TMPEXT" ]]; then
    if [[ ${ARRAY[$TMPEXT]-X} != ${ARRAY[$TMPEXT]} ]]
      then
        NAME="$NAME.$EXT" # If filename contains points but no extensions
        EXT=""
      else
        EXT=".$TMPEXT"
    fi
  fi
  if [ "$PARE" == "y" ]; then
    NAME=$(echo "$NAME" | sed 's/([^)]*)//g')
  fi
  if [ "$BRACK" == "y" ]; then
    NAME=$(echo "$NAME" | sed 's/\[[^]]*\]//g')
  fi
  if [ "$QUAL" == "y" ]; then # Strip things like FULL HD / x264 / [1080p] / BRip / AAC / Blueray
    NAME=$(echo "$NAME" | sed "s/\[\?[0-9]\+[Pp]\]\?//g" | sed "s/[Ff][[:alpha:]]\+\ \?[Hh][Dd]//g")
    NAME=$(echo "$NAME" | sed "s/[XxHh]26[45]-\?//g" | sed "s/[Bb].\?[Rr]ip//g")
    NAME=$(echo "$NAME" | sed "s/AAC-\?[[:alpha:]]*//g" | sed "s/[Bb]lue[Rr]ay//g")
  fi
  if [ "$POSIX" == "y" ]; then # Strip accents, special characters, remaining l' and 's and replace '&' by 'and'
    SPEC="âäāáàêëēéěèîïīíìôöōóòûüūúùÂÄĀÁÀÊËĒÉĚÈÎÏĪÍÌÔÖŌÓÒÛÜŪÚÙ"
    NORM="aaaaaeeeeeeiiiiiooooouuuuuAAAAAEEEEEEIIIIIOOOOOUUUUU"
    NAME=$(echo "$NAME" | sed "s/[-\:\,\.' ]/$SEP/g" | sed "y/$SPEC/$NORM/" | sed "s/_[lL]_/_/g" | sed "s/_[sS]_/_/g" | sed "s/\&/and/g")
  fi
  # Remove all trailing spaces/underscores and replace them with separator
  NAME=$(echo "$NAME" | sed -e "s/$MULTI\+/$SEP/g" | sed -e "s/$MULTI$//g" | sed -e "s/^$MULTI//g")
  if [ "$LOWER" == "y" ]; then
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')
  fi
  if [ "$UPPER" == "y" ]; then
    NAME=$(echo "$NAME" | tr '[:lower:]' '[:upper:]')
  fi
  if [ "$CAMEL" == "y" ]; then
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | sed -e "s/^./\U&/g; s/$SEP./\U&/g")
  fi
  # Check if $NAME is not empty -> attribute random name if its the case
  if [ -z "$NAME" ]; then
    NAME="$RANDOM"
  fi
  if [ "$SAFE" == "y" ]
    then # Print only the result without modifying file
      echo "Initial name: |$PATHFILE/$COMPLETE|"
      echo "Clean name  : |$PATHFILE/$NAME$EXT|"
    else
    RESULT="$PATHFILE/$NAME$EXT"
    if [ "$f" != "$RESULT" ]; then
      mv -v "$f" "$RESULT"
    fi
  fi
done