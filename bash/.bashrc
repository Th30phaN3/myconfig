#
#  ____    _    ____  _   _ ____   ____
# | __ )  / \  / ___|| | | |  _ \ / ___|
# |  _ \ / _ \ \___ \| |_| | |_) | |
# | |_) / ___ \ ___) |  _  |  _ <| |___
# |____/_/   \_\____/|_| |_|_| \_\\____|
#
# This file is sourced by all *interactive* bash shells on startup.

# Test for an interactive shell.
[[ $- != *i* ]] && return

# No coredumps
ulimit -S -c 0
set -o notify
set -o noclobber
set -o ignoreeof

# Enable options
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s histappend histreedit histverify
shopt -s no_empty_cmd_completion
shopt -s sourcepath

# No incoming mail
shopt -u mailwarn
unset MAILCHECK

# Don't put duplicate/empty lines in the history and add timestamps
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=10000
HISTFILESIZE=200000
HISTTIMEFORMAT="%F %T "

# Import colorscheme from 'wal' asynchronously
# & Run the process in the background
# ( ) Hide shell job control messages
(cat ~/.cache/wal/sequences &)

# Export $DBUS_SESSION_BUS_ADDRESS and DBUS_SESSION_BUS
export $(dbus-launch)

# Prompt
if [ -h ~/.local/bin/gitprompt.sh ]; then
  . ~/.local/bin/gitprompt.sh
fi
NOCOLOR="\[\e[m\]"
BOLD="\[\e[1m\]"
INVERSE="\[\e[7m\]"
BLA="\[\e[30m\]"
RED="\[\e[31m\]"
GRE="\[\e[32m\]"
BRO="\[\e[33m\]"
BLU="\[\e[34m\]"
PUR="\[\e[35m\]"
CYA="\[\e[36m\]"
GRA="\[\e[37m\]"
njobs() { n=$(jobs | wc -l) && [ "$n" -gt 0 ] && echo " $n"; }
PS1="${BOLD}${BRO}\w\$(__git_ps1 ' [%s]')${RED}\$(njobs)${NOCOLOR}\$ "

# Source Git flow bash completion
if [ -f ~/app/git-flow-completion/git-flow-completion.sh ]; then
  . ~/app/git-flow-completion/git-flow-completion.sh
fi

# Env variables (export allows use of variables in shell)
#export TERMINAL=uxterm
#TZ=Europe/Paris
##CDPATH=:..:~
#SASS_LIBSASS_PATH=/usr/local/lib/libsass
#SASS_SASSC_PATH=/usr/local/lib/sassc
#export XDG_DATA_HOME=~/.local/share
#export XDG_CONFIG_HOME=~/.config
#export TASKRC=~/.config/task/.taskrc
#export TASKDATA=~/.local/share/task
#export TRANSMISSION_HOME=~/.config/transmission
#export WWW_HOME=~/.config/w3m
#export GRADLE_HOME=/usr/bin/gradle-5.2.1
#export GNUPGHOME=~/.config/gnupg
#export WEECHAT_HOME=~/.config/weechat
#export GOPATH=~/.go
#export EXIFTOOL_HOME=~/.config/exiftool
#EIX_LIMIT=0
#DOTNET_ROOT=/opt/dotnet_core
#DOTNET_CLI_TELEMETRY_OPTOUT=1
#DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
#MSBuildSDKsPath=$DOTNET_ROOT/sdk/2.2.105/Sdks
#PATH=${DOTNET_ROOT}:$(go env GOPATH)/bin:~/bin:~/.local/bin:$PATH
#HOME=/home/wegeee
#EDITOR=nano
export SONAR_SCANNER_VERSION=4.2.0.1873
export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
export SONAR_SCANNER_OPTS="-server"
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM="auto verbose git"
GIT_PS1_STATESEPARATOR="|"

# Change ls colors
eval $(dircolors ~/.dircolors)

# Source Nerd Font icons
if [ -f ~/.local/share/fonts/i_all.sh ]; then
  . ~/.local/share/fonts/i_all.sh
fi

# Source aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Source functions
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi

# Update terminal title before every command using history (strip command number and dates)
trap 'echo -ne "\033]2;$(xcwd) -> $(history 1 | sed "s/^[ ]*[0-9]*[ ]*[0-9\-]*[ ]*[0-9:]*[ ]*//g")\007"' DEBUG
