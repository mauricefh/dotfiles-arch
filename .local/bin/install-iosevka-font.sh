#!/bin/bash

# Define directory and font URL
DIR="/usr/local/share/fonts"
FONT_URL="https://github.com/be5invis/Iosevka/releases/download/v32.3.1/PkgTTC-SGr-IosevkaFixed-32.3.1.zip"
TEMP_DIR="/tmp/iosevka-font"

# Check if wget is installed
if ! command -v wget &> /dev/null; then
  echo "wget is not installed. Install it..."
  sudo pacman -S wget
  echo "wget installation finished"
fi

# Check if the fonts directory exists, create it if it doesn't
if [ ! -d "$DIR" ]; then
  sudo mkdir -p "$DIR"
  echo "Directory $DIR created."
else
  echo "Directory $DIR already exists."
fi

# Download the font ZIP file
echo "Downloading Iosevka Fixed font..."
wget -q "$FONT_URL" -O "$TEMP_DIR/iosevka-fixed.zip"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Font downloaded successfully."

  # Create a temporary directory to extract the font files
  mkdir -p "$TEMP_DIR"

  # Extract the ZIP file
  echo "Extracting the font files..."
  sudo unzip -o "$TEMP_DIR/iosevka-fixed.zip" -d "$TEMP_DIR"

  # Copy the font files to the fonts directory
  echo "Copying font files to $DIR..."
  sudo cp -r "$TEMP_DIR/iosevka-fixed/"* "$DIR/"

  # Clean up
  rm -rf "$TEMP_DIR"
  echo "Font installation completed. Please run 'fc-cache -fv' to update the font cache."

else
  echo "Failed to download the font."
fi

