#
#  ____    _    ____  _   _ ____   ____
# | __ )  / \  / ___|| | | |  _ \ / ___|
# |  _ \ / _ \ \___ \| |_| | |_) | |
# | |_) / ___ \ ___) |  _  |  _ <| |___
# |____/_/   \_\____/|_| |_|_| \_\\____|
#
# This file is sourced by all *interactive* bash shells on startup.

# Exit if not an interactive shell
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
HISTFILESIZE=500000
HISTTIMEFORMAT="%F %T "

# Ensure every command is saved in history across multiple shells (slightly reduces performance)
PROMPT_COMMAND="history -a"

# Import colorscheme from 'wal' asynchronously
# & Run the process in the background
# ( ) Hide shell job control messages
(cat ~/.cache/wal/sequences &)

# Change ls colors
eval $(dircolors ~/.dircolors)

# Source Git flow bash completion
if [ -f ~/app/git-flow-completion/git-flow-completion.sh ]; then
  . ~/app/git-flow-completion/git-flow-completion.sh
fi

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

export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Trap DEBUG to run a custom function right before a command runs
# IMPORTANT: trap DEBUG *before* running Starship !
# trap <function> DEBUG

eval "$(starship init bash)"
starship_precmd_user_func="set_term_title"
