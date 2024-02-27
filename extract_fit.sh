#!/usr/bin/bash
# Check if the user provided an ITB file as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <ITB_FILE>"
    exit 1
fi

ITB_FILE="$1"

# Find the path to the dumpimage command
dumpimage_path=$(which dumpimage)

# Check if dumpimage is found
if [ -z "$dumpimage_path" ]; then
    echo "Error: dumpimage command not found. Please make sure it is installed and in your PATH."
    exit 1
fi

# Get the number of images in the FIT archive
num_images=$("$dumpimage_path" -l $ITB_FILE | grep -c "Image [0-9]")

# Iterate through each image and extract it
for ((i=0; i<$num_images; i++)); do
    # Extract the filename from the "image X" line
    filename=$("$dumpimage_path" -l $ITB_FILE | grep "Image $i" | awk '{print $NF}')

    # Extract the image using the appropriate dumpimage command
    "$dumpimage_path" -T flat_dt -p $i -o $filename $ITB_FILE

    echo "Extracted $filename"
done
