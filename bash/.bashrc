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
export TASKRC=~/.config/task/.taskrc
export XDG_CONFIG_HOME=~/.config

# Change ls colors
eval $(dircolors ~/.dircolors)

# Alias
alias ls='ls -h --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias ll='ls -l'
alias lr='ls -lR'
alias lra='ls -lRa'
alias la='ls -la'
alias lv='ls -lv'
alias fdir='find . -type d -name'
alias ff='find . -type f -name'
alias h='history'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias rm='rm -Ir'
alias mkdir='mkdir -v'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias a='rm *~ ; rm #*#'
alias r='grep -r'
alias lock='~/bin/myi3lock-clock'
alias q='~/bin/quote'
alias p='ping www.gentoo.org'
alias x='xrandr --output DP2 --auto --left-of eDP1'
alias playlist-yt='mpv --no-video --shuffle --load-unsafe-playlists'
alias diapo='feh -Z --cycle-once -F *.*g'
alias s='scrot -s -q 80 $(whoami)_%Y-%m-%d_%H-%M-%S.png -z'
alias nano='nano -Saikluw'
alias neofetch='neofetch --config ~/.config/neofetch/neofetch.conf'
alias pp='push_sale'
alias dk='docker rm -f $(docker ps -aq)'
alias manranger='echo -e "! = Execute a command from the shell (non-ranger commands)\n: = Execute a ranger command\ndu = Measure disk usage of current directory\nchmod = Change permissions of current file\n%f = Substitute highlighted file\n%d = Substitute current directory\n%s = Substitute currently selected files\n%t = Substitute currently tagged files"'
alias gifwal='xwinwrap -g 1920x1080 -ov -- mpv --no-terminal --loop-file=inf --no-stop-screensaver --no-osc -wid WID ~/pics/wallpapers/gif/bathroom.gif &'

# Sudo
alias kernel_rebuild='sudo make -j5 && sudo make modules_install && sudo mount /boot/efi/ && sudo make install && sudo grub-mkconfig -o /boot/efi/grub/grub.cfg'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias esearch='sudo emerge --search'
alias emerge='sudo emerge --ask'
alias erm='sudo emerge --ask -cav'
alias connect_android='simple-mtpfs ~/media/android'
alias disconnect_android='fusermount -u ~/media/android'
alias toshiba='sudo mount ~/media/toshiba500gb; cd ~/media/toshiba500gb; ll'
alias maxtor='sudo mount ~/media/maxtor4tb; cd ~/media/maxtor4tb; ll'
alias umount='sudo umount'
alias serv='sudo rc-service apache2 start && cd /var/www/localhost/htdocs/'

# Bookmarks
alias dl='cd ~/downloads && ls -la'
alias doc='cd ~/docs && ls -la'
alias pic='cd ~/pics && ls -la'

# Shortcuts
alias timer='echo "Timer started. Stop with Ctrl-D." && date "+%a, %d %b %H:%M:%S" && time cat && date "+%a, %d %b %H:%M:%S"'
alias weather='curl -s "https://wttr.in/Nantes?2" | sed -n "1,27p"'

# Developer shortcuts
alias g='git'
alias art='php artisan'

# Typos
alias quit='exit'
alias help='man'

# Network
alias eth-up="sudo /etc/init.d/net.enp0s25 start" 
alias eth-down="sudo /etc/init.d/net.enp0s25 stop" 
alias wpa-up="sudo ifconfig wlo1 up"
alias wpa-down="sudo ifconfig wlo1 down"
