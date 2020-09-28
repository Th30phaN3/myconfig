#!/bin/bash
#
# Replace directory and file names with clean, user defined names

while getopts ":bcdeflpqsuxh" option; do
 case "${option}" in
  b) BRACK="y";; # Remove brackets and everything inside them
  c) if [ -n "$LOWER" ] || [ -n "$UPPER" ]; then
       echo "Only one capitalization option can be used"
       exit
     fi
     CAMEL="y";; # Uppercase for the first letter of each words, rest in lowercase
  d) DIR="y";; # Also rename directories
  e) if [ -n "$FR" ]; then
       echo "Only one language option can be used, with posix enabled"
       exit
     fi
     EN="y";; # English rules (posix must be enabled)
  f) if [ -n "$EN" ]; then
       echo "Only one language option can be used, with posix enabled"
       exit
     fi
     FR="y";; # French rules (posix must be enabled)
  l) if [ -n "$CAMEL" ] || [ -n "$UPPER" ]; then
       echo "Only one capitalization option can be used"
       exit
     fi
     LOWER="y";; # All words are lowercase
  p) PARE="y";; # Remove parenthesis and everything inside them
  q) QUAL="y";; # Strip everything related to quality
  s) SAFE="y";; # Safe mode: print what the script would do without renaming files
  u) if [ -n "$CAMEL" ] || [ -n "$LOWER" ]; then
       echo "Only one capitalization option can be used"
       exit
     fi
     UPPER="y";; # All words are uppercase
  x) POSIX="y";; # Separate words with underscores, replace every accents, strip special characters
  h|\?) echo "Usage: $0 -[b]racket -[c]amelcase -[d]irectories -[e]nglish -[f]rench -[l]owercase -[p]arenthesis -[q]uality -[s]afe -[u]ppercase -posi[x] -[h]elp"
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
  printf "WARNING ! This will rename ALL THE FILES%s in directory and sub-directories.\nRun this script with -s to see what would happen.\nType 'y' to proceed, any other character to cancel.\n" "$INCDIR"
  read OK
  if [ "$OK" != "y" ]; then
    echo "User cancelled"
    exit
  fi
fi

# Find files, sort them to list deep recursed files first (regular files first then directory containing them)
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
  declare -A ARRAY=([7z]= [avi]= [bat]= [bak]= [batch]= [bmp]= [bz2]= [c]= [cpp]= [cbr]= [cbz]= [conf]= [cs]= [css]= [cxx]= [d]= [db]= [deb]= [diff]= [dump]= [epub]= [flac]= [flv]= [gif]= [go]= [gz]= [gzip]= [h]= [htm]= [html]= [ico]= [ini]= [java]= [jpeg]= [jpg]= [js]= [json]= [less]= [log]= [lua]= [markdown]= [md]= [mkv]= [mov]= [mp3]= [mp4]= [m4a]= [mpeg]= [mpg]= [m4v]= [m2ts]= [ogg]= [part]= [pdf]= [php]= [png]= [py]= [rar]= [rss]= [scss]= [sh]= [sln]= [sql]= [srt]= [sub]= [tmp]= [tar]= [tgz]= [ts]= [torrent]= [txt]= [wav]= [webm]= [wmv]= [xml]= [yml]= [zip]=)
  if [[ -n "$TMPEXT" ]]; then
    if [[ ${ARRAY[$TMPEXT]-X} != ${ARRAY[$TMPEXT]} ]]
      then
        NAME="$NAME.$EXT" # If filename contains points but no extension
        EXT="" # No extension
      else
        EXT=".$TMPEXT" # Extension always in lowercase
    fi
  fi
  if [ "$PARE" == "y" ]; then
    NAME=$(echo "$NAME" | sed 's/([^)]*)//g')
  fi
  if [ "$BRACK" == "y" ]; then
    NAME=$(echo "$NAME" | sed 's/\[[^]]*\]//g')
  fi
  if [ "$QUAL" == "y" ]; then # Strip things like resolutions, codecs, etc...
    SP="[_\ \.]"
    # [1080p] / 720p / Full HD / Blueray / HDlight / TTB / Rq / SD
    NAME=$(echo "$NAME" | sed "s/\[\?[0-9]\+p\]\?//gI; s/full\ \?h[di]//gI; s/blue\?ray//gI; s/${SP}hd${SP}\?\(light\)\?//gI; s/${SP}ttb//gI; s/${SP}rq//gI; s/${SP}sd//g")
    # BRrip / DVDRip / Unrated / Multi / WEB / TrueFrench / AMZN / HDTV
    NAME=$(echo "$NAME" | sed "s/bd\?rr\?ip//gI; s/dvdrr\?ip//gI; s/${SP}unrated//gI; s/${SP}multi//gI; s/${SP}web-\?[[:alnum:]]*//gI; s/${SP}true\([[:alpha:]]\+\)/\ \1/gI; s/${SP}amzn//gI; s/${SP}hdtv//gI")
    # x264-something / H265-something / HEVC-something / DUAL-something
    NAME=$(echo "$NAME" | sed "s/${SP}[XxHh]\?26[45]-\?[[:alnum:]]*//g; s/${SP}hevc-\?[[:alnum:]]*//gI; s/${SP}dual-\?[[:alnum:]]*//gI")
    # AAC-something / EAC-something / AC3-something
    NAME=$(echo "$NAME" | sed "s/${SP}aac-\?[[:alnum:]]*//gI; s/${SP}eac-\?[[:alnum:]]*//gI; s/${SP}ac3-\?[[:alnum:]]*//gI")
    # www.something.somedomain
    NAME=$(echo "$NAME" | sed "s/www\.[[:alnum:]]\+\.[[:alpha:]]\+//gI")
  fi
  if [ "$POSIX" == "y" ]; then # Strip accents, special characters, languages-specific terms
    SPEC="âäāáàãåçêëēéěèîïīíìńňôöōóòøûüūúùÿýžÂÄĀÁÀÅÇÊËĒÉĚÈÎÏĪÍÌÑŃŇÔÖŌÓÒØÛÜŪÚÙÝŸŽ"
    NORM="aaaaaaaceeeeeeiiiiinnoooooouuuuuyyzAAAAAACEEEEEEIIIIINNNOOOOOOUUUUUYYZ"
    NAME=$(echo "$NAME" | sed "s/[-\:\,\.' \!\?\#]/${SEP}/g; y/$SPEC/$NORM/")
    if [ "$FR" == "y" ]; then # Strip remaining l', t', s', j', m', d' and replace <&> by <et>
      NAME=$(echo "$NAME" | sed "s/_[ltsjmd]_/_/gI; s/\&/et/g")
    fi
    if [ "$EN" == "y" ]; then # Strip remaining 's, replace ...n't by not, replace ...'re by are and replace <&> by <and>
      NAME=$(echo "$NAME" | sed "s/_s_/_/gI; s/n_t_/_not_/gI; s/_re_/_are_/gI; s/\&/and/g")
    fi
  fi
  # Remove all trailing spaces/underscores and replace them with separator
  NAME=$(echo "$NAME" | sed "s/$MULTI\+/${SEP}/g; s/$MULTI$//g; s/^$MULTI//g")
  if [ "$LOWER" == "y" ]; then # lower case only
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')
  fi
  if [ "$UPPER" == "y" ]; then # UPPER CASE ONLY
    NAME=$(echo "$NAME" | tr '[:lower:]' '[:upper:]')
  fi
  if [ "$CAMEL" == "y" ]; then # Camel Case
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | sed "s/^./\U&/g; s/${SEP}./\U&/g")
  fi
  # Check if $NAME is not empty -> replace by random name if its the case
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