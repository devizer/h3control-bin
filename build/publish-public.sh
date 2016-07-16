#!/bin/bash
pushd `dirname $0` > /dev/null
SCRIPT=`pwd`
popd > /dev/null

fullver=$(cat ../staging/VERSION)
cp ../staging/* ../public

git pull
git commit -am "Public distribution updated: v$fullver"
git push

git tag v$fullver-public
git push --tags
