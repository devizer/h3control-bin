#!/bin/bash -e
set -e
pushd `dirname $0` > /dev/null
SCRIPT=`pwd`
popd > /dev/null

fullver=$(cat ../staging/VERSION)
cp ../staging/* ../public

git pull
git commit -am "Public distribution updated: v$fullver"
git push

export BUILD_LABEL=public
export BUILD_DATE=$(date +"%A, %B %d %Y %R %Z")
export BUILD_DATE=$(date +"%B %d")
export BUILT_VERSION="$fullver"
$SCRIPT/banner/make-banner.sh ../public/status.png

git commit -am "Public distribution updated: v$fullver"
git push


git tag v$fullver-public
git push --tags

echo
echo '*************************'
echo "DONE: v$fullver"
echo


sleep 5
wget -q -nv -O - https://github.com/devizer/h3control-bin/raw/master/public/h3control-install-daemon.sh | bash


