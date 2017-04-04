#!/bin/bash
# Information steps:
# 1) chmod u+x git-commit.sh
# 2) ./git-commit.sh

echo "--> Commit all changes to GIT"
cd ..
git add -A
echo "--> Please enter your message: "
read message
git commit -m "$message"
git push origin master
echo "--> Commit all changes to GIT - Done!"
