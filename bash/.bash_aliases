#
#    _    _     ___    _    ____
#   / \  | |   |_ _|  / \  / ___|
#  / _ \ | |    | |  / _ \ \___ \
# / ___ \| |___ | | / ___ \ ___) |
#/_/   \_\_____|___/_/   \_\____/
#

alias grep='grep --color=auto'
alias gr='grep -ir '
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias ls='ls -h --color=auto --group-directories-first'
alias ll='ls -ogv'		    # Long format, order by numbers
alias la='ls -ogvA'		    # Show hidden files
alias lr='ls -ogvR'		    # Recursive
alias lra='ls -ogvRA'		# Recursive, show hidden files
alias lx='ls -ogXB'		    # Sort by extension
alias lk='ls -ogSr'		    # Sort by size, biggest last
alias lt='ls -ogtr'      	# Sort by date, most recent last
alias lc='ls -ogtcr'     	# Sort by change time,most recent last
alias lu='ls -ogtur'		# Sort by access time,most recent last
alias fn='ls . | wc -l'
alias hs='history'
alias hg="history | sed -r '/[0-9]+ hg/d' | grep" # Search a term in terminal history
alias perm='stat -c "%A %a %n" *'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias rm='echo "Use trash-put (alias tp)."; false'
alias tp='trash-put'
alias bc='bc -lq'
alias more='less'
alias ed='editassudo '
alias mkdir='mkdir -pv'
alias ..='cd ..'
alias ...='cd ../..'
alias df='df -Tha --total'
alias du='du -ach | sort -h'
alias lsblk='lsblk -po NAME,FSTYPE,SIZE,FSAVAIL,FSUSE%,MODE,LABEL,MOUNTPOINT,HOTPLUG,STATE'
alias jo='jobs -l'
alias fr='find -L -readable -regextype posix-extended -regex'
alias qt='quotes.sh'
alias gpalldirs='find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && git pull" \;'
alias update_media_vivaldi='sudo /opt/vivaldi/update-widevine --system && sudo /opt/vivaldi/update-ffmpeg'
alias medinfo='exiftool -s -FileName -Directory -ImageSize -FileSize -MIMEType -Duration -XResolution -YResolution -VideoFrameRate -BitDepth -AudioFormat -AudioChannels -AudioBitsPerSample -AudioSampleRate -Encoder -AvgBitrate -Artist -Title -Album -Genre'
alias stripinfo='exiftool -ProjectRefType= -WindowsAtomUncProjectPath= -IngredientsFilePath= -IngredientsMaskMarkers= -IngredientsInstanceID= -IngredientsDocumentID= -IngredientsFromPart= -HistorySoftwareAgent= -HistoryChanged= -HistoryWhen= -Format= -CreatorTool= -XMPToolkit= -Title= -Comment= -Software= -HDVideo= -TVEpisode= -TVSeason= -TrackNumber='
alias dh='date --help | sed -n "/^ *%%/,/^ *%Z/p" | while read l;do F=${l/% */}; date +%$F:"|'"'"'${F//%n/ }'"'"'|${l#* }";done | sed "s/\ *|\ */|/g" | column -s "|" -t'
alias xx='xrandr > /dev/null 2>&1; xrandr --output DP2 --left-of eDP1'	        # Add second screen
alias diapo='feh -q -p -Y -Z --on-last-slide quit --auto-rotate -F -r'		    # Show a slideshow of all images in directory and sub-directories
alias sc='scrot -s -q 80 ~/pics/screenshots/$(whoami)_%Y-%m-%d_%H:%M:%S.png -z'	# Capture part of the screen
alias matrix='cmatrix -b -u 5 -C blue'					                        # Enter the matrix
alias mupdf='mupdf -r 75'
alias post='curl --request POST -H "Content-Type: application/json" --data '    # Post JSON. Use "@dt" to pass data in file named "dt"
alias wal='wal -q -t -n -o /home/wegeee/.config/wal/done.sh -f '
alias timer='echo "Timer started. Stop with Ctrl-D." && date "+%a, %d %b %H:%M:%S" && time cat && date "+%a, %d %b %H:%M:%S"'
alias weather='curl -s "https://wttr.in/Nantes?2" | sed -n "1,27p"'		# Display weather (large terminal width recommended)
alias path='echo -e ${PATH//:/\\n}'						# Print binaries path
alias unigrep='grep -P "[^\x00-\x7F]"'					# Grep special unicode characters
alias bcolor='for code in {0..15}; do echo -e "\e[38;05;${code}m $code: Color"; done'

# Kernel / Packages manipulation
alias kernel_rebuild='sudo make -j5 && sudo make modules_install && sudo mount /boot/efi/ && sudo make install && sudo grub-mkconfig -o /boot/efi/grub/grub.cfg'
alias ehelp='apropos -e portage layman qcheck eselect equery euse emaint genlop'
alias esync='sudo eix-sync'
alias elogs='tail -f /var/log/emerge-fetch.log' # Show fetch logs when emerging
alias emerge='sudo emerge'						# Install/upgrade packages
alias erm='emerge --depclean --verbose'			# Delete packages (select all not used without arguments)
alias esearch='eix -R'                          # Search for package in main portage tree + all public overlays
# System upgrade (ignore use flags changes)
alias epgrade_quick='emerge --update --tree --unordered-display --keep-going --verbose-conflicts @world'
# System upgrade (full use flags rebuild)
alias epgrade='emerge -ut --unordered-display --keep-going --verbose-conflicts --with-bdeps=y --newuse --deep @world'
# System upgrade (used when upgrading Perl)
alias epgrade_perl='emerge -utND --unordered-display --verbose-conflicts --with-bdeps=y --backtrack=100 --autounmask-keep-masks @world'
alias eclean='erm && sudo eclean-dist -d -t1m -s40M'    # Remove unnecessary packages/dependencies & ebuilds files too big
alias econf_up='sudo find /etc -name "._cfg????_*"'		# Check for new config files
alias esecure='glsa-check -lv'							# Check packages vulnerabilities
alias uppack='eix -u -x --nonvirtual --deps-installed --world-file --compact'   #Show available updates for packages

# Peripherics
alias toshiba='sudo mount ~/media/toshiba; cd ~/media/toshiba; ll'
alias maxtor='sudo mount ~/media/maxtor; cd ~/media/maxtor; ll'
alias seagate='sudo mount ~/media/seagate; cd ~/media/seagate; ll'
alias co_android='simple-mtpfs ~/media/android'
alias disco_android='fusermount -u ~/media/android'

# Bookmarks
alias dl='cd ~/downloads && ll'
alias dc='cd ~/docs && ll'
alias pc='cd ~/pics && ll'
alias mu='cd ~/music && ls -R'
alias conf='cd ~/myconfig && ll'
alias pr='cd ~/projs && ll'

# Development
alias art='php artisan'
alias mql='mysql -u root -p -h localhost'
alias pp='git add --all && git commit -m "$(w3m whatthecommit.com | head -n 1)" && git push' # Dirty push
alias dks='docker stop $(docker ps -aq)'        # Stop all containers
alias dkc='docker system prune -a'				# Remove all containers
alias lamp='sudo rc-service apache2 start && sudo rc-service mysql start'
alias klamp='sudo rc-service apache2 stop && sudo rc-service mysql stop'
alias debug='set -o nounset; set -o xtrace' # These two options are useful for debugging
alias nuget='mono /usr/local/bin/nuget.exe'

# Network
alias eth-up="sudo /etc/init.d/net.enp0s25 start"
alias eth-down="sudo /etc/init.d/net.enp0s25 stop"
alias wpa-up="sudo ifconfig wlo1 up"
alias wpa-down="sudo ifconfig wlo1 down"
alias websiteget='wget --random-wait -r -p -e robots=off -U mozilla' # Download entire website (take URL as parameter)
alias listen='lsof -P -i -n' # Show all processes listening on networks
alias pg='ping -c 5 www.gentoo.org'

# Braindead
alias quit='exit'
alias help='man'
alias ytdl='youtube-dl'
alias text2ascii='figlet'
alias wifi='wpa_cli'
alias loonix='man hier'
alias coof='curl https://corona-stats.online/FR'
alias snoop='less /var/log/auth.log'
