#!/bin/bash
# Information steps:
# 1) chmod u+x git-create-version.sh
# 2) ./git-create-version.sh

# Information: https://git-scm.com/book/en/v2/Git-Basics-Tagging
echo "List existing tags/versions:"
git tag -l

echo "List existing tags/versions and comments:"
git tag -n5

echo "Insert your version name:"
read version_name

echo "Insert version comment:"
read version_comment

git tag -a $version_name -m "$version_comment"

echo "Push tags"
git push --tags

echo "Created version with using tags"
git show $version_name

echo "--> Version created GIT - Done!"
echo "Documentation: https://git-scm.com/book/en/v2/Git-Basics-Tagging"
echo "To checkout use: git checkout -b version2 v2.0.0"
