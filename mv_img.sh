#!/bin/sh

# check for arg 1 being present
if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide a name for the image."
  exit 1
elif [ -z "graphics/IMG*g" ]; then
  echo "Error: No image files found in the graphics directory."
  exit 1
elif [ -f "graphics/$1.jpg" ]; then
  echo "Error: File graphics/$1.jpg already exists. Please choose a different name."
  exit 1
fi
# Move images from one name to another
mv graphics/IMG*g graphics/$1.jpg
git add graphics/$1.jpg
