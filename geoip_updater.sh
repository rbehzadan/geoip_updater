#! /bin/bash

# Script Name: geoip_updater.sh
# Description: This script checks for new GeoLite2 City database releases from
#              the specified GitHub repository, downloads the latest release
#              if it's not already present, and updates the local database
#              file. It ensures the destination directory is writable and
#              handles download and extraction of the database.
# Usage: Execute without arguments. Designed to be run as a cron job or
#        manually as needed.

# Exit immediately if a command exits with a non-zero status.
set -e

# Define variables
DATE=$(date -I)
DEST_DIR="/usr/local/share/GeoIP"
FN="GeoLite2-City-${DATE//-/}.tar.gz"
URL="https://github.com/merkez/maxmind-databases/releases/download/${DATE}/${FN}"
MMDB="GeoLite2-City.mmdb"
DEST="${DEST_DIR}/GeoLite2-City-${DATE//-/}.mmdb"

# Check if the target file is already downloaded
check_if_file_is_already_downloaded() {
  if [ -e "$DEST" ]; then
    echo "File is already on the local filesystem"
    ensure_symlink_exists
    exit 0
  fi
}

# Verify destination directory is writable
check_if_dest_dir_is_writable_by_user() {
  if [ ! -w "$DEST_DIR" ]; then
    echo "Destination directory is not writable: ${DEST_DIR}" >&2
    exit 1
  fi
}

# Check if the URL exists
check_url_exists() {
  status_code=$(curl -o /dev/null -I -s -w "%{http_code}" "$URL")
  
  if [[ "$status_code" -eq 404 ]]; then
    echo "No new release for today!"
    exit 0
  elif [[ "$status_code" -ge 400 && "$status_code" -lt 500 ]]; then
    echo "Client-side error detected: $status_code" >&2
    exit 1
  elif [[ "$status_code" -ge 500 && "$status_code" -lt 600 ]]; then
    echo "Server-side error detected: $status_code" >&2
    exit 1
  fi
}

# Download the GeoIP package
download_geoip_package() {
  echo "Downloading ${URL}"
  wget -qO "/tmp/${FN}" "$URL"
}

# Extract the MMDB file from the downloaded package
extract_mmdb() {
  MMDB_PATH=$(tar -tzf "/tmp/${FN}" | grep "${MMDB}" || true)
  if [ -n "$MMDB_PATH" ]; then
    tar -xzf "/tmp/${FN}" "${MMDB_PATH}" && mv "$MMDB_PATH" $DEST
  else
    echo "Failed to find ${MMDB} in the tarball." >&2
    exit 1
  fi
}

# Clean up the temporary files
clean_up() {
  rm -rf "/tmp/${FN}" "/tmp/$(dirname "${MMDB_PATH}")"
}

# Ensure the symlink to the latest database exists
ensure_symlink_exists() {
  ln -s -f "$DEST" "${DEST_DIR}/${MMDB}"
}

# Main execution flow
echo "Checking for the GeoLite2 City database release for ${DATE}"
check_if_file_is_already_downloaded
check_if_dest_dir_is_writable_by_user
check_url_exists
download_geoip_package
extract_mmdb
ensure_symlink_exists
clean_up
echo "GeoLite2 City database update completed."
