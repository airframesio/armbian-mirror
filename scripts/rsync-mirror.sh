#!/bin/sh

DL_MIRROR_DIR=/var/www/armbian-mirror/dl
#DL_MIRROR_URL=rsync://rsync.armbian.com/dl
DL_MIRROR_URL=rsync://mirrors.dotsrc.org/armbian-dl
APT_MIRROR_DIR=/var/www/armbian-mirror/apt
APT_MIRROR_URL=rsync://mirrors.dotsrc.org/armbian-apt

echo "Starting Armbian mirror sync at $(date)"

if [ ! -z "$DL_MIRROR_DIR" && ! -z "$DL_MIRROR_URL" ]; then
  nice -n 15 time rsync --no-perms --delete-after -avrP $DL_MIRROR_URL $DL_MIRROR_DIR
fi

if [ ! -z "$APT_MIRROR_DIR" && ! -z "$APT_MIRROR_URL" ]; then
  nice -n 15 time rsync --no-perms --delete-after -avrP $APT_MIRROR_URL $APT_MIRROR_DIR
fi

echo "Finished Armbian mirror sync at $(date)"
