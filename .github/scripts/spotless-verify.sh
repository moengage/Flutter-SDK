#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/../.." && PROJECT_ROOT=$(pwd)
echo "Project root directory: $PROJECT_ROOT"

CLASSPATH_SPOTLESS_PATTERN="classpath 'com.diffplug.spotless:spotless-plugin-gradle:"
PLUGIN_SPOTLESS_PATTERN="apply plugin: 'com.diffplug.spotless'"

if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE=(-i '')
else
  SED_INPLACE=(-i)
fi

echo "Uncommenting spotless lines in build.gradle files within the project..."
find "$PROJECT_ROOT" -name '*.gradle' -type f \
  -exec echo "Uncommenting in file: {}" \; \
  -exec sed "${SED_INPLACE[@]}" "s|// $CLASSPATH_SPOTLESS_PATTERN|$CLASSPATH_SPOTLESS_PATTERN|g" "{}" \; \
  -exec sed "${SED_INPLACE[@]}" "s|// $PLUGIN_SPOTLESS_PATTERN|$PLUGIN_SPOTLESS_PATTERN|g" "{}" \;

EXAMPLE_DIR="$PROJECT_ROOT/example/android"
if [ -d "$EXAMPLE_DIR" ]; then
  echo "Running spotless verify in $EXAMPLE_DIR directory..."
  cd "$EXAMPLE_DIR" && ./gradlew spotlessCheck || { echo "Failed to run spotless verify"; exit 1; }
else
  echo "The example/android directory does not exist in the project."
  exit 1
fi

echo "Commenting spotless lines in build.gradle files within the project..."
find "$PROJECT_ROOT" -name '*.gradle' -type f \
  -exec echo "Commenting out in file: {}" \; \
  -exec sed "${SED_INPLACE[@]}" "s|$CLASSPATH_SPOTLESS_PATTERN|// &|g" "{}" \; \
  -exec sed "${SED_INPLACE[@]}" "s|$PLUGIN_SPOTLESS_PATTERN|// &|g" "{}" \;

echo "spotless script completed successfully."
