shell
#!/bin/bash

# This script is used to merge the development branch to the master branch, publish packages, and merge the master branch back to the development branch.

function merge_dev_to_master() {
    echo "Merging dev to master..."
    git checkout master
    git pull origin master
    git checkout development
    git pull origin development
    git merge master
    git checkout master
    git merge development
    git push origin master
    echo "Merge dev to master completed."
}

function publish_packages() {
  echo "Publishing packages..."
  melos bootstrap
  melos get
  melos publish --no-dry-run --git-tag-version --yes
  git push origin --tags
  echo "Package publishing completed."
}

function merge_master_to_dev() {
  echo "Merging master to dev..."
  git checkout development
  git pull origin development
  git merge master
  git push origin development
  echo "Merge master to dev completed."
}


merge_dev_to_master
publish_packages
merge_master_to_dev