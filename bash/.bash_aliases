# Alias
alias ls='ls -h --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias ll='ls -l'
alias lr='ls -lR'
alias lra='ls -lRA'
alias la='ls -lA'
alias lv='ls -lv'
alias h='history'
alias histclean='history -cw; rm ~/.lesshst ~/.*_history ~/.viminfo ~/.nano ./#*#'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias rm='rm -Ir'
alias mkdir='mkdir -v'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias lsblk='lsblk -lfmp'
alias r='grep -r'
alias q='myquotes.sh'
alias p='ping www.gentoo.org'
alias x='xrandr --output DP2 --auto --left-of eDP1'
alias playlist-yt-audio='mpv --no-video --shuffle --load-unsafe-playlists'
alias diapo='feh -Z --cycle-once -F *.*g'
alias s='scrot -s -q 80 ~/pics/screenshots/$(whoami)_%Y-%m-%d_%H-%M-%S.png -z'
alias neofetch='neofetch --config ~/.config/neofetch/neofetch.conf'
alias matrix='cmatrix -b -u 5 -C blue'
alias irssi='irssi --config=~/.config/irssi/config --home=~/.config/irssi -n wegeee'
alias mupdf='mupdf -r 50'
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/ncmpcpp.conf'
alias gifwal='xwinwrap -g 1920x1080 -ov -- mpv --no-terminal --loop-file=inf --no-stop-screensaver --no-osc -wid WID ~/pics/wallpapers/gif/bathroom.gif &'
alias connect_android='simple-mtpfs ~/media/android'
alias disconnect_android='fusermount -u ~/media/android'
alias timer='echo "Timer started. Stop with Ctrl-D." && date "+%a, %d %b %H:%M:%S" && time cat && date "+%a, %d %b %H:%M:%S"'
alias weather='curl -s "https://wttr.in/Nantes?2" | sed -n "1,27p"'
alias tor='nohup torbrowser >/dev/null 2>&1 &'

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
alias lamp='sudo rc-service apache2 start && sudo rc-service mysql start && cd /var/www/localhost/htdocs/'
alias klamp='sudo rc-service apache2 stop && sudo rc-service mysql stop'

# Bookmarks
alias dl='cd ~/downloads && ls -la'
alias doc='cd ~/docs && ls -la'
alias pic='cd ~/pics && ls -la'

# Developer shortcuts
alias art='php artisan'
alias mql='mysql -u root -p -h localhost'
alias pserv='myphptestserver.sh'
alias pp='mydirtypush.sh'
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