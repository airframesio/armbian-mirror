#!/usr/bin/env bash

sudo apt update && sudo apt full-upgrade -y
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https -y
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy -y
systemctl enable --now caddy

sudo mkdir -p /var/www/armbian-mirror
sudo chown caddy:www-data /var/www/armbian-mirror
sudo chmod 0775 /var/www/armbian-mirror

sudo mkdir -p /etc/caddy
cp templates/Caddyfile /etc/caddy/Caddyfile
sudo systemctl restart caddy

cp templates/index.html /var/www/armbian-mirror/index.html
chown caddy:www-data /var/www/armbian-mirror/index.html
chmod 0644 /var/www/armbian-mirror/index.html
