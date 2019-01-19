# Alias
alias ls='ls -h --color=auto --group-directories-first'
alias l='ls'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ll='ls -l'
alias lr='ls -lR'
alias lra='ls -lRA'
alias la='ls -lA'
alias lv='ls -lv'
alias h='history'
alias qclean='history -cw; rm ~/.lesshst ~/.*_history ~/.viminfo ~/.nano/filepos_history ./#*#'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias rm='rm -Idv'
alias bc='bc -lq'
alias mkdir='mkdir -pv'
alias ..='cd ..'
alias ...='cd ../..'
alias df='df -Tha --total'
alias du='du -ach | sort -h'
alias lsblk='lsblk -lfmp'
alias r='grep -r'
alias j='jobs -l'
alias f='find -L'
alias q='myquotes.sh'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%d/%m/%Y:%T"'
alias p='ping -c 5 www.gentoo.org'
alias x='xrandr --output DP2 --auto --left-of eDP1'
alias ytdl='youtube-dl'
alias diapo='feh -Z --cycle-once -F *.*g'
alias s='scrot -s -q 80 ~/pics/screenshots/$(whoami)_%Y-%m-%d_%H:%M:%S.png -z'
alias neofetch='neofetch --config ~/.config/neofetch/neofetch.conf'
alias matrix='cmatrix -b -u 5 -C blue'
alias mupdf='mupdf -r 50'
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/ncmpcpp.conf'
alias connect_android='simple-mtpfs ~/media/android'
alias disconnect_android='fusermount -u ~/media/android'
alias timer='echo "Timer started. Stop with Ctrl-D." && date "+%a, %d %b %H:%M:%S" && time cat && date "+%a, %d %b %H:%M:%S"'
alias weather='curl -s "https://wttr.in/Nantes?2" | sed -n "1,27p"'
alias text2ascii='figlet'
alias wifi='wpa_cli'

# Sudo
alias kernel_rebuild='sudo make -j5 && sudo make modules_install && sudo mount /boot/efi/ && sudo make install && sudo grub-mkconfig -o /boot/efi/grub/grub.cfg'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias esearch='sudo emerge --search'
alias emerge='sudo emerge --ask'
alias erm='sudo emerge --ask -cav'
alias toshiba='sudo mount ~/media/toshiba500gb; cd ~/media/toshiba500gb; ll'
alias maxtor='sudo mount ~/media/maxtor4tb; cd ~/media/maxtor4tb; ll'
alias umount='sudo umount'
alias lamp='sudo rc-service apache2 start && sudo rc-service mysql start'
alias klamp='sudo rc-service apache2 stop && sudo rc-service mysql stop'

# Bookmarks
alias dl='cd ~/downloads && ls -l'
alias doc='cd ~/docs && ls -l'
alias pic='cd ~/pics && ls -l'

# Developer shortcuts
alias art='php artisan'
alias mql='mysql -u root -p -h localhost'
alias pserv='myphptestserver.sh'
alias pp='git add --all && git commit -m "$(w3m whatthecommit.com | head -n 1)" && git push origin master'
alias dks='docker stop $(docker ps -aq)'
alias dkc='docker system prune -a'
alias pstorm='nohup phpstorm2018.2 >/dev/null 2>&1 &'

# Typos
alias quit='exit'
alias help='man'

# Network
alias eth-up="sudo /etc/init.d/net.enp0s25 start"
alias eth-down="sudo /etc/init.d/net.enp0s25 stop"
alias wpa-up="sudo ifconfig wlo1 up"
alias wpa-down="sudo ifconfig wlo1 down"