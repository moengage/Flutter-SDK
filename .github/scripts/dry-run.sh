cd "$(dirname "$0")/../.." || exit
echo "Current directory: $(pwd)"
outputs=$( melos exec -c 1 --no-private --ignore="*example*" -- dart pub publish --dry-run)
critical_issue_detected=false
while IFS= read -r line; do
  if echo "$line" | grep -q "Building package"; then
    critical_issue_detected=false
  fi
  if echo "$line" | grep -q "Constraints that are too tight"; then
    # Ignore strict versioning warning
    continue
  elif echo "$line" | grep -q -E "error:|warning:"; then
    critical_issue_detected=true
    # Print out the critical issue for debugging
    echo "Critical issue detected: $line"
  fi
done <<< "$outputs"
if [ "$critical_issue_detected" = true ]; then
  echo "Critical issues detected. Failing the build step."
  exit 1
fi