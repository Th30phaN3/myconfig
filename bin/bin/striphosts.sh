#!/bin/bash
#
# Comment a specific line from hosts file
# Allows to access that site

HOSTS="/etc/hosts"
SUDO=''
if (( EUID != 0 )); then
  SUDO='sudo' # Ugly trick to run as root (requires sudo rights)
fi

# Get primary selection and strip spaces
SELECT="$(xclip -o | tr -d '[:space:]')"
# Get site name with or without www.
if [[ "$SELECT" =~ ^www\..* ]]; then
  WWWSELECT="${SELECT#www.}"
else
  WWWSELECT="www.${SELECT}"
fi

"$SUDO" sed -i 's/\(^0.0.0.0 '"${SELECT}"'$\)/#\1/; s/\(^0.0.0.0 '"${WWWSELECT}"'$\)/#\1/' "$HOSTS"

notify.sh "Commented ${SELECT} and ${WWWSELECT}"