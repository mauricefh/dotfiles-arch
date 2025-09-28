#!/usr/bin/env bash

# Define the system-wide font directory.
system_font_path='/usr/local/share/fonts'

# Check if a directory path was provided as an argument.
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_font_files>"
  exit 1
fi

# Assign the first argument to the 'source_path' variable.
source_path="$1"

# Check if the source path is a valid directory.
if [ ! -d "$source_path" ]; then
  echo "Error: Source directory '$source_path' does not exist."
  exit 1
fi

# Create the system font directory if it doesn't exist.
if [ ! -d "$system_font_path" ]; then
  echo "Creating font directory: $system_font_path"
  sudo mkdir -p "$system_font_path"
fi

# Loop through all files in the source directory.
for file in "$source_path"/*; do
  # Check if the file is a regular file and its name ends with .ttf.
  if [[ -f "$file" && "$file" == *.ttf ]]; then
    echo "Installing font: $(basename "$file")"
    sudo mv "$file" "$system_font_path"
  fi
done

# Update the font cache.
echo "Updating font cache..."
sudo fc-cache -fv

echo "Font installation complete."
