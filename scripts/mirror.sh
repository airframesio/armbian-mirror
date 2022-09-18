#!/bin/sh

DL_MIRROR_DIR=/var/www/armbian-mirror/dl
#DL_MIRROR_URL=rsync://rsync.armbian.com/dl
DL_MIRROR_URL=rsync://mirrors.dotsrc.org/armbian-dl
APT_MIRROR_DIR=/var/www/armbian-mirror/apt
APT_MIRROR_URL=rsync://mirrors.dotsrc.org/armbian-apt
MIRROR_NAME=armbian-us-sea
MIRROR_COUNTRY="US"
MIRROR_BANDWIDTH="1000"

echo "Starting Armbian mirror sync (${MIRROR_NAME} / ${MIRROR_COUNTRY} / ${MIRROR_BANDWIDTH}Mbit/s)"
nice -n 15 time rsync --no-perms --delete-after -avrP $DL_MIRROR_URL $DL_MIRROR_DIR
nice -n 15 rsync --no-perms --delete-after -avrP $APT_MIRROR_URL $APT_MIRROR_DIR
echo "Finished Armbian mirror sync (${MIRROR_NAME} / ${MIRROR_COUNTRY} / ${MIRROR_BANDWIDTH}Mbit/s)"
