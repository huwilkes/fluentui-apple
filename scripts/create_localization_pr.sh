#!/bin/bash

#simple script used to create PRs for the automated localization process

timestamp=$(<$1)

git checkout -b 'huwilkes/PRActions$timestamp'
git push --set-upstream origin huwilkes/PRActions$timestamp
gh pr create -B huwilkes/PRActions -H huwilkes/PRActions$timestamp --title 'test PR actions w/ script' --body  'new script, nice' -l 'Automated PR'
