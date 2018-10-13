# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.

if shopt -q login_shell; then
	[[ -f ~/.bashrc ]] && source ~/.bashrc
	#start Xorg
	[[ -t 0 && !$DISPLAY ]] && exec startx
else
	exit 1
fi
