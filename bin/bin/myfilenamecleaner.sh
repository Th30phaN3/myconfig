#!/bin/sh
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
       echo "Only one language option can be used"
       exit
     fi
     EN="y";; # English rules (posix must be enabled)
  f) if [ -n "$EN" ]; then
       echo "Only one language option can be used"
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
  printf "WARNING ! This will rename ALL THE FILES$INCDIR in directory and sub-directories.\nRun this script with -s to see what would happen.\nType 'y' to proceed, any other character to cancel.\n"
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
  declare -A ARRAY=([7z]= [apk]= [avi]= [bat]= [bak]= [batch]= [bmp]= [bz2]= [bookmark]= [c]= [cpp]= [cbr]= [cbz]= [conf]= [cp]= [cs]= [css]= [cxx]= [d]= [db]= [deb]= [diff]= [dump]= [epub]= [exe]= [flac]= [flv]= [gem]= [gif]= [go]= [gz]= [gzip]= [h]= [htm]= [html]= [ico]= [ini]= [java]= [jpeg]= [jpg]= [js]= [json]= [less]= [log]= [lua]= [markdown]= [md]= [mkv]= [mov]= [mp3]= [mp4]= [m4a]= [mpeg]= [mpg]= [m4v]= [m2ts]= [nfo]= [ogg]= [part]= [pdf]= [php]= [png]= [py]= [rar]= [rb]= [rc]= [rpm]= [rss]= [scala]= [scss]= [sh]= [slim]= [sln]= [sql]= [srt]= [sub]= [suo]= [tmp]= [tar]= [tgz]= [ts]= [torrent]= [twig]= [txt]= [vim]= [vimrc]= [wav]= [webm]= [wmv]= [xml]= [xz]= [yml]= [zip]=)
  if [[ ! -z "$TMPEXT" ]]; then
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
  if [ "$QUAL" == "y" ]; then # Strip things like resolutions, codecs, teams names, etc...
    SP="[_\ \.]"
    # [1080p] / 720p / Full HD / Blueray / HDlight
    NAME=$(echo "$NAME" | sed "s/\[\?[0-9]\+p\]\?//gI; s/full\ \?hd//gI; s/blue\?ray//gI; s/${SP}hd${SP}\?\(light\)\?//gI")
    # BRrip / DVDRip / Unrated / Multi / WEB / TrueFrench
    NAME=$(echo "$NAME" | sed "s/bd\?rr\?ip//gI; s/dvdrr\?ip//gI; s/${SP}unrated//gI; s/${SP}multi//gI; s/${SP}web//gI; s/${SP}true\([[:alpha:]]\+\)/\ \1/gI")
    # x264-something / H265-something / HEVC-something / DUAL-something
    NAME=$(echo "$NAME" | sed "s/${SP}[XxHh]\?26[45]-\?[[:alnum:]]*//g; s/${SP}hevc-\?[[:alnum:]]*//gI; s/${SP}dual-\?[[:alnum:]]*//gI")
    # AAC-something / EAC-something / AC3-something
    NAME=$(echo "$NAME" | sed "s/${SP}aac-\?[[:alnum:]]*//gI; s/${SP}eac-\?[[:alnum:]]*//gI; s/${SP}ac3-\?[[:alnum:]]*//gI")
    BY="b\?y\?${SP}\?" # "FilmTitle By Ganool.mp4"
    # YifY / BokutoX / SARTRE / MHdgz / ShinoStarr / AnoXmous / TugazX / MafiaKing / publicHD / Charmeleon / RARBG / AxxO / Ganool / SilverRG / Ghz / DTS
    # VppV / Aza(ze) / Gopo / Internal / Patzeb / OISTiLe / Penumbra / SHeNTo / CRiSC / WoLF / ViKAT / FaNGDiNG0 / PrisM / WHiiZz / CrEwSaDe / FLAWL3SS
    # HDAccess / beAst / (FZ)HD(S) / SpaceHD / RipleyHD / KiNGDOM / KLAXXON / iPlanet / DEViSE / NhaNc3 / aXXo / IMAGINE / LTRG / ViSION / Criterion / 10bit
    NAME=$(echo "$NAME" | sed "s/${BY}yify//gI; s/${BY}bokutox//gI; s/${BY}sartre//gI; s/${BY}mhdgz//gI; s/${BY}shinostarr\?//gI; s/${BY}anoxmous//gI; s/${BY}tugazx//gI; s/${BY}mafiaking//gI; s/${BY}publichd//gI; s/${BY}charmeleon//gI; s/${BY}rarbg//gI; s/${BY}axxo//gI; s/${BY}ganool//gI; s/${BY}silver${SP}\?rg//gI; s/${BY}ghz//gI; s/${BY}dts//gI; s/${BY}vppv//gI; s/${BY}azaz\?e\?//gI; s/${BY}gopo//gI; s/${BY}internal//gI; s/${BY}patzeb//gI; s/${BY}oistile//gI; s/${BY}penumbra//gI; s/${BY}shento//gI; s/${BY}crisc//gI; s/${BY}wolf//gI; s/${BY}vikat//gI; s/${BY}fangding[0o]//gI; s/${BY}prism//gI; s/${BY}whiizz//gI; s/${BY}crewsade//gI; s/${BY}flawl[3e]ss//gI; s/${BY}hdaccess//gI; s/${BY}beast//gI; s/${BY}f\?z\?hds\?//gI; s/${BY}spacehd//gI; s/${BY}ripleyhd//gI; s/${BY}kingdom//gI; s/${BY}klaxxon//gI; s/${BY}iplanet//gI; s/${BY}devise//gI; s/${BY}nhanc3//gI; s/${BY}axxo//gI; s/${BY}imagine//gI; s/${BY}ltrg//gI; s/${BY}vision//gI; s/${BY}criterion//gI; s/${BY}10bit//gI")
    # www.something.somedomain
    NAME=$(echo "$NAME" | sed "s/www\.[[:alnum:]]\+\.[[:alpha:]]\+//gI")
  fi
  if [ "$POSIX" == "y" ]; then # Strip accents, special characters, languages-specific terms
    SPEC="âäāáàãåçêëēéěèîïīíìńňôöōóòøûüūúùÿýžÂÄĀÁÀÅÇÊËĒÉĚÈÎÏĪÍÌÑŃŇÔÖŌÓÒØÛÜŪÚÙÝŸŽ"
    NORM="aaaaaaaceeeeeeiiiiinnoooooouuuuuyyzAAAAAACEEEEEEIIIIINNNOOOOOOUUUUUYYZ"
    NAME=$(echo "$NAME" | sed "s/[-\:\,\.' ]/${SEP}/g; y/$SPEC/$NORM/")
    if [ "$FR" == "y" ]; then # Strip remaining l', t', s', j', m', d' and replace <&> by <et>
      NAME=$(echo "$NAME" | sed "s/_[ltsjmd]_/_/gI; s/\&/et/g")
    fi
    if [ "$EN" == "y" ]; then # Strip remaining 's and replace <&> by <and>
      NAME=$(echo "$NAME" | sed "s/_s_/_/gI; s/\&/and/g")
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