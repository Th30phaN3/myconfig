#!/bin/sh
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi
HOST="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"
$SUDO wget -q -O $HOME/tmp/hosts $HOST
$SUDO rm /etc/hosts
$SUDO mv $HOME/tmp/hosts /etc/
$SUDO cat $HOME/.myhosts >> /etc/hosts