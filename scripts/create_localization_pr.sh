#!/bin/bash

#simple script used to create PRs for the automated localization process

email=$(<$1)
name=$(<$2)
newBranch="huwilkes/PRActions`date +%s`"

date +%s > timestamp

if [[ `git status --porcelain` ]]; then
  echo "Found changes"
  git config --global user.email $email
  git config --global user.name $name
  git add .
  git commit -m "test commit"
  git checkout -b $newBranch
  git push --set-upstream origin $newBranch
  gh pr create -B huwilkes/PRActions -H $newBranch --title 'test PR actions w/ script' --body  'new script, nice' -l 'Automated PR'

else
  echo "No changes"
fi
