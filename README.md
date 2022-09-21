# armbian-mirror

![Armbian logo](www/armbian-logo.png)

An opinionated way to setup and manage Armbian mirrors on Ubuntu 20.04/22.04.

See a few of our mirrors:
* [https://mirror-us-sea1.armbian.airframes.io](https://mirror-us-sea1.armbian.airframes.io)
* [https://mirror-eu-de1.armbian.airframes.io](https://mirror-eu-de1.armbian.airframes.io)

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
$ sudo ./install.sh <fully-qualified-hostname>
```

The installer will:
1. Update the system packages before installation.
2. Install [Caddy](https://caddyserver.com), a high performance and light web server.
3. Setup the permissions for the paths.
4. Copy in the core scripts and support files.
5. Copy in the default mirror configs (these need to be replaced with your own).
6. Start and enable the web server.
7. Setup the cron job to run hourly.

# Configuration

1. Create configs in the `/opt/armbian-mirror/configs` directory. There should be a config for each mirror you run.
2. Remove any unrelated configs, such as our examples.
3. On each of your mirrors, create a symbolic link from `configs/me` to the one that represents the mirror you are configuring. The scripts are looking for this in order to perform the syncs.

```
$ ln -s /opt/armbian-mirror/configs/whatever.json /opt/armbian-mirror/configs/me
```

4. Generate the initial `index.html`. It should show that the status is `Pending`.

```
$ /opt/armbian-mirror/scripts/update-index.py
```

Once the hourly cron kicks in the first time, it will sync automatically. If you don't want to wait for the cron to hit, you may follow the Manual Usage section below one time.

# Example configuration file

We have included our configurations as examples in the `/opt/armbian-mirror/configs` path.

Here is what one of them looks like:

```json
{
  "name": "mirror-us-sea1",
  "pretty_name": "Armbian Mirror",
  "location": "Seattle, Washington, USA",
  "path": "/opt/armbian-mirror",
  "url": "https://mirror-us-sea1.armbian.airframes.io",
  "bandwidth": "1Gbps",
  "transfer_limit": "32TB / month",
  "contact": {
    "name": "Kevin Elliott",
    "email": "armbian@airframes.io"
  },
  "sponsor": {
    "name": "Airframes",
    "url": "https://airframes.io",
    "logo": "https://app.airframes.io/logotype-bw.svg"
  },
  "repositories": [
    {
      "type": "images",
      "path": "/opt/armbian-mirror/www/dl",
      "url": "https://mirror-us-sea1.armbian.airframes.io/dl",
      "source_url": "rsync://rsync.armbian.com/dl"
    },
    {
      "type": "packages",
      "path": "/opt/armbian-mirror/www/apt",
      "url": "https://mirror-us-sea1.armbian.airframes.io/apt",
      "source_url": "rsync://rsync.armbian.com/apt"
    }
  ],
  "enabled": true
}
```

# Manual Usage

You shouldn't need to do this, since the cron job should run automatically. But if you choose to run it manually, here is how you can do it. Be sure you have done the configuration steps above first.

Mirror with default values using opinionated URL and destination path:

```
$ /opt/armbian-mirror/scripts/rsync-mirror.sh
$ /opt/armbian-mirror/scripts/update-index.py
```

If during the initial sync you wish for the status to reflect `Syncing`, you must run the `/opt/armbian-mirror/scripts/update-index.py` in another shell instance to detect and update the HTML file.
