#!/bin/bash

# Source directory containing the images
source_dir="./JPGFlags"

# Destination directories for converted images
destination_dirs=("./Buttons1" "./Buttons2" "./Buttons3")

# Create destination directories if they don't exist
for dest_dir in "${destination_dirs[@]}"; do
    mkdir -p "$dest_dir"
done

# Get the total number of image files
total_files=$(find "$source_dir" -maxdepth 1 -type f -iname "*.jpg" | wc -l)

completed_files=0
start_time=$(date +%s)

# Loop through each image in the source directory
for image in "$source_dir"/*.jpg; do
    if [ -f "$image" ]; then
        # Get the image filename without the extension
        filename=$(basename "$image")
        filename_noext="${filename%.*}"
		
        completed_files=$((completed_files + 1))
        progress=$((completed_files * 100 / total_files))

        # Resize and composite images for each destination directory
        for dest_dir in "${destination_dirs[@]}"; do
            overlay_image="overlay_image$((completed_files % ${#destination_dirs[@]} + 1)).png"
            convert "$image" "$overlay_image" -resize x$(identify -format "%h" "$image") -gravity center -composite -crop 1:1 "$dest_dir/$filename_noext.jpg"
        done

        # Calculate average processing time per image
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))

        # Calculate ETA based on average processing time
        remaining_files=$((total_files - completed_files))
        eta_seconds=$((elapsed_time * remaining_files / completed_files))
        eta_formatted=$(date -u -d @$eta_seconds +"%H:%M:%S")

        #echo -ne "ETA: $eta_formatted \r"
        echo -ne "$eta_formatted progress: $completed_files / $total_files $progress% \r"
    fi
done

