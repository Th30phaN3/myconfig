#!/bin/bash
#
# Update /etc/hosts with up-to-date hosts files

# Ugly trick to run as root (requires sudo rights)
SUDO=''
if (( EUID != 0 )); then
    SUDO='sudo'
fi

# SOURCES
# https://github.com/StevenBlack/hosts
BLACK_FGPS="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts"
# https://github.com/vokins/yhosts
VOKINS="https://raw.githubusercontent.com/vokins/yhosts/master/hosts"
# https://github.com/mitchellkrogza/Ultimate.Hosts.Blacklist
ULTIMATE="https://hosts.ubuntu101.co.za/hosts"
# https://github.com/EnergizedProtection/block
ENERGIZED_UNIFIED="https://raw.githubusercontent.com/EnergizedProtection/block/master/unified/formats/hosts"
ENERGIZED_EXTREME="https://raw.githubusercontent.com/EnergizedProtection/block/master/extensions/xtreme/formats/hosts"
ENERGIZED_REGIONAL="https://raw.githubusercontent.com/EnergizedProtection/block/master/extensions/regional/formats/hosts"
# https://blocklist.site/app/
ADS="https://blocklist.site/app/dl/ads"
CRYPT="https://blocklist.site/app/dl/crypto"
DRUG="https://blocklist.site/app/dl/drugs"
FRAUD="https://blocklist.site/app/dl/fraud"
GAMBLING="https://blocklist.site/app/dl/gambling"
PHISH="https://blocklist.site/app/dl/phishing"
MALWARE="https://blocklist.site/app/dl/malware"
PORN="https://blocklist.site/app/dl/porn"
RANSOM="https://blocklist.site/app/dl/ransomware"
SCAM="https://blocklist.site/app/dl/scam"
SPAM="https://blocklist.site/app/dl/spam"
TRACK="https://blocklist.site/app/dl/tracking"

TMPRAW="$HOME"/tmp/hosts.raw
TMPRAWW="$HOME"/tmp/hosts.raww
TMPSORT="$HOME"/tmp/hosts.sorted
FINALFILE="$HOME"/tmp/hosts

SECONDS=0

# Get updated hosts files and append personal hosts file
wget -q -O "$TMPRAW" "$BLACK_FGPS" "$VOKINS" "$ULTIMATE" "$ENERGIZED_UNIFIED" "$ENERGIZED_EXTREME" "$ENERGIZED_REGIONAL"
cat "$HOME"/.hosts >> "$TMPRAW"

# Get other updated hosts files
wget -q -O "$TMPRAWW" "$ADS" "$CRYPT" "$DRUG" "$FRAUD" "$GAMBLING" "$PHISH" "$MALWARE" "$PORN" "$RANSOM" "$SCAM" "$SPAM" "$TRACK"
sed -i 's/^/0\.0\.0\.0 /' "$TMPRAWW"
sed -i '/^0\.0\.0\.0\ $/d' "$TMPRAWW"

# Strip every lines not starting with 0.0.0.0 or 127.0.0.1
# Then transform 127.0.0.1 into 0.0.0.0
sed -i '/^\(0.0\|127.0\)/!d' "$TMPRAW"
sed -i '/^0\.0\.0\.0\ local$/d; /^0\.0\.0\.0\ localhost$/d; /^0\.0\.0\.0\ localhost\.localdomain$/d' "$TMPRAW"
sed -i 's/^127\.0\.0\.1 \(.*\)/0\.0\.0\.0 \1/g' "$TMPRAW"

cat "$TMPRAWW" >> "$TMPRAW"

# Strip comment lines and multiples spaces
sed -i '/^0\.0\.0\.0\ \#/d; /^0\.0\.0\.0\ 127\.0\.0\.1/d' "$TMPRAW"
sed -i 's/[[:space:]]\+/\ /g' "$TMPRAW"

# Sort according to general numerical value
sort -g -o "$TMPSORT" "$TMPRAW"

# Remove all similar lines
awk '!seen[$0]++' "$TMPSORT" > "$FINALFILE"

# Allows some domains
WHITELIST="$HOME/.whitelist"
while IFS= read -r line
do
sed -i "/0.0.0.0 $line/d" "$FINALFILE"
done < "$WHITELIST"

DURATION="$SECONDS"
UPDATETIME=$(date +%c)
HEADER="#Hosts file updated on $UPDATETIME\n#This file was created in $((DURATION / 60)) minutes and $((DURATION % 60)) seconds.\n127.0.0.1 local\n127.0.0.1 localhost\n127.0.0.1 localhost.localdomain\n255.255.255.255 broadcasthost\n::1 localhost\n::1 ip6-localhost\n::1 ip6-loopback\nfe80::1%lo0 localhost\nff00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters\nff02::3 ip6-allhosts\n0.0.0.0 0.0.0.0\n"
sed -i "1s/^/$HEADER/" "$FINALFILE"

# Remove old hosts file and move new to /etc
$SUDO rm /etc/hosts
$SUDO mv "$FINALFILE" /etc/
rm "$TMPRAW"
rm "$TMPRAWW"
rm "$TMPSORT"