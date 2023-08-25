#!/bin/bash
# Replace 'YOUR_FLUTTER_PROJECTS_PATH' with the path to your main folder containing all Flutter projects
PROJECTS_PATH=".."
# Find all directories that contain a pubspec.yaml file (assuming these are Flutter projects)
FLUTTER_PROJECT_DIRS=$(find "$PROJECTS_PATH" -name "pubspec.yaml" -exec dirname {} \;)
# Iterate through each project directory and run 'flutter pub get'
for dir in $FLUTTER_PROJECT_DIRS; do
    echo "Running 'flutter pub get' in $dir"
    pushd "$dir" > /dev/null
    flutter clean
    flutter pub get
    popd > /dev/null
done
echo "All Flutter projects updated."
