shell
#!/bin/bash

# Merge development to master
function merge_dev_to_master() {
    echo "Merging development to master..."
    git checkout master
    git pull origin master
    git checkout development
    git pull origin development
    git merge master
    git checkout master
    git merge development
    git push origin master
    echo "Merge development to master completed."
}

# Publish packages using Melos
function publish_packages() {
  echo "Publishing packages..."
  melos bootstrap
  melos get
  melos publish --no-dry-run --git-tag-version --yes
  git push origin --tags
  echo "Package publishing completed."
}

# BackMerge master to dev(Just for safety case)
function merge_master_to_dev() {
  echo "Merging master to development..."
  git checkout development
  git pull origin development
  git merge master
  git push origin development
  echo "Merge master to dev completed."
}


merge_dev_to_master
publish_packages
merge_master_to_dev