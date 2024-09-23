# /etc/skel/.bash_logout
#
# This file is sourced when a login shell terminates.

# Kill ssh-agent on logout
#if [ -n "$SSH_AUTH_SOCK" ] ; then
#  eval $(/usr/bin/ssh-agent -k)
#fi

# Clear the screen for security's sake.
clear
