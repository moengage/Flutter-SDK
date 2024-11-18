cd "$(dirname "$0")/../.." || exit
echo "Current directory: $(pwd)"
outputs=$( melos exec -c 1 --no-private --ignore="*example*" -- dart pub publish --dry-run)
error_detected=false
warning_detected=false
while IFS= read -r line; do
  if echo "$line" | grep -q "Building package"; then
    error_detected=false
    warning_detected=false
  fi
  if echo "$line" | grep -q "Constraints that are too tight"; then
    continue
  elif echo "$line" | grep -q -E "^error:"; then
    error_detected=true
    echo "Error detected: $line"
  elif echo "$line" | grep -q -E "^warning:"; then
    warning_detected=true
    echo "Warning detected: $line"
  fi
done <<< "$outputs"
if [ "$error_detected" = true ]; then
  echo "Errors detected. Failing the build step."
  exit 1
elif [ "$warning_detected" = true ]; then
  echo "Warnings detected. Following up on the warnings, but the build will continue."
fi