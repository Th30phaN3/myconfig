#!/bin/sh

# This script create a new repo on github.com, then clone it and pushes some files as the first commit (README.md + .gitignore)
# Create an empty repository named after your project and make sure to execute this script inside the repository !
# This script gets a username from .gitconfig.  If it indicates that your default username is an empty string, you can set it with
# git config --global github.user YOUR_GIT_USERNAME

# Gather constant vars
CURRENTDIR=${PWD##*/}
GITHUBUSER=$(git config github.user)

# Get user input
echo "Enter name for new repo, or just <return> to make it $CURRENTDIR"
read REPONAME
echo "Enter username for new, or just <return> to make it $GITHUBUSER"
read USERNAME
echo "Enter description for your new repo, on one line, then <return>"
read DESCRIPTION
echo "Enter <return> to make the new repo public, 'x' for private"
read PRIVATE_ANSWER

if [ "$PRIVATE_ANSWER" == "x" ]; then
  PRIVACYWORD=private
  PRIVATE_TF=true
else
  PRIVACYWORD=public
  PRIVATE_TF=false
fi

REPONAME=${REPONAME:-${CURRENTDIR}}
USERNAME=${USERNAME:-${GITHUBUSER}}

echo "Will create a new *$PRIVACYWORD* repo named $REPONAME"
echo "on github.com in user account $USERNAME, with this description:"
echo $DESCRIPTION
echo "Type 'y' to proceed, any other character to cancel."
read OK
if [ "$OK" != "y" ]; then
  echo "User cancelled"
  exit
fi

# Curl some json to the github API
curl -u $USERNAME https://api.github.com/user/repos -d "{\"name\": \"$REPONAME\", \"description\": \"${DESCRIPTION}\", \"private\": $PRIVATE_TF, \"has_issues\": 
true, \"has_downloads\": true, \"has_wiki\": false}"

# Clone the freshly created repo and push basic files
# You'll need to have added your public key to your github account
# SSH key is used, make sure to have set it !
git clone git@github.com:$USERNAME/$REPONAME.git
cd $REPONAME
echo "# $REPONAME" >> README.md
echo "" >> .gitignore
git add README.md
git add .gitignore
git commit -m "first"
git push -u origin master