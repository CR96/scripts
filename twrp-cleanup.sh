#!/bin/sh

## Uncompress old TWRP data partition backups and discard unnecessary Android bloat.

# Uncompress each TAR archive
tar zxvf data.ext4.win???

# Remove the archives and their checksums
rm data.ext4.???
rm data.ext4.???.md5

# Find SMS/MMS databases and copy them to a safe place
mkdir sms/
find data/ -name "*mmssms*" -exec cp {} sms/

cd data/

# Remove all cache files from the backup
rm -rf `find -type d -name cache`

# Remove application binaries, this folder contains no user data
rm -rf app/

# List 10 largest application data folders for manual review and deletion
du -a data/ | sort -n -r | head -n 10
