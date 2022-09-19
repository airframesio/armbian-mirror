# armbian-mirror

![Armbian logo](armbian-logo.png)

An opinionated way to setup and manage Armbian mirrors on Ubuntu 20.04/22.04.

# Installation

Run the installer:

```
$ sudo ./install.sh
```

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
