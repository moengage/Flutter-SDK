#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/../.." && PROJECT_ROOT=$(pwd)
echo "Project root directory: $PROJECT_ROOT"

CLASSPATH_KTLINT_PATTERN="classpath \"org.jlleitschuh.gradle:ktlint-gradle:"
PLUGIN_KTLINT_PATTERN="apply plugin: 'org.jlleitschuh.gradle.ktlint'"

if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE=(-i '')
else
  SED_INPLACE=(-i)
fi

echo "Uncommenting ktlint lines in build.gradle files within the project..."
find "$PROJECT_ROOT" -name '*.gradle' -type f \
  -exec echo "Uncommenting in file: {}" \; \
  -exec sed "${SED_INPLACE[@]}" "s|// $CLASSPATH_KTLINT_PATTERN|$CLASSPATH_KTLINT_PATTERN|g" "{}" \; \
  -exec sed "${SED_INPLACE[@]}" "s|// $PLUGIN_KTLINT_PATTERN|$PLUGIN_KTLINT_PATTERN|g" "{}" \;

EXAMPLE_DIR="$PROJECT_ROOT/example/android"
if [ -d "$EXAMPLE_DIR" ]; then
  echo "Running ktlint verify in $EXAMPLE_DIR directory..."
  cd "$EXAMPLE_DIR" && ./gradlew ktlintcheck || { echo "Failed to run ktlint verify"; exit 1; }
else
  echo "The example/android directory does not exist in the project."
  exit 1
fi

echo "Commenting ktlint lines in build.gradle files within the project..."
find "$PROJECT_ROOT" -name '*.gradle' -type f \
  -exec echo "Commenting out in file: {}" \; \
  -exec sed "${SED_INPLACE[@]}" "s|$CLASSPATH_KTLINT_PATTERN|// &|g" "{}" \; \
  -exec sed "${SED_INPLACE[@]}" "s|$PLUGIN_KTLINT_PATTERN|// &|g" "{}" \;

echo "ktlint script completed successfully."