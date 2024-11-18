#!/bin/bash
cd "$GITHUB_WORKSPACE" || exit
echo "Current directory: $(pwd)"
unformatted_files=$(git ls-files --modified | grep ".*\.dart$")

# Check if there are any modified (unformatted) files
if [[ -n $unformatted_files ]]; then
  printf "\n\n-------------------------\n\n"
  echo "The following files are not formatted correctly:"
  echo "$unformatted_files" # This will list the file names
  printf "\n\n-------------------------\n\n"

  # Optionally checkout the files to discard changes if running in CI
  if [[ $GITHUB_WORKFLOW ]]; then
    git checkout . &> /dev/null
  fi

  echo "To fix these files locally, run: 'melos run format'"
  exit 1
else
  echo "✅ All files are formatted correctly."
fi