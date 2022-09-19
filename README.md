# armbian-mirror

![Armbian logo](www/armbian-logo.png)

An opinionated way to setup and manage Armbian mirrors on Ubuntu 20.04/22.04.

# Prerequisites

Before you decide to setup your mirror, ensure that the server you are setting up meets
the minimum requirements listed [here](https://github.com/armbian/mirror). You also should
be running Ubuntu 20.04 or 22.04. Other versions may work but have not been tested.

# Installation

Clone the repository from GitHub to /opt/armbian-mirror:

```
git clone https://github.com/airframesio/armbian-mirror.git /opt/armbian-mirror
```

Run the installer:

```
$ cd /opt/armbian-mirror
$ sudo ./install.sh
```

The installer will:
1. Update the system packages before installation.
2. Install [Caddy](https://caddyserver.com), a high performance and light web server.
3. Setup the permissions for the paths.
4. Copy in the core scripts and support files.
5. Copy in the default mirror configs (these need to be customized for your own use).
6. Start and enable the web server.
7. Setup the cron job to run hourly.

# Manual Usage

You shouldn't need to do this, since the cron job should run automatically. But if you choose to run it manually, here is how you can do it.

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

Mirror with a custom images and packages URLs and desination paths:

```
$ DL_MIRROR_URL=rsync://mirrors.dotsrc.org/armbian-dl \
DL_MIRROR_DIR=/var/www/armbian-mirror/dl \
APT_MIRROR_URL=rsync://mirrors.dotsrc.org/armbian-apt \
APT_MIRROR_DIR=/var/www/armbian-mirror/apt \
/opt/armbian-mirror/scripts/rsync-mirror.sh
```
