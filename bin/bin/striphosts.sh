#!/bin/bash
#
# Comment a specific line from hosts file
# Allows to access that site

HOSTS="/etc/hosts"
WHITELIST="/etc/hosty/whitelist"
SUDO=''
# Ugly trick to run as root (requires global sudo rights)
if (( EUID != 0 )); then
  SUDO='sudo'
fi

# Get primary selection and strip spaces
SELECT="$(xclip -o | tr -d '[:space:]')"
# Get site name with and without www.
if [[ "$SELECT" =~ ^www\..* ]]; then
  WWWSELECT="${SELECT#www.}"
else
  WWWSELECT="www.${SELECT}"
fi

"$SUDO" sed -i 's/\(^0.0.0.0 '"${SELECT}"'$\)/#\1/; s/\(^0.0.0.0 '"${WWWSELECT}"'$\)/#\1/' "$HOSTS"
"$SUDO" echo "$WWWSELECT" >> "$WHITELIST"
"$SUDO" echo "$SELECT" >> "$WHITELIST"

notify.sh "Whitelisted ${SELECT} and ${WWWSELECT}"
