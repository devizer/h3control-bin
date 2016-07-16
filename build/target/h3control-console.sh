#!/bin/sh
# mono --desktop ./bin/H3Control.exe "$@"
mydir=`dirname $0` || mydir='.'
pushd "$mydir" >/dev/null
mono" --desktop "$mydir/bin/H3Control.exe" "$@"
popd >/dev/null
