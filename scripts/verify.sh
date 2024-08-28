#!/bin/bash
ORIGINAL_DIR=$(pwd)
cd "$(dirname "$0")/.." || exit
echo "Running Kt Lint"
(cd example/android && ./gradlew ktlintcheck)
echo "Running Unit Test"
melos unittest
echo "Running flutter analyze"
melos analyze
echo "Running dry run"
melos exec -c 1 --no-private --ignore="*example*" -- flutter pub publish --dry-run
echo "Project Verification Completed."
cd "$ORIGINAL_DIR" || exit