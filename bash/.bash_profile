# /etc/skel/.bash_profile
# This file is sourced by bash for login shells.

if shopt -q login_shell; then

  #export TERMINAL=uxterm
  #export EDITOR=micro
  #export TZ=Europe/Paris
  export HOME=/home/wegeee
  export XDG_DATA_HOME=~/.local/share
  export XDG_CONFIG_HOME=~/.config
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
  export PATH=${SONAR_SCANNER_HOME}/bin:${DOTNET_ROOT}:$(go env GOPATH)/bin:~/.cargo/bin:bin:~/bin:~/.local/bin:$PATH

  # Source .bashrc
  [[ -f ~/.bashrc ]] && source ~/.bashrc
  # Start X server
  [[ -t 0 && !$DISPLAY ]] && exec startx
else
  exit 1
fi