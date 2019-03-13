#
#  ____    _    ____  _   _ ____   ____
# | __ )  / \  / ___|| | | |  _ \ / ___|
# |  _ \ / _ \ \___ \| |_| | |_) | |
# | |_) / ___ \ ___) |  _  |  _ <| |___
# |____/_/   \_\____/|_| |_|_| \_\\____|
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

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
shopt -s histappend histreedit histverify
shopt -s no_empty_cmd_completion
shopt -s sourcepath

# No incoming mail
shopt -u mailwarn
unset MAILCHECK

# Don't put duplicate lines in the history or spaces, add timestamps
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=100000
HISTFILESIZE=200000
HISTTIMEFORMAT="%F %T "

# Import colorscheme from 'wal' asynchronously
# & Run the process in the background
# ( ) Hide shell job control messages
(cat ~/.cache/wal/sequences &)

# Export $DBUS_SESSION_BUS_ADDRESS
export $(dbus-launch)

# Colors for the prompt
RED='\[\e[0;31m\]'
GREEN='\[\033[38;5;2m\]'
YELLOW='\[\033[38;5;226m\]'
#Remove effects
DF='\[$(tput sgr0)\]'
#Bold text
BOLD='\[$(tput bold)\]'

# Git prompt
GIT_PROMPT_START="${YELLOW}\w${DF}"
GIT_PROMPT_END="\$ "
GIT_PROMPT_IGNORE_SUBMODULES=1
GIT_PROMPT_THEME=Solarized
GIT_PS1_SHOWDIRTYSTATE=yes
source ~/app/bash-git-prompt/gitprompt.sh

# Env variables
export VISUAL=vim
export TERMINAL=uxterm
export TZ=Europe/Paris
export CDPATH=:..:~
export SASS_LIBSASS_PATH=/usr/local/lib/libsass
export SASS_SASSC_PATH=/usr/local/lib/sassc
export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=~/.config
export TASKRC=~/.config/task/.taskrc
export TASKDATA=~/.local/share/task
export TRANSMISSION_HOME=~/.config/transmission
export WWW_HOME=~/.config/w3m
export GNUPGHOME=~/.config/gnupg
export WEECHAT_HOME=~/.config/weechat
export GOPATH=~/.go
export EXIFTOOL_HOME=~/.config/exiftool
export EIX_LIMIT=0
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_ROOT=~/.sdk/dotnet-core-sdk
export MSBuildSDKsPath=$DOTNET_ROOT/sdk/
PATH=${DOTNET_ROOT}:$(go env GOPATH)/bin:~/bin:~/.local/bin:$PATH
HOME=/home/wegeee
EDITOR=nano

# Change ls colors
eval $(dircolors ~/.dircolors)

# Source Nerd Font icons
source ~/.local/share/fonts/i_all.sh

# Source aliases
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# Source functions
if [ -f ~/.bash_functions ]; then
. ~/.bash_functions
fi
