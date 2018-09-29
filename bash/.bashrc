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

#PUT YOUR FUN STUFF HERE
TMP="${BOLD}\[\033[38;5;2m\]\u${DF}${DF}\[\033[38;5;15m\]@${DF}\[\033[38;5;226m\]\w${DF}\[\033[38;5;15m\] ${DF}${SC}${DF}"

#Used for the prompt.
RED='\[\e[0;31m\]'
#GREEN='\[\e[0;32m\]'
GREEN='\[\033[38;5;2m\]'
YELLOW='\[\033[38;5;226m\]'

#Remove effects
DF='\[$(tput sgr0)\]'
BOLD='\[$(tput bold)\]'

function custom_prompt {
#check return value
if [ "$?" -eq "0" ]
then
#all ok
PR="${GREEN}"
else
#error/other than 0 returned
PR="${RED}"
fi
PS1="${PR}${BOLD}[\u]${DF}${YELLOW}\w${DF}\$${DF}"
}

## Print nickname for git version control in CWD
## Optional $1 of format string for printf, default "(%s) "
function get_branch_git {
  local dir="$PWD"
  local vcs
  local nick
  while [[ "$dir" != "/" ]]; do
    for vcs in git hg svn bzr; do
      if [[ -d "$dir/.$vcs" ]] && hash "$vcs" &>/dev/null; then
        case "$vcs" in
          git) __git_ps1 "${1:-(%s) }"; return;;
        esac
        [[ -n "$nick" ]] && printf "${1:-(%s) }" "$nick"
        return 0
      fi
    done
    dir="$(dirname "$dir")"
  done
}

# Faster (1ms vs 5ms) than /usr/bin/dirname
function dirname() {
  local dir="${1%${1##*/}}"
  "${dir:=./}" != "/" && dir="${dir%?}"
  echo "$dir"
}

#env variables
GIT_PS1_SHOWDIRTYSTATE=yes
PROMPT_COMMAND='custom_prompt'
PS1='\$(get_branch_git "$2")${PS1}'
PATH=~/bin:$PATH
HOME="/home/wegeee"
EDITOR="emacs"
SASS_LIBSASS_PATH=/usr/local/lib/libsass
SASS_SASSC_PATH=/usr/local/lib/sassc

#aliases
alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias ..='cd ..'
alias a='rm *~ ; rm #*#'
alias r='grep -r'
alias rm='rm -Ir'
alias ne='emacs'
alias lock='~/bin/myi3lock-clock'
alias p='ping www.gentoo.org'
alias playlist-yt='mpv --no-video --shuffle'
alias diapo='feh -Z --cycle-once -F *.*g'

# sudo
alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias esearch='sudo emerge --search'
alias emerge='sudo emerge --ask'
alias erm='sudo emerge --ask -cav'
alias connect_android='sudo mtpfs ~/media/android'
alias disconnect_android='sudo fusermount -u ~/media/android'
alias toshiba='sudo mount ~/media/toshiba500gb; cd ~/media/toshiba500gb; ll'
alias maxtor='sudo mount ~/media/maxtor4tb; cd ~/media/maxtor4tb; ll'
alias umount='sudo umount'

# network stuff 
alias eth-up="sudo /etc/init.d/net.enp0s25 start" 
alias eth-down="sudo /etc/init.d/net.enp0s25 stop" 
alias wpa-up="sudo ifconfig wlo1 up"
alias wpa-down="sudo ifconfig wlo1 down"
