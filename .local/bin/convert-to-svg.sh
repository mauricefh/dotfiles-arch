#!/bin/bash

# Default settings
recursive=false
remove_bg=true
quality="ultra"  # ultra, high, medium
# Supported file extensions (space-separated)
extensions="png jpg jpeg bmp tiff webp gif"

# Parse options
while getopts "rbq:h" opt; do
  case $opt in
    r)
      recursive=true
      ;;
    b)
      remove_bg=false
      ;;
    q)
      quality="$OPTARG"
      ;;
    h)
      echo "Usage: $0 [-r] [-b] [-q quality]"
      echo "  -r         Process recursively"
      echo "  -b         Keep background (don't remove)"
      echo "  -q quality Set quality (ultra/high/medium)"
      echo "  -h         Show this help"
      exit 0
      ;;
    *)
      echo "Usage: $0 [-r] [-b] [-q quality] [-h]"
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
# Temp directory for processing
temp_dir="/tmp/svg_conversion_$$"
mkdir -p "$temp_dir"

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

# Function to get image dimensions
get_dimensions() {
  local file="$1"
  identify -format "%wx%h" "$file" 2>/dev/null || echo "0x0"
}

# Function to remove background using rembg or imagemagick
remove_background() {
  local input="$1"
  local output="$2"
  
  if command -v rembg >/dev/null 2>&1; then
    # Use rembg for better background removal
    rembg i "$input" "$output" 2>/dev/null
    return $?
  elif command -v convert >/dev/null 2>&1; then
    # Fallback to ImageMagick with transparency
    convert "$input" \
      -fuzz 10% \
      -transparent white \
      -trim +repage \
      "$output" 2>/dev/null
    return $?
  else
    # Just copy if no bg removal available
    cp "$input" "$output"
    return $?
  fi
}

# Function to optimize PNG before conversion
optimize_png() {
  local input="$1"
  local output="$2"
  
  if command -v pngquant >/dev/null 2>&1; then
    pngquant --quality=90-100 --speed 1 --output "$output" --force "$input" 2>/dev/null || cp "$input" "$output"
  elif command -v optipng >/dev/null 2>&1; then
    cp "$input" "$output"
    optipng -o7 "$output" 2>/dev/null
  else
    cp "$input" "$output"
  fi
}

# Convert images in parallel
echo "$files" | parallel -j "$cores" '
  file="{}"
  rel_path="${file#./}"
  output_file="./'"$output_base"'/${rel_path%.*}.svg"
  temp_dir="'"$temp_dir"'"
  remove_bg="'"$remove_bg"'"
  quality="'"$quality"'"
  log_file="'"$log_file"'"
  
  mkdir -p "$(dirname "$output_file")"
  
  if [ -f "$output_file" ]; then
    echo "Skipping $file, $output_file already exists." | tee -a "$log_file"
  else
    # Get original dimensions
    orig_dims=$(identify -format "%wx%h" "$file" 2>/dev/null)
    if [ -z "$orig_dims" ]; then
      orig_dims="0x0"
    fi
    
    # Create temp file name
    temp_input="$temp_dir/$(basename "$file")"
    temp_processed="$temp_dir/processed_$(basename "$file")"
    temp_png="$temp_dir/$(basename "${file%.*}").png"
    
    # Copy original to temp
    cp "$file" "$temp_input"
    
    # Process image based on settings
    if [ "$remove_bg" = "true" ]; then
      echo "Removing background from $file..." | tee -a "$log_file"
      
      # Convert to PNG first if not already
      if [[ ! "$file" =~ \.(png|PNG)$ ]]; then
        if command -v convert >/dev/null 2>&1; then
          convert "$temp_input" "$temp_png" 2>/dev/null
          temp_input="$temp_png"
        fi
      fi
      
      # Remove background
      if command -v rembg >/dev/null 2>&1; then
        rembg i "$temp_input" "$temp_processed" 2>/dev/null
        if [ $? -eq 0 ]; then
          temp_input="$temp_processed"
          echo "Background removed using rembg" | tee -a "$log_file"
        fi
      elif command -v convert >/dev/null 2>&1; then
        # Use ImageMagick to remove white background and trim
        convert "$temp_input" \
          -fuzz 15% \
          -transparent white \
          -trim +repage \
          "$temp_processed" 2>/dev/null
        if [ $? -eq 0 ]; then
          temp_input="$temp_processed"
          echo "Background removed using ImageMagick" | tee -a "$log_file"
        fi
      fi
    fi
    
    # Optimize if PNG
    if [[ "$temp_input" =~ \.(png|PNG)$ ]]; then
      temp_optimized="$temp_dir/optimized_$(basename "$temp_input")"
      if command -v pngquant >/dev/null 2>&1; then
        pngquant --quality=95-100 --speed 1 --output "$temp_optimized" --force "$temp_input" 2>/dev/null
        if [ $? -eq 0 ]; then
          temp_input="$temp_optimized"
        fi
      fi
    fi
    
    conversion_done=false
    
    # Try potrace for black and white images
    if command -v potrace >/dev/null 2>&1 && command -v convert >/dev/null 2>&1; then
      # Check if image is mostly black and white
      colors=$(convert "$temp_input" -format "%k" info: 2>/dev/null)
      if [ -n "$colors" ] && [ "$colors" -lt 256 ]; then
        temp_bmp="$temp_dir/$(basename "${file%.*}").bmp"
        convert "$temp_input" -colorspace Gray -threshold 50% "$temp_bmp" 2>/dev/null
        if [ $? -eq 0 ]; then
          if potrace -s "$temp_bmp" -o "$output_file" --flat 2>/dev/null; then
            echo "Vectorized $file → $output_file (potrace for B&W)" | tee -a "$log_file"
            conversion_done=true
          fi
        fi
      fi
    fi
    
    # Try vtracer for color images
    if [ "$conversion_done" = false ] && command -v vtracer >/dev/null 2>&1; then
      # Set parameters based on quality level
      case "$quality" in
        ultra)
          if vtracer --input "$temp_input" --output "$output_file" \
            --colormode color \
            --hierarchical stacked \
            --mode spline \
            --filter_speckle 1 \
            --color_precision 8 \
            --corner_threshold 10 \
            --segment_length 2 \
            --gradient_step 1 \
            --splice_threshold 10 \
            --path_precision 15 2>/dev/null; then
            echo "Vectorized $file → $output_file (vtracer ultra)" | tee -a "$log_file"
            conversion_done=true
          fi
          ;;
        high)
          if vtracer --input "$temp_input" --output "$output_file" \
            --colormode color \
            --hierarchical stacked \
            --mode spline \
            --filter_speckle 2 \
            --color_precision 7 \
            --corner_threshold 20 \
            --segment_length 4 \
            --gradient_step 2 \
            --splice_threshold 20 \
            --path_precision 12 2>/dev/null; then
            echo "Vectorized $file → $output_file (vtracer high)" | tee -a "$log_file"
            conversion_done=true
          fi
          ;;
        *)
          if vtracer --input "$temp_input" --output "$output_file" \
            --colormode color \
            --hierarchical stacked \
            --mode polygon \
            --filter_speckle 4 \
            --color_precision 6 \
            --corner_threshold 60 \
            --segment_length 10 2>/dev/null; then
            echo "Vectorized $file → $output_file (vtracer medium)" | tee -a "$log_file"
            conversion_done=true
          fi
          ;;
      esac
    fi
    
    # Try autotrace if available
    if [ "$conversion_done" = false ] && command -v autotrace >/dev/null 2>&1; then
      if autotrace --input-format=png --output-format=svg \
        --color-count=256 \
        --corner-threshold=100 \
        --despeckle-level=2 \
        --line-threshold=0.5 \
        --preserve-width \
        --remove-adjacent-corners \
        "$temp_input" --output-file="$output_file" 2>/dev/null; then
        echo "Vectorized $file → $output_file (autotrace)" | tee -a "$log_file"
        conversion_done=true
      fi
    fi
    
    # Fallback to Inkscape with advanced options
    if [ "$conversion_done" = false ] && command -v inkscape >/dev/null 2>&1; then
      # Try trace bitmap for better results
      if inkscape "$temp_input" \
        --actions="select-all;object-to-path;export-filename:$output_file;export-do" \
        --export-type=svg \
        --export-area-drawing \
        --export-text-to-path \
        --export-background-opacity=0 2>/dev/null; then
        echo "Converted $file → $output_file (inkscape trace)" | tee -a "$log_file"
        conversion_done=true
      elif inkscape "$temp_input" \
        --export-type=svg \
        --export-area-drawing \
        --export-filename="$output_file" \
        --export-background-opacity=0 2>/dev/null; then
        echo "Converted $file → $output_file (inkscape)" | tee -a "$log_file"
        conversion_done=true
      fi
    fi
    
    # Ultimate fallback: ImageMagick (embedded raster)
    if [ "$conversion_done" = false ] && command -v convert >/dev/null 2>&1; then
      if convert "$temp_input" "$output_file" 2>/dev/null; then
        echo "Converted $file → $output_file (ImageMagick embedded)" | tee -a "$log_file"
        conversion_done=true
      fi
    fi
    
    # Post-process SVG to ensure proper dimensions
    if [ "$conversion_done" = true ] && [ -f "$output_file" ]; then
      # Try to set viewBox to match original dimensions
      if command -v xmlstarlet >/dev/null 2>&1 && [ "$orig_dims" != "0x0" ]; then
        width="${orig_dims%x*}"
        height="${orig_dims#*x}"
        xmlstarlet ed -L \
          -u "//*[local-name()='"'"'svg'"'"']/@viewBox" -v "0 0 $width $height" \
          -i "//*[local-name()='"'"'svg'"'"'][not(@viewBox)]" -t attr -n "viewBox" -v "0 0 $width $height" \
          "$output_file" 2>/dev/null
      fi
      
      # Optimize SVG file
      if command -v svgo >/dev/null 2>&1; then
        svgo "$output_file" \
          --multipass \
          --precision=3 \
          --disable=removeViewBox \
          --enable=removeDoctype \
          --enable=removeXMLProcInst \
          --enable=removeComments \
          --enable=removeMetadata \
          --enable=removeXMLNS \
          --enable=removeEditorsNSData \
          --enable=removeEmptyAttrs \
          --enable=removeHiddenElems \
          --enable=removeEmptyContainers \
          --enable=convertStyleToAttrs \
          --enable=convertPathData \
          --enable=convertTransform \
          --enable=removeUnknownsAndDefaults \
          --enable=removeNonInheritableGroupAttrs \
          --enable=removeUselessStrokeAndFill \
          --enable=cleanupNumericValues \
          --enable=cleanupListOfValues \
          --enable=moveElemsAttrsToGroup \
          --enable=collapseGroups \
          --enable=mergePaths 2>/dev/null
        echo "Optimized $output_file with SVGO" | tee -a "$log_file"
      elif command -v scour >/dev/null 2>&1; then
        temp_svg="$temp_dir/temp.svg"
        scour -i "$output_file" -o "$temp_svg" \
          --enable-viewboxing \
          --enable-id-stripping \
          --enable-comment-stripping \
          --shorten-ids \
          --indent=none 2>/dev/null
        if [ $? -eq 0 ]; then
          mv "$temp_svg" "$output_file"
          echo "Optimized $output_file with Scour" | tee -a "$log_file"
        fi
      fi
    fi
    
    if [ "$conversion_done" = false ]; then
      echo "Failed to convert $file - no suitable converter found" | tee -a "$log_file"
    fi
    
    # Clean up temp files for this image
    rm -f "$temp_dir"/*"$(basename "${file%.*}")"*
  fi
'

# Clean up temp directory
rm -rf "$temp_dir"

echo "Conversion complete. Check $log_file for details."
