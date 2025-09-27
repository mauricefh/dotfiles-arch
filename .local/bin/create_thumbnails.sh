#!/bin/bash

# Create thumbnails directory if it doesn't exist
mkdir -p thumbnails

# Loop through image files (add extensions as needed)
for img in *.{jpg,jpeg,png,JPG,JPEG,PNG}; do
  # Skip if no matching files
  [ -e "$img" ] || continue

  # Extract the base filename
  filename=$(basename "$img")

  # Create the thumbnail
  magick "$img" -thumbnail 200x200 "thumbnails/$filename"
done
