#!/bin/sh
CURRENTDIR=${PWD}
echo "Directory ? ($CURRENTDIR by default)"
read REPONAME
REPONAME=${REPONAME:-${CURRENTDIR}}

mkdir -p $REPONAME/portage
mkdir -p $REPONAME/portage/package.use
mkdir -p $REPONAME/portage/repos.conf
mkdir -p $REPONAME/X11
mkdir -p $REPONAME/home
mkdir -p $REPONAME/home/ssh
mkdir -p $REPONAME/home/gnupg
mkdir -p $REPONAME/ttytheme
mkdir -p $REPONAME/etc
mkdir -p $REPONAME/vivaldi
mkdir -p $REPONAME/androidstudio
mkdir -p $REPONAME/phpstorm
mkdir -p $REPONAME/atom
mkdir -p $REPONAME/vscode

cp ~/docs/install_gentoo $REPONAME/home
cp ~/.local/share/applications/mimeapps.list $REPONAME/home

cp ~/.ssh/* $REPONAME/home/ssh

cp ~/.config/gnupg/* $REPONAME/home/gnupg

cp -ur ~/.AndroidStudio3.1/config/* $REPONAME/androidstudio
cp -ur ~/.PhpStorm2018.2/config/* $REPONAME/phpstorm
cp -ur ~/.config/vivaldi/Default/* $REPONAME/vivaldi
cp -ur ~/.atom/config.cson $REPONAME/atom
cp -ur ~/.config/Code/User/settings.json $REPONAME/vscode

cp /etc/portage/package.use/* $REPONAME/portage/package.use/
cp /etc/portage/package.accept_keywords $REPONAME/portage
cp /etc/portage/package.license $REPONAME/portage
cp /etc/portage/rsync_excludes $REPONAME/portage
cp /etc/portage/make.conf $REPONAME/portage
cp /var/lib/portage/world $REPONAME/portage
cp /etc/portage/repos.conf/*.conf $REPONAME/portage/repos.conf/

cp /etc/tty_theme $REPONAME/ttytheme
cp -r /etc/splash/kute $REPONAME/ttytheme
cp /etc/init.d/splash $REPONAME/ttytheme

cp /etc/X11/xorg.conf.d/* $REPONAME/X11
cp /etc/X11/xinit/xinitrc $REPONAME/X11

cp /etc/fstab $REPONAME/etc
cp /etc/sudoers $REPONAME/etc
cp /etc/timezone $REPONAME/etc
cp /etc/rc.conf $REPONAME/etc
cp /etc/passwd $REPONAME/etc
cp /etc/profile $REPONAME/etc
cp /etc/mpd.conf $REPONAME/etc
cp /etc/logrotate.conf $REPONAME/etc
cp /etc/group $REPONAME/etc
cp /etc/dhcpcd.conf $REPONAME/etc
cp /etc/wpa_supplicant/wpa_supplicant.conf $REPONAME/etc
cp /etc/dbus-1/system.d/bluetooth.conf $REPONAME/etc
cp /etc/bluetooth/main.conf $REPONAME/etc