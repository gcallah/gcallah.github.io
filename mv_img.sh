#!/bin/sh

if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide a name for the image."
  exit 1
fi

count=$(ls graphics/IMG*g 2>/dev/null | wc -l)

if [ "$count" -eq 0 ]; then
  echo "Error: No image files found in the graphics directory."
  exit 1
elif [ "$count" -gt 1 ]; then
  echo "Error: More than one IMG*g file found in graphics/."
  exit 1
elif [ -f "graphics/$1.jpg" ]; then
  echo "Error: File graphics/$1.jpg already exists. Please choose a different name."
  exit 1
fi

mv graphics/IMG*g graphics/$1.jpg

git add graphics/$1.jpg
