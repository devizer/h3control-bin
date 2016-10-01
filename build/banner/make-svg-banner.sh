#!/bin/bash -e
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

outsvg="$1"
echo "building banner with parameters:"
echo "     BUILD_LABEL: $BUILD_LABEL"
echo "      BUILD_DATE: $BUILD_DATE"
echo "   BUILT_VERSION: $BUILT_VERSION"
echo "     OUTPUT FILE: $outsvg"
envsubst < $SCRIPTPATH/banner-template.svg > $outsvg

