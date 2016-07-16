#!/bin/sh
# mono --desktop ./bin/H3Control.exe "$@"

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

mono --desktop "$SCRIPTPATH/bin/H3Control.exe" "$@"
