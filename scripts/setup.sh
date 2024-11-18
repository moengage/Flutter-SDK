#!/bin/bash
ORIGINAL_DIR=$(pwd)
cd "$(dirname "$0")/.." || exit
dart pub global activate melos
melos clean
melos bootstrap
melos exec -- flutter pub get
echo "All Flutter projects updated."
cd "$ORIGINAL_DIR" || exit