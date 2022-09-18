#!/usr/bin/env bash

# Update existing packages
sudo apt update && sudo apt full-upgrade -y

# Install Caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https -y
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy -y
sudo systemctl enable --now caddy

# Setup mirror base path
sudo mkdir -p /opt/armbian-mirror/www
sudo chown caddy:www-data /opt/armbian-mirror/www
sudo chmod 0775 /opt/armbian-mirror/www

# Configure Caddy
sudo mkdir -p /etc/caddy
sudo cp templates/Caddyfile /etc/caddy/Caddyfile
sudo systemctl restart caddy

# Setup initial HTML template
sudo cp templates/index.html.initial /opt/armbian-mirror/www/index.html
sudo chown caddy:www-data /opt/armbian-mirror/www/index.html
sudo chmod 0644 /opt/armbian-mirror/www/index.html

# Install scripts
sudo mkdir -p /opt/armbian-mirror/scripts
sudo cp scripts/* /opt/armbian-mirror/scripts/
sudo chown -R caddy:www-data /opt/armbian-mirror/scripts
sudo chmod +x /opt/armbian-mirror/scripts/*

# Fetch initial mirror list
sudo /opt/armbian-mirror/scripts/fetch-mirrors.py --output /opt/armbian-mirror/www/mirrors.json
sudo chown caddy:www-data /opt/armbian-mirror/www/mirrors.json
sudo chmod 0644 /opt/armbian-mirror/www/mirrors.json

# Install cron script
sudo cp templates/cron-script /etc/cron.daily/armbian-mirror
sudo chmod +x /etc/cron.daily/armbian-mirror
sudo chown root:root /etc/cron.hourly/armbian-mirror
