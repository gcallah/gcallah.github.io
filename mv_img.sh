#!/bin/sh

# check for arg 1 being present
if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide a name for the image."
  exit 1
fi
# Move images from one name to another
mv graphics/IMG*g graphics/$1.jpg
git add graphics/$1.jpg
