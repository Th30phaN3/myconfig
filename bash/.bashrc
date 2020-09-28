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

# Use colors defined in ~/.Xresources in virtual console (tty)
if [ "$TERM" = "linux" ]; then
  SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
  for i in $(sed -n "$SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
    echo -en "$i"
  done
  clear
fi

# No coredumps
ulimit -S -c 0
set -o ignoreeof
set -o noclobber
set -o notify

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

# Prompt
if [ -h ~/.local/bin/gitprompt.sh ]; then
  . ~/.local/bin/gitprompt.sh
fi
NOCOLOR="\[\e[m\]"
BOLD="\[\e[1m\]"
NOBOLD="\[\e[0m\]"
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
PS1="${BOLD}${BRO}\w${NOBOLD}${PUR}\$(__git_ps1 ' [%s]')${BOLD}${RED}\$(njobs)${CYA}\$${NOCOLOR}${NOBOLD} "

# Source Git flow bash completion
if [ -f ~/app/git-flow-completion/git-flow-completion.sh ]; then
  . ~/app/git-flow-completion/git-flow-completion.sh
fi

# Env variables for Git prompt
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
