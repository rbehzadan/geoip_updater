# GeoIP Database Updater Script

This script, automates the process of checking for new releases of GeoIP
databases on [GitHub](https://github.com/merkez/maxmind-databases), downloading them if they're not already present, and
updating the local database files for use.

## Prerequisites

Before proceeding, ensure that `wget` and `curl` are installed on your system,
as they are required for the script to download files and check URLs.

## Setup Instructions

### Using `setup.sh` Script

1. **Execute `setup.sh` as Normal User**:
    - Run the setup script as a normal user **without** sudo privileges to perform operations like creating directories, changing permissions, and editing the crontab. It will ask you for the password when needed.
      ```bash
      ./setup.sh
      ```
    - This approach ensures that the crontab entries are added to the current user's crontab, not the root's crontab.

2. **Verify Crontab Entry**:
    - After running `setup.sh`, verify that the crontab entries have been added correctly by listing the current user's crontab:
      ```bash
      crontab -l
      ```
    - You should see three new entries for running `geoip_updater.sh` with specific dates.


## Manual Execution

After setup, the `geoip_updater.sh` script will run automatically according to the schedule set in the crontab. However, you can also run the script manually at any time by executing:

```bash
/usr/local/bin/geoip_updater.sh
```

Optionally, you can specify a date as an argument to manually check and download the database for a specific date:

```bash
/usr/local/bin/geoip_updater.sh YYYY-MM-DD
```

## Troubleshooting

- If the script does not run as scheduled, ensure that the `crontab` entries are set correctly and that `geoip_updater.sh` is executable.
- Check the log file `/var/log/geoip_update.log` for any errors or messages output by the script.

## Acknowledgements
I would like to extend my sincere gratitude to [ChatGPT](https://chat.openai.com/) for providing extensive help in writing, checking, and documenting this project. The guidance and support received were invaluable in ensuring the quality and reliability of the scripts and documentation. Thank you for being an integral part of this project's development.
