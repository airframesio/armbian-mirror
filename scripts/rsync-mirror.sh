#!/bin/sh

CONFIG_PATH="${1:-/opt/armbian-mirror/configs/me}"
if [ ! -f $CONFIG_PATH ]; then
  echo "Config file not found, exiting"
  exit 1
fi
echo "Using config file: $CONFIG_PATH"

MIRROR_ENABLED=$(jq -r '.enabled' $CONFIG_PATH)
if [ "$MIRROR_ENABLED" = "false" ]; then
  echo "Mirror is disabled, exiting"
  exit 0
fi

if [ -f /var/run/armbian-mirror.lock ]; then
  echo "A sync is already running. If this isn't true, remove the /var/run/armbian-mirror.lock file. Exiting."
  exit 0
fi
touch /var/run/armbian-mirror.lock

if [ -f /var/run/armbian-mirror.last-sync ]; then
  LAST_SYNC=$(cat /var/run/armbian-mirror.last-sync)
  LAST_SYNC_STRING="$(date -d @$LAST_SYNC)"
else
  LAST_SYNC_STRING="never"
fi

echo "Starting Armbian mirror sync at $(date) (last sync: $LAST_SYNC_STRING)"

MIRROR_NAME=$(jq -r '.name' $CONFIG_PATH)
MIRROR_PRETTY_NAME=$(jq -r '.pretty_name' $CONFIG_PATH)
MIRROR_LOCATION=$(jq -r '.location' $CONFIG_PATH)
MIRROR_WEB_URL=$(jq -r '.url' $CONFIG_PATH)
MIRROR_BANDWIDTH=$(jq -r '.bandwidth' $CONFIG_PATH)
MIRROR_CONTACT_NAME=$(jq -r '.contact.name' $CONFIG_PATH)
MIRROR_CONTACT_EMAIL=$(jq -r '.contact.email' $CONFIG_PATH)

MIRROR_IMAGES_ENABLED=$(jq -r '[.repositories[].type] | contains(["images"])' $CONFIG_PATH)
MIRROR_PACKAGES_ENABLED=$(jq -r '[.repositories[].type] | contains(["packages"])' $CONFIG_PATH)
MIRROR_ARCHIVES_ENABLED=$(jq -r '[.repositories[].type] | contains(["archives"])' $CONFIG_PATH)
MIRROR_BETA_ENABLED=$(jq -r '[.repositories[].type] | contains(["beta"])' $CONFIG_PATH)

if [ "$MIRROR_IMAGES_ENABLED" = "true" ]; then
  MIRROR_IMAGES_PATH=$(jq -r '.repositories[] | select(.type == "images") | .path' $CONFIG_PATH)
  MIRROR_IMAGES_URL=$(jq -r '.repositories[] | select(.type == "images") | .url' $CONFIG_PATH)
  MIRROR_IMAGES_SOURCE_URL=$(jq -r '.repositories[] | select(.type == "images") | .source_url' $CONFIG_PATH)
  echo "Syncing images from $MIRROR_IMAGES_SOURCE_URL to $MIRROR_IMAGES_PATH"
  nice -n 15 rsync --no-perms --chown=caddy:www-data --delete -avrP $MIRROR_IMAGES_SOURCE_URL $MIRROR_IMAGES_PATH
fi

if [ "$MIRROR_PACKAGES_ENABLED" = "true" ]; then
  MIRROR_PACKAGES_PATH=$(jq -r '.repositories[] | select(.type == "packages") | .path' $CONFIG_PATH)
  MIRROR_PACKAGES_URL=$(jq -r '.repositories[] | select(.type == "packages") | .url' $CONFIG_PATH)
  MIRROR_PACKAGES_SOURCE_URL=$(jq -r '.repositories[] | select(.type == "packages") | .source_url' $CONFIG_PATH)
  echo "Syncing packages from $MIRROR_PACKAGES_SOURCE_URL to $MIRROR_PACKAGES_PATH"
  nice -n 15 rsync --no-perms --chown=caddy:www-data --delete -avrP $MIRROR_PACKAGES_SOURCE_URL $MIRROR_PACKAGES_PATH
fi

if [ "$MIRROR_ARCHIVES_ENABLED" = "true" ]; then
  MIRROR_ARCHIVES_PATH=$(jq -r '.repositories[] | select(.type == "archives") | .path' $CONFIG_PATH)
  MIRROR_ARCHIVES_URL=$(jq -r '.repositories[] | select(.type == "archives") | .url' $CONFIG_PATH)
  MIRROR_ARCHIVES_SOURCE_URL=$(jq -r '.repositories[] | select(.type == "archives") | .source_url' $CONFIG_PATH)
  echo "Syncing archives from $MIRROR_ARCHIVES_SOURCE_URL to $MIRROR_ARCHIVES_PATH"
  nice -n 15 rsync --no-perms --chown=caddy:www-data -avrP $MIRROR_ARCHIVES_SOURCE_URL $MIRROR_ARCHIVES_PATH
fi

if [ "$MIRROR_BETA_ENABLED" = "true" ]; then
  MIRROR_BETA_PATH=$(jq -r '.repositories[] | select(.type == "beta") | .path' $CONFIG_PATH)
  MIRROR_BETA_URL=$(jq -r '.repositories[] | select(.type == "beta") | .url' $CONFIG_PATH)
  MIRROR_BETA_SOURCE_URL=$(jq -r '.repositories[] | select(.type == "beta") | .source_url' $CONFIG_PATH)
  echo "Syncing beta from $MIRROR_BETA_SOURCE_URL to $MIRROR_BETA_PATH"
  nice -n 15 rsync --no-perms --chown=caddy:www-data --delete -avrP $MIRROR_BETA_SOURCE_URL $MIRROR_BETA_PATH
fi

echo "Finished Armbian mirror sync at $(date)"

rm /var/run/armbian-mirror.lock
date +%s > /var/run/armbian-mirror.last-sync
