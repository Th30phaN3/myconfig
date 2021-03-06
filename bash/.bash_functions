#
#  _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
# |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
# | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
# |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
# |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
#
# These functions depends on aliases described in .bash_aliases
# ##<function name>: <description>

# Override "ranger", allows to run same instance of ranger from shell inside ranger
ranger()
{
  if [ -z "$RANGER_LEVEL" ]; then
    /usr/bin/ranger "$@"
  else
    exit
  fi
}

# Special function used to update term title before every command
set_term_title()
{
  # Display title with this format: "$PWD -> TERM"
  echo -ne "\033]0;$(echo $PWD) -> TERM\007"
  # Display title using history ((strip command number and dates) with this format: "$PWD -> <command executed>"
  #echo -ne "\033]2;$(xcwd) -> $(history 1 | sed "s/^[ ]*[0-9]*[ ]*[0-9\-]*[ ]*[0-9:]*[ ]*//g")\007"
}

## func_help: Display help for $1 (custom bash function)
func_help() { grep "## .*$1.*" "$HOME"/.bash_functions | sort ; } # | grep -v "## $1" | sort ; }

## mcd: Create $1 directory and move into it
mcd() { mkdir -p "$1"; cd "$1" || return; }

## cls: Move into $1 directory and list files
cls() { cd "$1" || return; ll; }

## fdup: Find and print duplicate lines in $1 (filename)
fdup() { sort "$1" | uniq -cd | sort -nr ; }

## pack: Search for $1 as ebuild, python package, npm package, rust package and nuget package
pack() { echo -e "-----\nEBUILDS:" && eix -R "$1"; echo -e "\n-----\nPYTHON PACKAGES:" && pip search "$1"; echo -e "\n-----\nJS PACKAGES:" && npm search "$1"; echo -e "\n-----\nCRATES:" && cargo search --color always -v "$1"; echo -e "\n-----\nNUGET PACKAGES:" && mono /usr/local/bin/nuget.exe list "$1" -ForceEnglishOutput -NonInteractive; }

## cleanhome: Remove junk, cache data, history files, etc... (! WARNING ! CAN RESET PROGRAMS STATES !)
cleanhome()
{
  local JUNKLIST="$HOME/.junk"
  local LOGFILE="$HOME/.cleanhome.log"
  history -cw
  echo "Clean effectued on $(date +%c)" 1>> "$LOGFILE" 2> /dev/null
  while IFS= read -r LINE
  do
    \rm -rv $LINE 1>> "$LOGFILE" 2> /dev/null
  done < "$JUNKLIST"
}

## backup: Make a backup of $1 (filename)
backup() { cp "$1"{,.bak} ; }

## mymount: Mount based on filesystems ($1 is either "android" or block device name, $2 is mountpoint)
mymount()
{
  if [[ -z "$1" || -z "$2" ]]
    then
      lsblk -lfmp
    else
      if [[ "$1" == "android" ]]
        then
          simple-mtpfs "$2"
        else
          FSTYPE=$(lsblk -lfmp | grep "$1" | sed "s/[^ ]* \([[:alnum:]]\+\).*/\1/g")
          SUDO=''
          if (( EUID != 0 )); then
            SUDO='sudo' # Ugly trick to run as root (requires sudo rights)
          fi
          case "$FSTYPE" in
            "exfat") "$SUDO" mount.exfat-fuse "$1" "$2";;
            "ntfs" | "vfat") "$SUDO" mount "$1" "$2";;
            *) echo "Failed to mount $1 !";;
          esac
      fi
  fi
}

## editassudo: Run $EDITOR as sudo if $1 (filename) is not writable by standard user
editassudo()
{
  local sudo edit
  sudo=
  edit="${EDITOR:-VISUAL}"
  if test -e "$1"; then
    if test ! -w "$1"; then
      if test -t 0 && test -t 2; then
        printf "%s is not writable. Edit with sudo? [y/n]\n" "$1" 1>&2
        read -rn 1
        case $REPLY in
          y|Y|yes|Yes) sudo=true;;
          n|N|no|No) sudo=;;
          *) printf "\nExpected y or n. Exiting.\n" 1>&2
             exit 1;;
        esac
      else
        printf "%s is not writable. Fix the permissions." "$1" 1>&2
        exit 1
      fi
    fi
  elif test ! -w .; then
    if test -t 0 && test -t 2; then
      printf "%s is not writable. Edit with sudo? [y/n]\n" "$1" 1>&2
      read -rn 1
      case $REPLY in
        y|Y|yes|Yes) sudo=true;;
        n|N|no|No) sudo=;;
        *) printf "\nExpected y or n. Exiting.\n" 1>&2
           exit 1;;
      esac
    else
      printf "%s is not writable. Fix the permissions." "$1" 1>&2
      exit 1
    fi
  fi
  ${sudo:+sudo} "$edit" "$1"
}

## sysbackup: Backup the entire system (! WARNING ! CAN TAKE A LONG TIME !)
sysbackup()
{
  printf "WARNING ! This command will perform a global backup of your system and may take a long time to complete. Do you wish to proceed ? Type 'y' to proceed, any other character to cancel.\n"
  read -r OK
  if [ "$OK" != "y" ]; then
    echo "User cancelled"
    exit
  fi
  TARFILE="$HOME/backup/sysbackup-$(date +%F).tar.xz"
  SUDO=''
  if (( EUID != 0 )); then
    SUDO='sudo' # Ugly trick to run as root (requires sudo rights)
  fi
  "$SUDO" tar --exclude-from="$HOME/backup/sys_exclude" -cJpvf "$TARFILE" /
}

## ubackup: Backup user data (! WARNING ! CAN TAKE A LONG TIME !)
ubackup()
{
  printf "WARNING ! This command will perform a global backup of your data and may take a long time to complete. Do you wish to proceed ? Type 'y' to proceed, any other character to cancel.\n"
  read -r OK
  if [ "$OK" != "y" ]; then
    echo "User cancelled"
    exit
  fi
  TARFILE="$HOME/backup/databackup-$(date +%F).tar.xz"
  SUDO=''
  if (( EUID != 0 )); then
    SUDO='sudo' # Ugly trick to run as root (requires sudo rights)
  fi
  "$SUDO" tar --exclude-from="$HOME/backup/data_exclude" -cJpvf "$TARFILE" "$HOME"
}

## safe_rm: Instead of deleting files, move them into trash directory
safe_rm()
{
  local d t f s
  [ -z "$PS1" ] && (/bin/rm "$@"; return)
  d="${TRASH_DIR:=$HOME/.trash}/$(date +%W)"
  t=$(date +%F_%H-%M-%S)
  [ -e "$d" ] || mkdir -p "$d" || return
  for f do
    [ -e "$f" ] || continue
    s=$(basename "$f")
    /bin/mv "$f" "$d/${t}_$s" || break
  done
  echo -e "[$? $t $(pwd)]$*\n" >> "$d/log_rm.txt"
}

## tpt: Put the file $1 in the Trash with its associated image-preview
tpt() { tp "${1}" && tp Thumbnails/"${1}.png" ; }

## ff: Find a file with pattern $1
ff() { find . -type f -iname '*'"$*"'*' -ls ; }

## fe: Find a file with pattern $1 and execute $2 on it
fe() { find . -type f -iname '*'"${1:-}"'*' -exec "${2:-file}" {} \; ; }

## fstr: Find $1 (pattern) in $2 (filename pattern) and highlight result
fstr()
{
  OPTIND=1
  local mycase=""
  local usage='fstr: find string in files. Usage: fstr [-i] "pattern" ["filename pattern"] '
  while getopts :it opt
  do
    case "$opt" in
      i) mycase="-i " ;;
      *) echo "$usage"; return ;;
    esac
  done
  shift $(( OPTIND - 1 ))
  if [ "$#" -lt 1 ]; then
    echo "$usage"
    return;
  fi
  find . -type f -name "${2:-*}" -print0 | xargs -0 egrep --color=always -sn "${mycase}" "$1" 2>&- | more
}

## swap: Swap $1 with $2 (filenames)
swap()
{
  local TMPFILE=tmp.$$
  [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
  [ ! -e "$1" ] && echo "swap: $1 does not exist" && return 1
  [ ! -e "$2" ] && echo "swap: $2 does not exist" && return 1
  mv "$1" "$TMPFILE"
  mv "$2" "$1"
  mv "$TMPFILE" "$2"
}

## rmprefix: Remove $2 prefix from all files with $1 extension
rmprefix()
{
  for f in *."$1"; do
    mv "$f" "${f/$2/}"
  done
}

## addprefix: Add $2 prefix from all files with $1 extension
addprefix()
{
  for f in *."$1"; do
    mv "$f" "$2${f%%}"
  done
}

## extract: Extract $1 (archive) based on extension
extract()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xvjf "$1"     ;;
      *.tar.gz)    tar xvzf "$1"     ;;
      *.bz2)       bunzip2 "$1"      ;;
      *.rar)       unrar x "$1"      ;;
      *.gz)        gunzip "$1"       ;;
      *.tar)       tar xvf "$1"      ;;
      *.tbz2)      tar xvjf "$1"     ;;
      *.tgz)       tar xvzf "$1"     ;;
      *.zip)       unzip "$1"        ;;
      *.Z)         uncompress "$1"   ;;
      *.7z)        7z x "$1"         ;;
      *)           echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file. Your trial has expired. Please purchase a valid copy of WinRar."
  fi
}

## maketar: Creates a tar.gz archive from $1 (directory)
maketar() { tar cvzf "${1%%/}.tar.gz" "${1%%/}/" ; }

## makezip: Creates a zip archive of $1 (file or folder)
makezip() { zip -r "${1%%/}.zip" "$1" ; }

## mytop: Show the 10 most used commands in history
mytop()
{
  local COUNT
  COUNT='{CMD[$4]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'
  history | awk "$COUNT" | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}

## pong: Nothing more useful than watching your cursor bounce (cannot be stopped !)
pong()
{
  yes $COLUMNS $LINES | awk 'BEGIN{x=y=e=f=1}{if(x==$1||!x){e*=-1};if(y==$2||!y){f*=-1};x+=e;y+=f;printf "\033[%s;%sH",y,x;system("sleep .02")}'
}

## ntwk: Print useful network info
ntwk()
{
  echo "Ethernet:  $(ifconfig enp0s25 | awk '/inet/ { print $2 } ' | tr '\n' ' ')"
  echo "Wifi:      $(ifconfig wlo1 | awk '/inet/ { print $2 } ' | tr '\n' ' ')"
  echo "Public IP: $(curl -s ifconfig.me)"
  echo "DHCP:      $(sed '/^#/d' /etc/resolv.conf | tr '\n' ' ')"
  echo -e "Routes:\n$(ip route)"
}

## mvfltosamedir: Move files in sub-directories with $1 extension to $2 directory (preserve duplicates)
mvfltosamedir() { find . -type f -iname "*.$1" -exec mv --backup=numbered -t "$2" {} +; }

## stripurls: Take $1 (plain text file containing urls) and keep only "0.0.0.0 [domain name]"
stripurls()
{
  local FILETOREAD FILETOWRITE FINALFILE DN
  FILETOREAD="$1"
  FILETOWRITE=cleandomainname.tmp
  FINALFILE=cleandomainname
  if [ ! -f "$FILETOWRITE" ]
  then
    touch "$FILETOWRITE"
  fi
  while read -r l; do
    # Keep only domain name
    DN=$(echo "$l" | sed -e 's|^[^/]*//||' -e 's|/.*$||')
    echo "0.0.0.0 $DN" >> "$FILETOWRITE"
  done < "$FILETOREAD"
  # Delete similar lines
  awk '!seen[$0]++' "$FILETOWRITE" > "$FINALFILE"
  # Display similar lines deleted
  diff --suppress-common-lines --color=always "$FILETOWRITE" "$FINALFILE"
}

## livelog: Display a log including all errors from multiple log files
livelog()
{
  multitail --config "$HOME/.config/multitail/multitail.conf" -ts -M 0 -D -Cs -E "[Ee]rror" --no-repeat --mergeall \
  /var/log/Xorg.0.log \
  /var/log/Xorg.1.log \
  /var/log/Xorg.2.log \
  /var/log/Xorg.3.log \
  /var/log/Xorg.4.log \
  /var/log/Xorg.5.log \
  /var/log/Xorg.6.log \
  /var/log/Xorg.7.log \
  /var/log/Xorg.8.log \
  /var/log/Xorg.9.log \
  /var/log/auth.log \
  /var/log/daemon.log \
  /var/log/debug \
  /var/log/dmesg \
  /var/log/docker.log \
  /var/log/emerge-fetch.log \
  /var/log/emerge.log \
  /var/log/kern.log \
  /var/log/lpr.log \
  /var/log/messages \
  /var/log/syslog \
  /var/log/user.log \
  /var/log/wpa_supplicant.log \
  /var/log/portage/elog/summary.log
}

## gifwal: Display random gif as wallpaper
gifwal()
{
  local FILE DIR_GIF CMD
  DIR_GIF=$HOME/pics/wallpapers/gif
  # Get 1 random file from directory
  FILE=$(find "$DIR_GIF" -type f | shuf -n 1)
  # Kill all xwinwrap process (alternative: pidof xwinwrap | kill)
  killall -q xwinwrap
  CMD="xwinwrap -g 1920x1080 -ov -- mpv --no-terminal --loop-file=inf --no-stop-screensaver --no-input-default-bindings --no-osc --osd-level=0 -wid WID $FILE"
  # Detach cmd from terminal
  nohup $CMD > /dev/null 2>&1 &
}

## pserv: Start a local phph test server with random port
pserv()
{
  local PORT
  PORT=$((RANDOM%6000+2001))
  echo "Starting PHP test server on port $PORT..."
  #php -S 127.0.0.1:$PORT
  php bin/console server:start 127.0.0.1:$PORT
}

## typethis: Simulate human typing $1 (message or filename)
typethis()
{
  if [ -r "$1" ]; then
    pv -qL 10 "$1"
  else
    echo "$1" | pv -qL 10
  fi
}

## atmp3: Add ID3 Artist and Title tags to mp3 files based on filename ("Artist - MusicName.mp3") and clean up unnecessary tags (lyrics, comments...), force UTF8 encoding and 2.4 version
atmp3()
{
  local SONG ARTIST TITLE
  for i in *.mp3; do
    SONG=$(basename "$i" .mp3)
    ARTIST=$(echo "$SONG" | awk -F " - " '{print $1}')
    TITLE=$(echo "$SONG" | awk -F " - " '{print $2}')
    eyeD3 -Q --encoding utf8 --to-v2.4 --remove-all-lyrics --remove-all-comments --remove-all-objects --user-text-frame='major_brand:' --user-text-frame='minor_version:' --user-text-frame='compatible_brands:' --user-text-frame='description:' --user-text-frame='comment:' --user-text-frame='purl:' --user-text-frame='Software:' --user-text-frame='Tagging time:' --user-text-frame='coding_history:' --user-text-frame='time_reference:' --user-text-frame='umid:' -c "" --tagging-date "" --encoding-date "" -a "$ARTIST" -t "$TITLE" "$SONG.mp3"
  done
}

## muexif: complete EXIF metadata for mp3 files based on ID3 tags
muexif()
{
  local SONG TITLE ARTIS ALBUM GENRE NBTRACK TOTRACK YEAR
  for i in *.mp3; do
    SONG=$(eyeD3 "$i")
    TITLE=$(echo "$SONG" | awk -F "title: " '{print $2}' | grep -v '^$')
    ARTIS=$(echo "$SONG" | awk -F "artist: " '{print $2}' | grep -v '^$')
    ALBUM=$(echo "$SONG" | awk -F "album: " '{print $2}' | grep -v '^$')
    GENRE=$(echo "$SONG" | awk -F "genre: " '{print $2}' | grep -v '^$' | sed 's/ ([^)]*)//g')
    #NBTRACK=$(echo "$SONG" | awk -F "track: " '{print $2}' | grep -v '^$' | sed 's#genre:.*##g; s#/.*##g' | tr -d '[:space:]')
    # Write {track number}/{total tracks} in the same tag
    NBTRACK=$(echo "$SONG" | awk -F "track: " '{print $2}' | grep -v '^$' | sed 's#genre:.*##g' | tr -d '[:space:]')
    #TOTRACK=$(echo "$SONG" | awk -F "track: " '{print $2}' | grep -v '^$' | sed 's#genre:.*##g; s#.*/\([0-9]*\).*#\1#g' | tr -d '[:space:]')
    YEAR=$(echo "$SONG" | awk -F "release date: " '{print $2}' | grep -v '^$')
    echo "|_${TITLE}_|_${ARTIS}_|_${ALBUM}_|_${GENRE}_|_${NBTRACK}_|_${TOTRACK}_|_${YEAR}_|"
    # USELESS => MP3 tags in read-only !
    #exiftool -Title="$TITLE" -Artist="$ARTIS" -Album="$ALBUM" -Genre="$GENRE" -Track="$NBTRACK" -Year="$YEAR" "$i"
  done
}

## togoodmp3: Convert files with $1 extension to 220-260kbps mp3 files
togoodmp3()
{
  for f in *."$1"; do
    ffmpeg -hide_banner -i "$f" -acodec libmp3lame -aq 0 "TGMP3_${f%.$1}.mp3"
  done
}

## m2tstomp4: Transform $1 (m2ts file) to mp4 file with 1920x1080 resolution (CPU-intensive function !)
m2tstomp4()
{
  if (( EUID != 0 )); then
    SUDO='sudo'
  fi
  "$SUDO" nice --10 ffmpeg -hide_banner -i "$1" -ar 48000 -ab 128k -vcodec libx264 -s 1920x1080 -aspect 16:9 -crf 25 "${1%.m2ts}.mp4"
}

## recordX: Record x11 screen and save it as "$1.avi" (or "xrecord.avi" by default)
recordX() { ffmpeg -f X11grab -s 1920x1080 -r 30 -i :0.0 -qscale 0 -vcodec huffyuv "${1:-xrecord}.avi" ; }

## cutvid: Cut portion of video $1 beginning from $2 (h:m:s) to $3 (h:m:s) for a simple cut
cutvid() { ffmpeg -hide_banner -i "$1" -c copy -ss "$2" -to "$3" "kut_$1" ; }

## kutvid: Cut portion of video $1 beginning from $2 (h:m:s) to $3 (h:m:s) for consecutive cuts
kutvid()
{
  local NWFILE NB
  NWFILE="kut0_${1}"
  if [[ -e "$NWFILE" ]] ; then
    NB=1
    while [[ -e "kut${NB}_${1}" ]] ; do
      ((NB++))
    done
    NWFILE="kut${NB}_${1}"
  fi
  ffmpeg -hide_banner -ss "$2" -i "$1" -to "$3" -c copy -copyts -avoid_negative_ts 1 "$NWFILE"
}

## mergvid: Concatenate multiple videos together (should be listed in order) with format $1 into new video
mergvid() { ffmpeg -hide_banner -f concat -safe 0 -i <(printf "file '$PWD/%s'\n" ./*."$1") -c copy "$RANDOM.$1" ; }

## nicevid: Reencode video $1 using 1920x1080 resolution and H264
nicevid() { ffmpeg -hide_banner -i "$1" -max_muxing_queue_size 4096 -vf scale=1920:1080 -c:v libx264 -crf 25 "nice_${1%.*}.mp4" ; }

## cleanvids: Reencode all large mp4 videos (size superior to 1.8G) using 1920x1080 resolution and H264 (CPU-intensive function !)
cleanvids()
{
  local SUDO MAXSIZE ACTUALSIZE FRES
  MAXSIZE=1801000000 #1.801G
  SUDO=''
  if (( EUID != 0 )); then
    SUDO='sudo' # Ugly trick to run as root (requires sudo rights)
  fi
  for f in *.mp4; do
    if [[ "$f" != nice_*.mp4 ]]; then
      ACTUALSIZE=$(wc -c < "$f")
      FRES=$(exiftool -ImageSize "$f" | tr -d '[:space:]' | sed 's/ImageSize\://g;s/x.*//g')
      FRES=$((FRES+0)) # Transform a string to an int
      if [[ "$ACTUALSIZE" -ge "$MAXSIZE" ]] && [[ $FRES -ge 1920 ]]; then
        "$SUDO" nice --10 ffmpeg -hide_banner -i "$f" -max_muxing_queue_size 4096 -vf scale=1920:1080 -c:v libx264 -crf 25 "nice_${f}"
      fi
    fi
  done
}

## mkthumb: Create mosaic-like image to preview video content with $1(columns x rows)(3x5 by default) thumbnails
mkthumb()
{
  NBIMG="${1:-3x5}" # Default to 15 images
  local THUMBDIR FONT
  THUMBDIR="Thumbnails"
  FONT="/home/wegeee/.local/share/fonts/segoe-ui-light.ttf"
  mkdir -pv "$THUMBDIR"
  for f in *.*; do
    if [ ! -f "${THUMBDIR}/${f}.png" ]; then
      # 1000 pixels width, ${NBIMG} thumbnails, PNG format
      vcsi "$f" --timestamp-font $FONT --metadata-font $FONT -t -w 1000 -g "${NBIMG}" -f png -o "${THUMBDIR}/${f}.png"
    fi
  done
}

## sm: Search and print man pages as pdf
sm()
{
  if [ -r ~/.config/dmenu/dmenurc ]; then
    # shellcheck source=/dev/null
    source ~/.config/dmenu/dmenurc
  else
    DMENU='dmenu'
  fi
  man -k . | $DMENU -l 30 | awk '{print $1}' | xargs -r "man" -Tpdf | zathura -
}

## man: Override "man", display pages with colors
man()
{
  #LESS_TERMCAP_mb=$'\e[01;31m' \
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}

## postjson: POST $1 (json) to $2 (URL)
postjson() { curl -X POST -H "Content-Type: application/json" -d "$1" "$2" ; }

## get4chanthread: Downloads all images from $1 (4chan thread URL)
get4chanthread() { wget -P ~/pics/4chan/rip/"$(date +%F-%R)" -nd -nc -r -l 1 -H -D i.4cdn.org -A png,gif,jpg,jpeg,webm --reject-regex='s.jpg' "$1" ; }

## rnmfileindir: Prefix files in all subdirectories with directory's name
rnmfileindir()
{
  for i in *; do
    if [ -d "$i" ]; then
      cd "$i" || return
      for j in *; do
        \mv -v "$j" "${i}_${j}"
      done
      cd ..
    fi
  done
}

## dnslookup: Use HackerTarget API to see DNS records for $1 (domain), simple alternative to whois
dnslookup() { curl "https://api.hackertarget.com/dnslookup/?q=$1" ; }

## addov: Add overlay $1 using Layman and mask every packages in it
addov()
{
  if (( EUID != 0 )); then
    SUDO='sudo'
  fi
  "$SUDO" layman -a "$1" && "$SUDO" sh -c "echo '*/*::$1' > '/etc/portage/package.mask/ov_$1'"
}


op() { setsid ${OPENER:-xdg-open} "$@" & disown ; }

opp() { setsid ${OPENER:-xdg-open} "$@" & disown ; exit ; }

xevi() { xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] }NR in a { printf "%-3s %s\n", $5, $8 }' ; }
