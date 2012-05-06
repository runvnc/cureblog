#!/bin/bash
EXPECTED_ARGS=3
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: publishplugin {name} {githubuser} {reponame}"
  exit $E_BADARGS
fi

set -e
echo Publishing plugin $1..
cd components/$1
set +e
git init
git remote add origin git@github.com:$2/$3.git
if [ ! -f .gitignore ]
then
  echo "node_modules" > .gitignore
fi
git add --all
git commit -m 'published plugin'
git push -f origin master
curl -d "name=$1&githubuser=$2&githubrepo=$3" oic.io/addplugin

