#!/bin/bash

SOURCE_DIR="perry@hoffman2.idre.ucla.edu:/u/home/f/perry/phylogenetic/"
DEST_DIR="/Users/perry/Desktop/phylogenetics"

# Ensure the local destination actually exists
mkdir -p "$DEST_DIR"

# Define the rsync arguments in an array for safety
ARGS=(
    -av 
    --prune-empty-dirs
    --include="*/"           # 1. Allow all directories (so rsync can look inside)
    --include="*.log"        # 2. Match your files
    --include="inputs.txt"
    --include="*.xml"
    --include="*.trees"
    --exclude="*"            # 3. Block everything else
)

# Run it directly without eval
echo "Starting sync..."
rsync "${ARGS[@]}" "$SOURCE_DIR" "$DEST_DIR"

if [ $? -eq 0 ]; then
    echo "Sync successful!"
else
    echo "Sync encountered an issue. Check the error above."
fi