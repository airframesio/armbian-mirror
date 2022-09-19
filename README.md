# armbian-mirror

![Armbian logo](armbian-logo.png)

An opinionated way to setup and manage Armbian mirrors on Ubuntu 20.04/22.04.

# Installation

Run the installer:

```
$ sudo ./install.sh
```

The installer will:
1. Update the system packages before installation.
2. Install [Caddy](https://caddyserver.com), a high performance and light web server.
3. Setup the `/opt/armbian-mirror` paths:
  * `/opt/armbian-mirror`
  * `/opt/armbian-mirror/configs`
  * `/opt/armbian-mirror/www`
4. Copy in the core scripts and support files.
5. Copy in the default mirror configs (these need to be customized for your own use).
6. Start and enable the web server.
7. Setup the cron job to run hourly.

# Manual Usage

Mirror with default values using opinionated URL and destination path:

```
$ /opt/armbian-mirror/scripts/rsync-mirror.sh
```

Mirror with a custom images and packages URLs:

```
$ DL_MIRROR_URL=rsync://mirrors.dotsrc.org/armbian-dl \
APT_MIRROR_URL=rsync://mirrors.dotsrc.org/armbian-apt \
/opt/armbian-mirror/scripts/rsync-mirror.sh
```
