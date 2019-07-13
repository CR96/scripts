#!/bin/sh

## Extract user data from old TWRP data partition backups and discard unnecessary Android bloat.

echo -e "
#############################################################################################
#                                                                                           #
#                                   WARNING: PLEASE READ                                    #
#                                                                                           #
#    To those who may find this script: This was written for my personal use.               #
#    As such, it is not thoroughly tested and expects a very specific backup structure.     #
#                                                                                           #
#    You will NOT be able to restore a cleaned backup using TWRP. This script extracts      #
#    application data and user data from a backup for easier storage, and DELETES other     #
#    content such as app caches, binary packages, and system partitions which contain no    #
#    user-specific data. This saves storage space on your computer. Manual transfer of      #
#    user data to a new ROM or device at a later time is possible, but may require root.    #
#                                                                                           #
#    This script can/will result in data loss if used in a directory that has already       #
#    been cleaned. Be sure you have a second copy of any backups you intend to clean.       #
#                                                                                           #
#    Have fun! --Corey, 2019-07-12                                                          #
#                                                                                           #
#############################################################################################
"

echo "Do you want to continue?"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) break;;
		No ) exit;;
	esac
done

# Extract each TAR archive.
# Exit immediately on failure to avoid data loss.

# Check to see if the archives are compressed.
# If one is compressed, they all should be.
if [[ $(file data.ext4.win000) == *compressed* ]]; then
	echo "Backup is compressed. Extracting..."
	find . -name '*.win???' -exec tar -xzvf '{}' \; || { echo "Unable to extract archive(s), script will now exit to avoid data loss" ; exit 1; }
else
	echo "Backup is not compressed. Extracting..."
	find . -name '*.win???' -exec tar -xvf '{}' \; || { echo "Unable to extract archive(s), script will now exit to avoid data loss" ; exit 1; }
fi

# Find SMS/MMS databases and copy them to a safe place.
# Exit immediately on failure to avoid data loss.
mkdir sms/
find data/ -name '*mmssms*' -exec cp '{}' sms/ \; || { echo "Unable to locate SMS/MMS data, script will now exit to avoid data loss" ; exit 1; }

# Remove the archives and their checksums.
rm data.ext4.win???
rm data.ext4.win???.md5
rm data.ext4.win???.sha2

# If the system partition was present in the backup, delete the extracted contents.
# They contain no user data.
if [ -d system/ ]; then rm -rf system; fi

cd data/

# Remove all cache files from the backup.
rm -rf `find -type d -name cache`

# Remove application binaries, this folder contains no user data.
rm -rf app/

# List 10 largest application data folders for manual review and deletion.
echo "Large application data folders"
echo "=============================="
du -a data/ | sort -n -r | head -n 10
