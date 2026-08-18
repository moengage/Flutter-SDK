#!/bin/bash
ORIGINAL_DIR=$(pwd)
cd "$(dirname "$0")/.." || exit
echo "Running flutter Format"
dart format .
echo "Running Spotless Format"
chmod +x ./scripts/spotless-format.sh
./scripts/spotless-format.sh
cd "$ORIGINAL_DIR" || exit