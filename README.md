# GeoIP Database Updater Script

This script, automates the process of checking for new releases of GeoIP
databases on GitHub, downloading them if they're not already present, and
updating the local database files for use.

## Prerequisites

Ensure `wget` and `curl` are installed on your system.

## Setup Instructions

### 1. Create the Destination Directory

```bash
sudo mkdir -p /usr/local/share/GeoIP
```

### 2. Create a Group for GeoIP Users

Create a group to manage access to the GeoIP data.

```bash
sudo groupadd geoipusers
```
**Note: Log out and back in for the group change to take effect.**

### 3. Set Permissions and Ownership

Change the group ownership of the `/usr/local/share/GeoIP` directory to
`geoipusers`, and set the appropriate permissions.

```bash
sudo chown :geoipusers /usr/local/share/GeoIP
sudo chmod 775 /usr/local/share/GeoIP
```

### 4. Add Your User to the GeoIP Users Group

Add your user account to the `geoipusers` group to allow script execution and
access to the GeoIP directory.

```bash
sudo usermod -a -G geoipusers $USER
```

*Note: You may need to log out and log back in for the group changes to take effect.*

### 5. Install the Script

Copy the script to a globally accessible location and ensure it is executable:

```bash
sudo cp geoip_updater.sh /usr/local/bin/
sudo chown :geoipusers /usr/local/bin/geoip_updater.sh
sudo chmod +x /usr/local/bin/geoip_updater.sh
```

### 6. Schedule the Script in Crontab

Edit your crontab to run the script automatically:

```bash
crontab -e
```

Add the following line to schedule the script to run daily at 2 AM:

```bash
0 2 * * * /usr/local/bin/geoip_updater.sh >> /var/log/geoip_update.log 2>&1
```

### 7. Prepare the Log File

Make sure the script can write to the log file:

```bash
sudo touch /var/log/geoip_update.log
sudo chown :geoipusers /var/log/geoip_update.log
sudo chmod 664 /var/log/geoip_update.log
```

## Running the Script

The script will run as scheduled in the crontab. You can also execute it
manually at any time:

```bash
/usr/local/bin/geoip_updater.sh
```

## Troubleshooting

- Ensure the script is executable and the `/var/log/geoip_update.log` file is writable.
- Verify the crontab entry if the script does not run as expected.
- Check the log file `/var/log/geoip_update.log` for errors if the script fails.
