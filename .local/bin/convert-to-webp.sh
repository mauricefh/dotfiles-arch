#!/bin/bash

# Default settings
recursive=false
quality=80
log_file="webp_conversion.log"

# Parse options
while getopts "rq:" opt; do
  case $opt in
    r)
      recursive=true
      ;;
    q)
      quality="$OPTARG"
      ;;
    *)
      echo "Usage: $0 [-r] [-q quality]"
      exit 1
      ;;
  esac
done

# Detect number of CPU cores
cores=$(nproc)

# Base output folder
output_base="webp"

# Clear previous log
echo "WebP Conversion Log - $(date)" > "$log_file"

# Choose files based on recursion
if [ "$recursive" = true ]; then
  files=$(find . -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \))
else
  files=$(ls *.{png,jpg,jpeg} 2>/dev/null)
fi

# Convert images in parallel
echo "$files" | parallel -j "$cores" '
  file="{}"
  rel_path="${file#./}"
  output_file="./'"$output_base"'/${rel_path%.*}.webp"
  mkdir -p "$(dirname "$output_file")"
  
  if [ -f "$output_file" ]; then
    echo "Skipping $file, $output_file already exists." | tee -a '"$log_file"'
  else
    if cwebp -q '"$quality"' "$file" -o "$output_file"; then
      echo "Converted $file → $output_file" | tee -a '"$log_file"'
    else
      echo "Failed to convert $file" | tee -a '"$log_file"'
    fi
  fi
'
