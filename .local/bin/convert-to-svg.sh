#!/bin/bash
# Default settings
recursive=false
# Supported file extensions (space-separated)
extensions="png jpg jpeg bmp tiff webp"
# Parse options
while getopts "r:" opt; do
  case $opt in
    r)
      recursive=true
      ;;
    *)
      echo "Usage: $0 [-r]"
      exit 1
      ;;
  esac
done
# Detect number of CPU cores
cores=$(nproc)
# Base output folder
output_base="svg"
# Log file for tracking conversions
log_file="conversion.log"
# Build find/ls patterns from extensions
find_pattern=""
ls_pattern=""
for ext in $extensions; do
  if [ -n "$find_pattern" ]; then
    find_pattern="$find_pattern -o"
    ls_pattern="$ls_pattern,"
  fi
  find_pattern="$find_pattern -iname \"*.$ext\""
  ls_pattern="$ls_pattern*.$ext"
done
# Choose files based on recursion
if [ "$recursive" = true ]; then
  files=$(eval "find . -type f \\( $find_pattern \\)")
else
  files=$(eval "ls {$ls_pattern} 2>/dev/null")
fi
# Convert images in parallel
echo "$files" | parallel -j "$cores" '
  file="{}"
  rel_path="${file#./}"
  output_file="./'"$output_base"'/${rel_path%.*}.svg"
  mkdir -p "$(dirname "$output_file")"
  
  if [ -f "$output_file" ]; then
    echo "Skipping $file, $output_file already exists." | tee -a '"$log_file"'
  else
    # Try VTracer for true vector conversion with color support
    if command -v vtracer >/dev/null 2>&1; then
      if vtracer --input "$file" --output "$output_file" 2>/dev/null; then
        echo "Vectorized $file → $output_file (vtracer)" | tee -a '"$log_file"'
      else
        echo "VTracer failed, falling back to inkscape for $file" | tee -a '"$log_file"'
        if inkscape "$file" --export-type=svg --export-area-drawing --export-filename="$output_file" 2>/dev/null; then
          echo "Converted $file → $output_file (inkscape fallback)" | tee -a '"$log_file"'
        else
          echo "Failed to convert $file" | tee -a '"$log_file"'
        fi
      fi
    else
      # Fallback to inkscape if vtracer not available
      if inkscape "$file" --export-type=svg --export-area-drawing --export-filename="$output_file" 2>/dev/null; then
        echo "Converted $file → $output_file (inkscape)" | tee -a '"$log_file"'
      else
        echo "Failed to convert $file" | tee -a '"$log_file"'
      fi
    fi
  fi
'
