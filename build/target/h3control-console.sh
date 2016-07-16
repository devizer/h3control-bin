#!/bin/sh
# mono --desktop ./bin/H3Control.exe "$@"
command -v mono >/dev/null || ( echo mono NOT FOUND. Check mono executable is installed and present in the \$PATH ; exit 0 )
command -v dirname >/dev/null || ( echo dirname NOT FOUND. Check dirname executable is present in the \$PATH ; exit 0 )

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

mono --desktop "$SCRIPTPATH/bin/H3Control.exe" "$@"
