#!/bin/bash
#
# Without argument: Comment the specific line contained in clipboard in /etc/hosts file.
# With 1 filename argument: Comments all the lines written in file in /etc/hosts file.

HOSTS="/etc/hosts"

SUDO=''
# Ugly trick to run as root (requires global sudo rights)
if (( EUID != 0 )); then
  SUDO='sudo'
fi

if [[ -e "$1" && -r "$1" ]]; then
  while IFS= read -r LINE; do
    "$SUDO" sed -i 's/\(^0.0.0.0 '"${LINE}"'$\)/#\1/' "$HOSTS"
  done < "$1"
else
  WHITELIST_GLOBAL="/etc/hosty/whitelist"
  WHITELIST_USER="/home/wegeee/.hosts.whitelist"

  # Get primary selection and strip spaces
  SELECT="$(xclip -o | tr -d '[:space:]')"

  # Get site name with and without www.
  if [[ "$SELECT" =~ ^www\..* ]]; then
    WWWSELECT="${SELECT#www.}"
  else
    WWWSELECT="www.${SELECT}"
  fi

  "$SUDO" sed -i 's/\(^0.0.0.0 '"${SELECT}"'$\)/#\1/; s/\(^0.0.0.0 '"${WWWSELECT}"'$\)/#\1/' "$HOSTS"

  "$SUDO" echo "$WWWSELECT" >> "$WHITELIST_GLOBAL"
  "$SUDO" echo "$SELECT" >> "$WHITELIST_GLOBAL"

  echo "$WWWSELECT" >> "$WHITELIST_USER"
  echo "$SELECT" >> "$WHITELIST_USER"

  notify.sh "Whitelisted ${SELECT} and ${WWWSELECT}"
fi
