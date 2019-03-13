#
#  _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
# |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
# | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
# |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
# |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
#

# For going up a certain number of directories and back
function up()
{
  LIMIT=$1
  P=$PWD
  for ((i=1; i <= LIMIT; i++))
  do
    P=$P/..
  done
  cd $P
  export MPWD=$P
}

function back()
{
  LIMIT=$1
  P=$MPWD
  for ((i=1; i <= LIMIT; i++))
  do
    P=${P%/..}
  done
  cd $P
  export MPWD=$P
}

# Create a directory and move into it
function mcd() { mkdir -p $1; cd $1; }

# Move into directory and list files
function cls() { cd "$1"; ll; }

# Remove junk, cache data, history files, trash, etc...
function cleanhome()
{
  JUNKLIST="$HOME/.junk"
  LOGFILE="/var/log/cleanhome.log"
  history -cw
  while IFS= read -r line
  do
    \rm -rv $line >> "$LOGFILE"
  done < "$JUNKLIST"
}

# Make a backup of the specified file
function backup() { cp "$1"{,.bak}; }

# Mount based on filesystems ($1 is either android or block device name, $2 is mountpoint)
function mymount()
{
  if [ "$1" == "android" ]
    then
      simple-mtpfs "$2"
    else
      FSTYPE=$(lsblk -lfmp | grep "$1" | sed "s/[^ ]* \([[:alnum:]]\+\).*/\1/g")
      SUDO=''
      if (( $EUID != 0 )); then
        SUDO='sudo' # Ugly trick to run as root (requires sudo rights)
      fi
      case "$FSTYPE" in
        "exfat") "$SUDO" mount.exfat-fuse "$1" "$2";;
        "ntfs") "$SUDO" mount "$1" "$2";;
        *) echo "Failed to mount $1 !";;
      esac
  fi
}

# Run $EDITOR as sudo if file is not writable by standard user
function editassudo()
{
  sudo=
  editor="$EDITOR"
  if test -e "$1" && test ! -w "$1"; then
    if test -t 0 && test -t 2; then
      printf "%s is not writable. Edit with sudo? [y/n] " "$1" 1>&2
      read -n 1
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
  ${sudo:+sudo} "$editor" "$1"
}

# Use DNS to query wikipedia (wiki QUERY)
function wiki() { dig +short txt $1.wp.dg.cx; }

# Backup the entire system ! WARNING ! CAN TAKE A LONG TIME !
function system_backup()
{
  printf "WARNING ! This command will perform a global backup of your system and may take a long time to complete. Do you wish to proceed ? Type 'y' to proceed, any other character to cancel.\n"
  read OK
  if [ "$OK" != "y" ]; then
    echo "User cancelled"
    exit
  fi
  TARFILE=$HOME/backup/sysbackup-$(date +%F).tar.xz
  SUDO=''
  if (( $EUID != 0 )); then
    SUDO='sudo' # Ugly trick to run as root (requires sudo rights)
  fi
  "$SUDO" tar --exclude-from=$HOME/backup/sys_exclude -cJpvf $TARFILE /
}

# Backup user data ! WARNING ! CAN TAKE A LONG TIME !
function data_backup()
{
  printf "WARNING ! This command will perform a global backup of your data and may take a long time to complete. Do you wish to proceed ? Type 'y' to proceed, any other character to cancel.\n"
  read OK
  if [ "$OK" != "y" ]; then
    echo "User cancelled"
    exit
  fi
  TARFILE=$HOME/backup/databackup-$(date +%F).tar.xz
  SUDO=''
  if (( $EUID != 0 )); then
    SUDO='sudo' # Ugly trick to run as root (requires sudo rights)
  fi
  "$SUDO" tar --exclude-from=$HOME/backup/data_exclude -cJpvf $TARFILE $HOME
}

# Instead of deleting files, move them into trash directory
function safe_rm()
{
  local d t f s
  [ -z "$PS1" ] && (/bin/rm "$@"; return)
  d="${TRASH_DIR:=$HOME/.trash}/`date +%W`"
  t=`date +%F_%H-%M-%S`
  [ -e "$d" ] || mkdir -p "$d" || return
  for f do
    [ -e "$f" ] || continue
    s=`basename "$f"`
    /bin/mv "$f" "$d/${t}_$s" || break
  done
  echo -e "[$? $t `pwd`]$@\n" >> "$d/log_rm.txt"
}

# Find a file with a pattern in name
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

# Find a file with pattern $1 in name and execute $2 on it
function fe() { find . -type f -iname '*'"${1:-}"'*' -exec ${2:-file} {}; }

# Find a pattern in a set of files and highlight them
function fstr()
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
  shift $(( $OPTIND - 1 ))
  if [ "$#" -lt 1 ]; then
    echo "$usage"
    return;
  fi
  find . -type f -name "${2:-*}" -print0 | xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more
}

# Swap 2 filenames around, if they exists
function swap()
{
  local TMPFILE=tmp.$$
  [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
  [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
  [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1
  mv "$1" $TMPFILE
  mv "$2" "$1"
  mv $TMPFILE "$2"
}

# Handy Extract Program
function extract()
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
    echo "'$1' is not a valid file!"
  fi
}

# Creates an archive (*.tar.gz) from given directory
function maketar() { tar cvzf "${1%%/}.tar.gz" "${1%%/}/"; }

# Create a ZIP archive of a file or folder
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# Show the 10 most used commands in history
function mytop()
{
  COUNT='{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'
  history | awk "$COUNT" | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}

# Get IP adress on ethernet
function myip()
{
  MY_IP=$(ifconfig enp0s25 | awk '/inet/ { print $2 } ' | sed -e s/addr://)
  echo ${MY_IP:-"Not connected"}
}

# Cut portion of video $1 beginning from $2 for $3 h/m/s into new video $4
function cutvid() { ffmpeg -hide_banner -i "$1" -c copy -ss $2 -t $3 "$4.${1##*.}"; }

# Concatenate multiple videos together with format $1 into new video with random filename
function mergevid() { ffmpeg -hide_banner -f concat -safe 0 -i <(printf "file '$PWD/%s'\n" ./*."$1") -c copy "$RANDOM.$1"; }

# Used for creating mosaic-like image to preview video content
function mkthumb()
{
  mkdir -pv Thumbnails
  # 1000 pixels width, 15 images
  for f in *.*; do vcsi $f -t -w 1000 -g 3x5 -f png -o Thumbnails/$f.png; done
}

# Keep only the domain name from a url (take a plain text file containing urls as input)
# Used to update the hosts file, add "0.0.0.0 " in front of the clean url
function stripurls()
{
  FILETOREAD=$1
  FILETOWRITE=cleandomainname.tmp
  FINALFILE=cleandomainname
  if [ ! -f $FILETOWRITE ]
  then
    touch $FILETOWRITE
  fi
  while read l; do
    # keep only domain name
    DN=$(echo "$l" | sed -e 's|^[^/]*//||' -e 's|/.*$||')
    echo "0.0.0.0 $DN" >> $FILETOWRITE
  done < $FILETOREAD
  # delete similar lines
  awk '!seen[$0]++' $FILETOWRITE > $FINALFILE
  # display similar lines deleted
  diff --suppress-common-lines --color=always $FILETOWRITE $FINALFILE
}

# Display a log including all errors from multiple log files
function livelog()
{
  multitail -D -Cs -E "[Ee]rror" --no-repeat --mergeall \
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
  /var/log/mpd \
  /var/log/newsboat.log \
  /var/log/syslog \
  /var/log/user.log \
  /var/log/wpa_supplicant.log \
  /var/log/portage/elog/summary.log
}

# Display random gif as wallpaper
function gifwal()
{
  DIR_GIF=$HOME/pics/wallpapers/gif
  #Get 1 random file from directory
  FILE=$(ls $DIR_GIF | shuf -n 1)
  #Kill all xwinwrap process, alternative -> pidof xwinwrap | kill
  killall -q xwinwrap
  CMD="xwinwrap -g 1920x1080 -ov -- mpv --no-terminal --loop-file=inf --no-stop-screensaver --no-osc -wid WID $DIR_GIF/$FILE"
  #Detach cmd from terminal
  nohup $CMD > /dev/null 2>&1 &
}

# Start a local test server in php with random port
function pserv()
{
  PORT=$(($RANDOM%6000+2001))
  echo "Starting PHP test server on port $PORT..."
  #php -S 127.0.0.1:$PORT
  php bin/console server:start 127.0.0.1:$PORT
}

# Simulate human typing message or file content
function typethis()
{
  if [ -r $1 ]; then
    cat "$1" | pv -qL 10
  else
    echo "$1" | pv -qL 10
  fi
}

# Show Bash colors
function bcolor() { for code in {0..255}; do echo -e "\e[38;05;${code}m $code: Color"; done }

# Add ID3 Artist tag and ID3 Title tag to mp3 files based on filename (Artist - MusicName.mp3)
function atmp3()
{
  for i in *.mp3; do
    SONG=$(basename "$i" .mp3)
    ARTIST=$(echo "$SONG" | awk -F " - " '{print $1}')
    TITLE=$(echo "$SONG" | awk -F " - " '{print $2}')
    eyeD3 --artist "$ARTIST" --title "$TITLE" "$SONG.mp3"
  done
}

# Allow to run same instance of ranger from shell inside ranger
function ranger()
{
  if [ -z "$RANGER_LEVEL" ]; then
    /usr/bin/ranger "$@"
  else
    exit
  fi
}