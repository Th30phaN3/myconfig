#
#    _    _     ___    _    ____
#   / \  | |   |_ _|  / \  / ___|
#  / _ \ | |    | |  / _ \ \___ \
# / ___ \| |___ | | / ___ \ ___) |
#/_/   \_\_____|___/_/   \_\____/
#

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ls='ls -h --color=auto --group-directories-first'
alias l='ls'			# Typo
alias ll='ls -hogv'		# Long format, order by numbers
alias la='ls -hogvA'		# Show hidden files
alias lr='ls -hogvR'		# Recursive
alias lra='ls -hogvRA'		# Recursive, show hidden files
alias lx='ls -hogXB'		# Sort by extension
alias lk='ls -hogSr'		# Sort by size, biggest last
alias lt='ls -hogtr'      	# Sort by date, most recent last
alias lc='ls -hogtcr'     	# Sort by/show change time,most recent last
alias lu='ls -hogtur'		# Sort by/show access time,most recent last
alias lsl='ls -hogFA | less'	# Output to less
alias h='history'
alias hg='history | grep'
alias clean_home='history -cw; rm ~/.lesshst ~/.*_history ~/.viminfo ~/.nano/filepos_history ~/.wget-hsts ~/.weatherreport'
alias empdir='find . -type d -empty -delete'
alias perm='stat -c "%A %a %n" *'
alias quit='exit'
alias help='man'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias rm='safe_rm'
alias bc='bc -lq'
alias more='less'
alias nano='editassudo'
alias mkdir='mkdir -pv'
alias ..='cd ..'
alias ...='cd ../..'
alias df='df -Tha --total'
alias du='du -ach | sort -h'
alias lsblk='lsblk -lfmp'
alias r='grep -r'
alias j='jobs -l'
alias f='find -L -regextype posix-extended -regex'
alias q='myquotes.sh'
alias now='date +"%d/%m/%Y:%T"'
alias dh='date --help | sed -n "/^ *%%/,/^ *%Z/p" | while read l;do F=${l/% */}; date +%$F:"|'"'"'${F//%n/ }'"'"'|${l#* }";done | sed "s/\ *|\ */|/g" | column -s "|" -t'
alias x='xrandr --output DP2 --mode "1920x1080" --left-of eDP1'
alias ytdl='youtube-dl'
alias diapo='feh -Z --cycle-once -F *.*g'
alias s='scrot -s -q 80 ~/pics/screenshots/$(whoami)_%Y-%m-%d_%H:%M:%S.png -z'
alias neo='neofetch --config ~/.config/neofetch/neofetch.conf'
alias matrix='cmatrix -b -u 5 -C blue' # Enter the matrix
alias bootusb='echo "sudo dd if=chemin/iso of=/chemin/usb"'
alias mupdf='mupdf -r 75'
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/ncmpcpp.conf'
alias co_android='simple-mtpfs ~/media/android'
alias disco_android='fusermount -u ~/media/android'
alias timer='echo "Timer started. Stop with Ctrl-D." && date "+%a, %d %b %H:%M:%S" && time cat && date "+%a, %d %b %H:%M:%S"'
alias weather='curl -s "https://wttr.in/Nantes?2" | sed -n "1,27p"'
alias text2ascii='figlet'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias busy='cat /dev/urandom | hexdump -C | grep "ca fe"' # I'm busy, mom !
alias unigrep='grep -P "[^\x00-\x7F]"' # Grep special unicode characters

# Sudo
alias kernel_rebuild='sudo make -j5 && sudo make modules_install && sudo mount /boot/efi/ && sudo make install && sudo grub-mkconfig -o /boot/efi/grub/grub.cfg'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias esearch='sudo emerge --search' # Search for packages
alias emerge='sudo emerge --ask' # Install packages
alias erm='sudo emerge --ask -cav' # Delete packages
alias toshiba='sudo mount ~/media/toshiba500gb; cd ~/media/toshiba500gb; ll'
alias maxtor='sudo mount ~/media/maxtor4tb; cd ~/media/maxtor4tb; ll'
alias umount='sudo umount'

# Bookmarks
alias dl='cd ~/downloads && ll'
alias dc='cd ~/docs && ll'
alias pc='cd ~/pics && ll'

# Developer shortcuts
alias art='php artisan'
alias mql='mysql -u root -p -h localhost'
alias pp='git add --all && git commit -m "$(w3m whatthecommit.com | head -n 1)" && git push origin master' # Dirty push
alias dks='docker stop $(docker ps -aq)'
alias dkc='docker system prune -a'
alias lamp='sudo rc-service apache2 start && sudo rc-service mysql start'
alias klamp='sudo rc-service apache2 stop && sudo rc-service mysql stop'
alias debug='set -o nounset; set -o xtrace' # These two options are useful for debugging'

# Network
alias eth-up="sudo /etc/init.d/net.enp0s25 start"
alias eth-down="sudo /etc/init.d/net.enp0s25 stop"
alias wpa-up="sudo ifconfig wlo1 up"
alias wpa-down="sudo ifconfig wlo1 down"
alias websiteget='wget --random-wait -r -p -e robots=off -U mozilla' # Download entire website
alias listen='lsof -P -i -n' # Show all processes listening on networks
alias wifi='wpa_cli'
alias p='ping -c 5 www.gentoo.org'