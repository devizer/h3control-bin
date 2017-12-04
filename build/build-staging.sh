#!/bin/bash
set -e
echo 1536000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
pushd `dirname $0` > /dev/null
SCRIPT=`pwd`
popd > /dev/null
echo build directory is $SCRIPT

ver=$(cat ver)
build=$(cat build)
build=$(( $build + 1 ))
echo $build > build
echo NEW h3control version is $ver.$build
echo -ne "\033]0;${USER}@${HOSTNAME}:  -=== Building $ver.$build (h3control) ===-\007"


umount /m/v || true
mount -a || true

src=/tmp/.build/h3control-tmp/source
target=/tmp/.build/h3control-tmp/target/h3control
rm -rf `dirname $src`
mkdir -p $src
mkdir -p $target/bin
cd $src
git clone https://github.com/devizer/h3control.git
rm -rf h3control/.git
echo "[assembly: System.Reflection.AssemblyVersion(\"$ver.$build.0\")]" > $src/h3control/H3Control/Properties/AssemblyVersion.cs
builddate=$(date --utc +"%a, %d %b %Y %T GMT")
echo "
   [assembly: System.Reflection.AssemblyVersion(\"$ver.$build.0\")]
   [assembly: Universe.AssemblyBuildDateTime(\"$builddate\")]
" > $src/h3control/H3Control/Properties/AssemblyVersion.cs


# root of repo
cd h3control
packages=/m/v/_GIT/h3control/packages
# cp -R $packages .
nuget restore H3Control.sln -Verbosity quiet
rm -rf H3Control/{bin,obj}
time ( xbuild H3Control.sln /t:Rebuild /p:Configuration=Release /v:q )

pushd packages/NUnit.ConsoleRunner.*/tools; export RUNNER_PATH=$(pwd); popd; echo RUNNER_PATH: $RUNNER_PATH;
mono $RUNNER_PATH/nunit3-console.exe -labels=On -workers=1 ./H3Control.Tests/bin/Release/H3Control.Tests.dll | tee H3Control.Tests.dll.log

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

cd $SCRIPT
# git commit -am "Staging update: v$ver.$build, staging updates aren't recommended for upgrade"
# git push

export BUILD_LABEL=staging
export BUILD_DATE=$(date +"%A, %B %d %Y %R %Z")
export BUILD_DATE=$(date +"%B %d, %Y")
export BUILT_VERSION="$ver.$build"
$SCRIPT/banner/make-banner.sh /tmp/status-normal.png
convert /tmp/status-normal.png -modulate 100,40,100 -brightness-contrast 9x0 ../staging/status.png

bash $SCRIPT/banner/make-svg-banner.sh ../staging/status.svg

git pull
git commit -am "Staging updated: v$ver.$build. Staging distributions aren't recommended for upgrade"
git push

git tag v$ver.$build-staging
git push --tags

echo ''
echo '*************************'
echo "DONE: v$ver.$build-staging"
echo ''

cd $src/..
rm -rf *

wget -q -nv -O - https://raw.githubusercontent.com/devizer/h3control-bin/master/staging/h3control-staging.sh | bash
