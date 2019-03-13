#!/bin/sh
#
# This script create a new repo on github.com, then clone it and pushes some files as the first commit (README.md + .gitignore)
# Before executing this script, create an empty folder named after your project and move into it !
# This script gets a username from .gitconfig.  If it indicates that your default username is an empty string, you can set it with <git config --global github.user YOUR_GIT_USERNAME>

CURRENTDIR=${PWD##*/}
GITHUBUSER=$(git config github.user)

echo "Enter name for new repo ($CURRENTDIR by default):"
read REPONAME
echo "Enter username for new repo ($GITHUBUSER by default):"
read USERNAME
echo "Enter description for your new repo, on one line:"
read DESCRIPTION
echo "Enter x for private repository (public by default):"
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


# TODO choose techno (node, symfony, c, c++, .NET core, python, go)
# Make the other script executable, add the #!/bin/bash line at the top, and the path where the file is to the $PATH environment variable. Then you can call it as a normal command

printf "Will create a new *$PRIVACYWORD* repo named $REPONAME on github.com in user account $USERNAME, with this description:\n$DESCRIPTION\nType 'y' to proceed, any other character to cancel."
read OK
if [ "$OK" != "y" ]; then
  echo "User cancelled"
  exit
fi

# Curl some json to the github API
curl -u $USERNAME https://api.github.com/user/repos -d "{\"name\": \"$REPONAME\", \"description\": \"${DESCRIPTION}\", \"private\": $PRIVATE_TF, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

# Clone the freshly created repo inside folder and push basic files.
# You'll need to have added your public key to your github account.
# SSH key is used, make sure to have set it !
git clone git@github.com:$USERNAME/$REPONAME.git .
echo "# $REPONAME" >> README.md
echo "" >> .gitignore
git add README.md

# wget https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore -O .gitignore
# wget https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore -O .gitignore
# wget https://raw.githubusercontent.com/github/gitignore/master/Lua.gitignore -O .gitignore
# wget https://raw.githubusercontent.com/github/gitignore/master/Go.gitignore -O .gitignore
# wget https://raw.githubusercontent.com/github/gitignore/master/Composer.gitignore -O .gitignore
# wget https://raw.githubusercontent.com/github/gitignore/master/C.gitignore -O .gitignore
# wget https://raw.githubusercontent.com/github/gitignore/master/C++.gitignore -O .gitignore
# wget https://raw.githubusercontent.com/github/gitignore/master/Android.gitignore -O .gitignore
# wget https://raw.githubusercontent.com/github/gitignore/master/VisualStudioCode.gitignore -O .gitignore

git add .gitignore # TODO add gitignore for techno used
git commit -m "Initial commit"
git push -u origin master


#function node-project {
#git init
#npx license $(npm get init.license) -o "$(npm get init.author.name)" > LICENSE
#npx gitignore node
#npx covgen "$(npm get init.author.email)"
#npm init -y
#git add -A
#git commit -m "Initial commit"
#}

# composer create-project symfony/skeleton $name_repo
