# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
#unset -v HOME

if shopt -q login_shell; then
	. /etc/tty_theme
	sudo splash_manager -c set --theme=$TTY_THEME
	[[ -f ~/.bashrc ]] && source ~/.bashrc
	[[ -t 0 && !$DISPLAY ]] && exec startx
else
	exit 1
fi
