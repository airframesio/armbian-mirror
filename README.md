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

# Usage

Mirror images to a path:

```
$ ./mirror.sh images /var/www/armbian-mirror/dl
```

Mirror packages to a path:

```
$ ./mirror.sh packages /var/www/armbian-mirror/apt
```

Mirror archives to a path:

```
$ ./mirror.sh archive /var/www/armbian-mirror/archives
```

Mirror beta to a path:

```
$ ./mirror.sh beta /var/www/armbian-mirror/archives
```
