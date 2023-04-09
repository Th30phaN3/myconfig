# /etc/skel/.bash_profile
# This file is sourced by bash for login shells.
# Order of load: /etc/profile > bash_profile (or .bash_login or .profile if not found) > xinitrc >> bashrc (only on new terminal load)
# xinitrc file sources Xresources, Xmodmap, xprofile then execute xserverrc
# Reference: https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/

if shopt -q login_shell; then

  # Desktop variables for wm/de
  export DESKTOP_SESSION="i3"
  export GDMSESSION="i3"
  export MDMSESSION="i3"
  export SESSION="i3"
  export XDG_SESSION_DESKTOP="i3"
  export XDG_CURRENT_DESKTOP="i3"

  # General use variables
  export EDITOR=micro
  export HOME=/home/wegeee
  export SPELL=/usr/bin/hunspell
  export SUDO_EDITOR=nano
  export TERMINAL=uxterm
  export VISUAL=micro

  # XDG base directory variables
  export XDG_CACHE_HOME=~/.cache
  export XDG_CONFIG_DIRS='/etc/xdg'
  export XDG_CONFIG_HOME=~/.config
  export XDG_DATA_DIRS='/usr/local/share/:/usr/share/'
  export XDG_DATA_HOME=~/.local/share

  # Disable accessibility technology
  export NO_AT_BRIDGE=1

  # Force vdpau driver selection (more info: grep -i vdpau <Xorg.log>)
  export VDPAU_DRIVER=va_gl
  # Override the automatic VAAPI driver selection for Intel GPU (more info: sudo vainfo)
  export LIBVA_DRIVER_NAME=i965

  # Specific softwares variables
  export EXIFTOOL_HOME=~/.config/exiftool
  export DIFF_ONLY_INSTALLED=true
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
  export GNUPGHOME=~/.config/gnupg
  export GREP_COLORS="sl=:cx=:mt=07:35:ms=01;31:mc=01;33:fn=35:ln=32:bn=32:se=36"
  export NODE_PENDING_DEPRECATION=1
  export SM_SAVE_DIR=~/.xsm
  export SONAR_SCANNER_OPTS="-server"
  export TASKDATA=~/.local/share/task
  export TASKRC=~/.config/task/taskrc
  export TRANSMISSION_HOME=~/.config/transmission
  export WEECHAT_HOME=~/.config/weechat
  export WWW_HOME=~/.config/w3m
  export NNN_COLORS='2346'
  #export NNN_MCLICK='^R'
  export NNN_OPTS="HU"
  export NNN_TRASH=1

  export GOPATH=~/.go
  export PATH=$(go env GOPATH)/bin:~/.cargo/bin:~/bin:~/.local/bin:$PATH
  #export PATH=${DOTNET_ROOT}:~/.dotnet/tools:$(go env GOPATH)/bin:~/.cargo/bin:~/.android/platform-tools:~/bin:~/.local/bin:$PATH

  # Start X server
  [[ -t 0 && !$DISPLAY ]] && exec startx

else
  exit 1
fi
