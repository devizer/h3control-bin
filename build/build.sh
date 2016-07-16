#!/bin/bash
pushd `dirname $0` > /dev/null
SCRIPT=`pwd`
popd > /dev/null
echo build directory is $build

ver=$(cat ver)
build=$(cat build)


umount /m/v || true
mount -a || true

src=~/.build/h3control-tmp/source
target=~/.build/h3control-tmp/target/h3control
rm -rf `dirname $src`
mkdir -p $src
mkdir -p $target/bin
cd $src
git clone https://github.com/devizer/h3control.git
echo "[assembly: System.Reflection.AssemblyVersion(\"$ver.$build.0\")]" > $src/h3control/H3Control/Properties/AssemblyVersion.cs

# root of repo
cd h3control
packages=/m/v/_GIT/h3control/packages
cp -R $packages .
rm -rf H3Control/{bin,obj}
time ( xbuild H3Control.sln /t:Rebuild /p:Configuration=Release /verbosity:normal )


cp -R $src/h3control/H3Control/bin/Release/* $target/bin
for f in jqx-all.js jqxscheduler.js jqxgrid.js jqxscheduler.api.js jqxdatetimeinput.js jqxdatatable.js ; do
  rm $target/bin/web/jqwidgets/$f
done

cp -R $SCRIPT/target/* $target
echo $ver.$build > $target/VERSION

cd $target/bin
chmod -R 644 .
find . -type d -exec chmod 755 {} \;

cd $target/..
tar cf - h3control/ | pv | gzip -9 > h3control.tar.gz

cp $target/../h3control.tar.gz $SCRIPT/../staging/h3control.tar.gz
echo $ver.$build >  $SCRIPT/../staging/VERSION


dt=`date +%s`
echo "{ version: '$ver.$build', date: $dt }" > $SCRIPT/../staging/h3control-version.json

