#!/bin/sh
#
# Update /etc/hosts with up-to-date hosts files

# Ugly trick to run as root (requires sudo rights)
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

# https://github.com/StevenBlack/hosts
HOSTBLACK="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts"
# https://github.com/vokins/yhosts
HOSTVOKINS="https://raw.githubusercontent.com/vokins/yhosts/master/hosts"
HOSTVOKINSTXT="https://raw.githubusercontent.com/vokins/yhosts/master/hosts.txt"
# https://github.com/mitchellkrogza/Ultimate.Hosts.Blacklist
HOSTULTIMATE="https://hosts.ubuntu101.co.za/hosts"

TMPRAW=$HOME/tmp/hosts.raw
TMPSORT=$HOME/tmp/hosts.sorted
FINALFILE=$HOME/tmp/hosts

# Get updated hosts files and append personal hosts file
wget -q -O $TMPRAW $HOSTVOKINS $HOSTVOKINSTXT $HOSTBLACK $HOSTULTIMATE
cat $HOME/.hosts >> $TMPRAW

# Strip every lines not starting with 0.0.0.0 (except necessary lines)
sed -i '/^\(0.0\|127.0\|255.255\|f\|::1 i|::1 l\)/!d' $TMPRAW
sed -i 's/^127\.0\.0\.1 \(.*\)/0\.0\.0\.0 \1/g' $TMPRAW
sed -i 's/^0\.0\.0\.0 \(local\)$/127\.0\.0\.1 \1/g' $TMPRAW
sed -i 's/^0\.0\.0\.0 \(localhost\)$/127\.0\.0\.1 \1/g' $TMPRAW
sed -i 's/^0\.0\.0\.0 \(localhost.localdomain\)$/127\.0\.0\.1 \1/g' $TMPRAW

# Sort according to general numerical value
sort -g -o $TMPSORT $TMPRAW

# Remove all similar lines
awk '!seen[$0]++' $TMPSORT > $FINALFILE

# Allows some domains
WHITELIST="$HOME/.whitelist"
while IFS= read -r line
do
sed -i "/0.0.0.0 $line/d" $FINALFILE
done < "$WHITELIST"

UPDATETIME=$(date +%c)
sed -i "1s/^/#Hosts file updated on $UPDATETIME\n/" $FINALFILE

# Remove old hosts file and move new to /etc
$SUDO rm /etc/hosts
$SUDO mv $FINALFILE /etc/
rm $TMPRAW
rm $TMPSORT