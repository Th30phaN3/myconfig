# /etc/skel/.bash_logout

# This file is sourced when a login shell terminates.

# Clear the screen for security's sake.
clear

[ "$TERM" = "linux" ] && [ -z $SSH_TTY ] && \
	sudo splash_manager -c set --theme="$TTY_LOGIN_THEME"
