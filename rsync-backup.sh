#!/bin/sh

# Back up files to external hard drive using rsync.
sudo mkdir /run/mount/linux-backup/
sudo mount /dev/sdb2 /run/mount/linux-backup/
sudo mkdir /run/mount/linux-backup/deleted/
sudo rsync -a /home/corey/ /run/mount/linux-backup/ --info=progress2 --partial --delete --backup --backup-dir=/run/mount/linux-backup/deleted/
