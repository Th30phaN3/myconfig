# /etc/skel/.bash_profile
# This file is sourced by bash for login shells.

if shopt -q login_shell; then

  export TERMINAL=uxterm
  export EDITOR=micro
  export TZ=Europe/Paris
  export SASS_LIBSASS_PATH=/usr/local/lib/libsass
  export SASS_SASSC_PATH=/usr/local/lib/sassc
  export XDG_DATA_HOME=~/.local/share
  export XDG_CONFIG_HOME=~/.config
  export TASKRC=~/.config/task/taskrc
  export TASKDATA=~/.local/share/task
  export TRANSMISSION_HOME=~/.config/transmission
  export WWW_HOME=~/.config/w3m
  export GRADLE_HOME=/usr/bin/gradle-5.2.1
  export GNUPGHOME=~/.config/gnupg
  export WEECHAT_HOME=~/.config/weechat
  export GOPATH=~/.go
  export EXIFTOOL_HOME=~/.config/exiftool
  export EIX_LIMIT=0
  export DOTNET_ROOT=/opt/dotnet_core
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
  export MSBuildSDKsPath=$DOTNET_ROOT/sdk/2.2.105/Sdks
  export PATH=${DOTNET_ROOT}:$(go env GOPATH)/bin:~/bin:~/.local/bin:$PATH
  export HOME=/home/wegeee

  [[ -f ~/.bashrc ]] && source ~/.bashrc
  # Start X server
  [[ -t 0 && !$DISPLAY ]] && exec startx
else
  exit 1
fi