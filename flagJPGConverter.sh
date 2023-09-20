#!/bin/bash

# Source directory containing the images
source_dir="./Flags"

# Destination directory for converted images
destination_dir="./JPGFlags"

# Loop through each image in the source directory
for image in "$source_dir"/*; do
    if [ -f "$image" ]; then
        # Get the image filename without the extension
        filename=$(basename "$image")
        filename_noext="${filename%.*}"
        
        # Convert the image to JPG format
        convert "$image" "$destination_dir/$filename_noext.jpg"
    fi
done

