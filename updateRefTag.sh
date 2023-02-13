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
echo If RefTag is ok then you can push to the remote with the command:
echo git push -f origin RefTag