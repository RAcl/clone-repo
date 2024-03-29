#!/bin/bash
#
# Description: Clone a GitHub repository in your PC
#
# Require: git, gh
#
# Use: sh clone-repo.sh <org>
#

if [ $# -ne 1 ]; then
    echo "Use: \n\t $0 <Organization>\n"
    exit 1
fi

ORG=$1

clone() {
        RUTA=$1
        DEFUSER="git@github.com:"
        DEFEXT=".git"
        REPO="${DEFUSER}$RUTA${DEFEXT}"
        echo "> git clone $REPO"
        git clone $REPO
        DIRECTORY=$(echo $RUTA | awk -F/ '{print $2}')
        cd $DIRECTORY
        git config pull.rebase false
        git branch -r | grep -v '\->' | while read remote; do 
                git branch --track "${remote#origin/}" "$remote"
        done
        git fetch --all
        git pull --all
        cd ..
}

for repo in $(gh repo list ${ORG} -L 1000 | awk '{print $1}'); do
        echo "-----------------------------------------------------------"
        echo $repo
        echo "-----------------------------------------------------------"
        clone "$repo"
        echo "-----------------------------------------------------------"
done
