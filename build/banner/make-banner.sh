#!/bin/bash -e
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null


outpng="$1"
echo "building banner with parameters:"
echo "     BUILD_LABEL: $BUILD_LABEL"
echo "      BUILD_DATE: $BUILD_DATE"
echo "   BUILT_VERSION: $BUILT_VERSION"
echo "     OUTPUT FILE: $outpng"
htmlfile=$(tempfile -pBA_ -s.html)
pngtemp=$(tempfile -pBA_ -s.png)
envsubst < $SCRIPTPATH/banner-template.html > $htmlfile

sudo xvfb-run --server-args="-screen 0, 311x44x24" $SCRIPTPATH/webkit2png.py -o "$pngtemp" file:///$htmlfile
cp "$pngtemp" "$outpng"

rm -f $htmlfile
rm -f $pngtemp
