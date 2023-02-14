#!/bin/bash
origin_path=$PWD

ActualBranch=$(git symbolic-ref --short HEAD)
git checkout -b _REFTAG
git log -1 > VERSION.md
git add VERSION.md
git commit -m "Create detached commit for RefTag"
git tag -f -m "Replace RefTag" RefTag
git checkout RefTag
git branch -d _REFTAG
git checkout $ActualBranch
echo
echo 1. Create and test locally this installer with the command:
echo git archive --format zip --output VSCode.zip RefTag
echo
echo 2. Then if the installer seems ok then you can push to the remote with the command:
echo git push -f origin RefTag