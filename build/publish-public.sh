#!/bin/bash
pushd `dirname $0` > /dev/null
SCRIPT=`pwd`
popd > /dev/null

fullver=$(cat ../staging/VERSION)
cp ../staging/* ../public

git pull
git commit -am "Public distribution updated: v$fullver"
git push

$SCRIPT/banner 

export BUILD_LABEL=public
export BUILD_DATE=$(date +"%A, %B %d %Y %R %Z")
export BUILT_VERSION="v:<b>$fullver</b>"
$SCRIPT/banner/make-banner.sh ../public/status.png

git tag v$fullver-public
git push --tags
