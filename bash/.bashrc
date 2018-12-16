# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

#Used for the prompt.
RED='\[\e[0;31m\]'
GREEN='\[\033[38;5;2m\]'
YELLOW='\[\033[38;5;226m\]'
#Remove effects
DF='\[$(tput sgr0)\]'
BOLD='\[$(tput bold)\]'

# Git prompt
GIT_PROMPT_START="${YELLOW}\w${DF}"
GIT_PROMPT_END="\$ "
GIT_PROMPT_IGNORE_SUBMODULES=1
GIT_PROMPT_THEME=Solarized
GIT_PS1_SHOWDIRTYSTATE=yes
source ~/.bash-git-prompt/gitprompt.sh

# Env variables
PATH=~/bin:~/.local/bin:$PATH
HOME="/home/wegeee"
EDITOR="nano"
export SASS_LIBSASS_PATH=/usr/local/lib/libsass
export SASS_SASSC_PATH=/usr/local/lib/sassc
export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=~/.config
export TASKRC=~/.config/task/.taskrc
export TASKDATA=~/.config/task
export TRANSMISSION_HOME=~/.config/transmission
export WWW_HOME=~/.config/w3m
export GNUPGHOME=~/.config/gnupg

# Change ls colors
eval $(dircolors ~/.dircolors)

# Source aliases
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi