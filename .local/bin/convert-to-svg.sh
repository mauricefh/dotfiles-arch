#!/bin/bash
# Default settings
recursive=false

# Supported file extensions (space-separated)
extensions="png jpg jpeg bmp tiff"

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
    # Get file extension to determine conversion method
    ext="${file##*.}"
    ext_lower=$(echo "$ext" | tr "[:upper:]" "[:lower:]")
    
    converted=false
    
    # Try potrace for bitmap formats that support it (works best with high contrast images)
    if [[ "$ext_lower" == "bmp" ]] || [[ "$ext_lower" == "png" ]] && command -v potrace >/dev/null 2>&1; then
      # Convert to PBM first (potrace requirement), then trace
      temp_pbm="/tmp/${file##*/}.pbm"
      if convert "$file" "$temp_pbm" 2>/dev/null && potrace -s "$temp_pbm" -o "$output_file" 2>/dev/null; then
        rm -f "$temp_pbm"
        echo "Vectorized $file → $output_file (potrace)" | tee -a '"$log_file"'
        converted=true
      else
        rm -f "$temp_pbm"
      fi
    fi
    
    # Fallback to inkscape (embeds raster in SVG)
    if [ "$converted" = false ]; then
      if inkscape "$file" --export-type=svg --export-area-drawing --export-filename="$output_file" 2>/dev/null; then
        echo "Converted $file → $output_file (inkscape)" | tee -a '"$log_file"'
      else
        echo "Failed to convert $file" | tee -a '"$log_file"'
      fi
    fi
  fi
'
