#!/bin/bash
echo "Running flutter analyze"
melos analyze
echo "Running Unit Test"
melos unittest
echo "Running dry run"
melos exec -c 1 --no-private --ignore="*example*" -- flutter pub publish --dry-run
echo "Project Verification Completed."