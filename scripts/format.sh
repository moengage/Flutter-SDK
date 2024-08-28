#!/bin/bash
ORIGINAL_DIR=$(pwd)
cd "$(dirname "$0")/.." || exit
echo "Running flutter Format"
dart format .
echo "Running Kt Lint Format"
(cd example/android && ./gradlew ktlintformat)
cd "$ORIGINAL_DIR" || exit