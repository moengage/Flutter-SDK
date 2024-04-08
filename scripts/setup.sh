#!/bin/bash
dart pub global activate melos
melos clean
melos bootstrap
melos exec -- flutter pub get
echo "All Flutter projects updated."