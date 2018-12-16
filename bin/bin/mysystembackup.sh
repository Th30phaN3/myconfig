#!/bin/sh
TARFILE=$HOME/backup/backup-$(date +%F).tar.xz
sudo tar --exclude-from=$HOME/backup/exclude -cJpvf $TARFILE /