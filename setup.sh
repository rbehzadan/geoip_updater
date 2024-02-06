#!/bin/bash

# Setup script for geoip_updater.sh

# Define variables
DEST_DIR="/usr/local/share/GeoIP"
SCRIPT_NAME="geoip_updater.sh"
SCRIPT_PATH="/usr/local/bin/$SCRIPT_NAME"
GROUP_NAME="geoipusers"
LOG_DIR="/var/log"
LOG_FILE="$LOG_DIR/geoip_update.log"
CRON_SCHEDULE="0 2 * * *"
CRON_CMD="$SCRIPT_PATH >> $LOG_FILE 2>&1"

# Step 1: Ensure the destination directory exists
sudo mkdir -p "$DEST_DIR"

# Step 2: Create the group if it doesn't exist and add the current user
if ! grep -q "^$GROUP_NAME:" /etc/group; then
    sudo groupadd "$GROUP_NAME"
fi
sudo usermod -a -G "$GROUP_NAME" "$USER"

# Step 3: Set permissions on the destination directory
sudo chown :"$GROUP_NAME" "$DEST_DIR"
sudo chmod 775 "$DEST_DIR"

# Step 4: Install the geoip_updater.sh script
sudo cp "$SCRIPT_NAME" "$SCRIPT_PATH"
sudo chmod +x "$SCRIPT_PATH"

# Step 5: Add a crontab entry (if it doesn't already exist)
# Create temporary crontab file
crontab -l > /tmp/current_crontab
if ! grep -Fq "$SCRIPT_NAME" /tmp/current_crontab; then
    echo "$CRON_SCHEDULE $CRON_CMD" >> /tmp/current_crontab
    crontab /tmp/current_crontab
fi
rm /tmp/current_crontab

# Step 6: Ensure log file exists and is writable
sudo touch "$LOG_FILE"
sudo chown :"$GROUP_NAME" "$LOG_FILE"
sudo chmod 664 "$LOG_FILE"

echo "Setup completed. $SCRIPT_NAME is scheduled to run daily at 2 AM."

