#!/bin/sh

## Uncompress old TWRP data partition backups and discard unnecessary Android bloat.

# Uncompress each TAR archive
find . -name '*.win???' -exec tar -xzvf '{}' \;

# Remove the archives and their checksums
rm data.ext4.win???
rm data.ext4.win???.md5

# Find SMS/MMS databases and copy them to a safe place
mkdir sms/
find data/ -name '*mmssms*' -exec cp '{}' sms/ \;

cd data/

# Remove all cache files from the backup
rm -rf `find -type d -name cache`

# Remove application binaries, this folder contains no user data
rm -rf app/

# List 10 largest application data folders for manual review and deletion
echo "Large application data folders"
echo "=============================="
du -a data/ | sort -n -r | head -n 10
