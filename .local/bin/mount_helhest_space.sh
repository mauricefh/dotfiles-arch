#!/bin/bash

MOUNT_POINT=~/Spaces/helhest
REMOTE_NAME=helhest-cane-corso-do-spaces

# Check if already mounted
if mount | grep "$MOUNT_POINT" > /dev/null; then
  echo "Already mounted at $MOUNT_POINT"
  exit 0
fi

# Make sure mount point exists
mkdir -p "$MOUNT_POINT"

# Mount in background
rclone mount "$REMOTE_NAME:" "$MOUNT_POINT" \
  --vfs-cache-mode writes \
  --log-level INFO \
  --log-file ~/.rclone_helhest.log &
  
echo "Mounting $REMOTE_NAME to $MOUNT_POINT in background..."
