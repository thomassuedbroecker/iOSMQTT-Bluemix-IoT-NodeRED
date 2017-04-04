#!/bin/bash
# Information steps:
# 1) chmod u+x git-setup-rebase.sh
# 2) ./git-setup-rebase.sh

echo "--> Setup rebase"
cd ..
echo "--> Please enter your upstream path: "
# sample gitupsteampath: git@github.com:cloud-dach/iotreceiver.git
read gitupsteampath
git remote add upstream $gitupsteampath
git remote -v
git fetch upstream
git rebase upstream/master
