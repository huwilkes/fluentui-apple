#!/bin/bash

#simple script used to create PRs for the automated localization process

newBranch="huwilkes/PRActions`date +%s`"

date +%s > timestamp

if [[ `git status --porcelain` ]]; then
  git config --global user.email ${{ secrets.EMAIL }}
  git config --global user.name ${{ secrets.NAME }}
  git add .
  git commit -m "test commit"
  git checkout -b $newBranch
  git push --set-upstream origin $newBranch
  gh pr create -B huwilkes/PRActions -H $newBranch --title 'test PR actions w/ script' --body  'new script, nice' -l 'Automated PR'

else
  echo "No changes"
fi