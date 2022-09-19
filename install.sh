#!/usr/bin/env bash

BASE_DIR="/opt/armbian-mirror"
OWNER="caddy"
GROUP="www-data"

WWW_DIR="${BASE_DIR}/www"
SCRIPTS_DIR="${BASE_DIR}/scripts"
TEMPLATES_DIR="${BASE_DIR}/templates"

# Update existing packages
sudo apt update && sudo apt full-upgrade -y

# Install Caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https -y
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy -y
sudo systemctl enable --now caddy

# Setup paths
sudo chown -R $OWNER:$GROUP $WWW_DIR
sudo chmod -R 0775 $WWW_DIR
sudo chown -R caddy:www-data /opt/armbian-mirror/scripts
sudo chmod +x /opt/armbian-mirror/scripts/*

# Configure Caddy
sudo mkdir -p /etc/caddy
sudo cp templates/Caddyfile /etc/caddy/Caddyfile
sudo systemctl enable caddy
sudo systemctl restart caddy

# Fetch initial mirror list
sudo $SCRIPTS_DIR/fetch-mirrors.py --output $WWW_DIR/mirrors.json
sudo chown caddy:www-data /opt/armbian-mirror/www/mirrors.json
sudo chmod 0644 /opt/armbian-mirror/www/mirrors.json

# Install python requirements
sudo apt install -y python3-pip
sudo pip3 install -r requirements.txt

# Install cron script
sudo cp templates/cron-script /etc/cron.daily/armbian-mirror
sudo chmod +x /etc/cron.daily/armbian-mirror
sudo chown root:root /etc/cron.daily/armbian-mirror
