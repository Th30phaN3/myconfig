# /etc/skel/.bash_profile
# This file is sourced by bash for login shells.
# Order of load: bash_profile > xinitrc > bashrc (on term load)

if shopt -q login_shell; then

  # Export desktop variables for i3
  export DESKTOP_SESSION="i3"
  export XDG_SESSION_DESKTOP="i3"
  export XDG_CURRENT_DESKTOP="i3"
  export SESSION="i3"
  export MDMSESSION="i3"
  export GDMSESSION="i3"

  export TERMINAL=uxterm
  export EDITOR=micro
  export HOME=/home/wegeee
  export XDG_DATA_HOME=~/.local/share
  export XDG_CONFIG_HOME=~/.config
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export TASKRC=~/.config/task/taskrc
  export TASKDATA=~/.local/share/task
  export TRANSMISSION_HOME=~/.config/transmission
  export WWW_HOME=~/.config/w3m
  export GNUPGHOME=~/.config/gnupg
  export WEECHAT_HOME=~/.config/weechat
  export GOPATH=~/.go
  export EXIFTOOL_HOME=~/.config/exiftool
  export DIFF_ONLY_INSTALLED=true
  export SONAR_SCANNER_VERSION=4.2.0.1873
  export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux
  export SONAR_SCANNER_OPTS="-server"
  export SPELL=/usr/bin/hunspell
  export PATH=${SONAR_SCANNER_HOME}/bin:${DOTNET_ROOT}:~/.dotnet/tools:$(go env GOPATH)/bin:~/.cargo/bin:~/bin:~/.local/bin:$PATH

  # Start X server
  [[ -t 0 && !$DISPLAY ]] && exec startx
else
  exit 1
fi