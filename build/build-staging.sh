#!/bin/bash
set -e

counter=0;
function say() {
  counter=$((counter+1))
  message=$1
  echo -ne "\033]0;-== Building $ver.$build (h3control) as ${USER}@${HOSTNAME} ==-\007"
  LightGreen='\033[1;32m';Yellow='\033[1;33m';RED='\033[0;31m'; NC='\033[0m'; printf "\n${LightGreen}$ver.$build Step $counter:${NC} ${Yellow}$message${NC}\n";
}

echo 1536000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq || true
pushd `dirname $0` > /dev/null
SCRIPT=`pwd`
popd > /dev/null
echo build directory is $SCRIPT

pidfile=/var/run/h3control.pid

# do not stop production
function _ignore_kill_of_prod_() {
sudo systemctl stop h3control >/dev/null 2>&1 || true
if [ -f $pidfile ]; then pid=$(cat $pidfile 2>/dev/null); fi
if [ -n "$pid" ]; then
  sudo kill -12 $pid        >/dev/null 2>&1 || true
else
  sudo killall -q -s 12 mono   >/dev/null 2>&1 || true
fi
}

ver=$(cat ver)
build=$(cat build)
build=$(( $build + 1 ))
echo $build > build
echo NEW h3control version is $ver.$build
say "GIT clone"


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
say "NUGET Restore"
nuget restore H3Control.sln -Verbosity quiet
rm -rf H3Control/{bin,obj}

say "XBUILD Rebuild Release"
time ( xbuild H3Control.sln /t:Rebuild /p:Configuration=Release /v:q )

say "NUNIT Testing"
pushd packages/NUnit.ConsoleRunner.*/tools; export RUNNER_PATH=$(pwd); popd; echo RUNNER_PATH: $RUNNER_PATH;
mono $RUNNER_PATH/nunit3-console.exe -labels=On -workers=1 ./H3Control.Tests/bin/Release/H3Control.Tests.dll | tee H3Control.Tests.dll.log

say "Prepare h3control.tar.gz"
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

export LABEL_COLOR=4F4F4F
export VER_COLOR=d64b4b
export BUILD_LABEL=staging
export BUILD_DATE=$(date +"%A, %B %d %Y %R %Z")
export BUILD_DATE=$(date +"%B %d, %Y")
export BUILT_VERSION="$ver.$build"
# $SCRIPT/banner-v2/make-banner.sh /tmp/status-normal.png
# convert /tmp/status-normal.png -modulate 100,40,100 -brightness-contrast 9x0 ../staging/status.png

say "Prepare status.svg"

bash $SCRIPT/banner-v2/make-svg-banner.sh ../staging/status.svg

say "PUSH h3control.tar.gz, etc"

git pull
git commit -am "Staging updated: v$ver.$build. Staging distributions aren't recommended for upgrade"
git push


say "PUSH tag"
git tag v$ver.$build-staging
git push --tags

echo ''
echo '*************************'
echo "DONE: v$ver.$build-staging"
echo ''

cd $src/..
rm -rf *

say "DONE. Download and install v$ver.$build-staging"
wget -q -nv -O - https://raw.githubusercontent.com/devizer/h3control-bin/master/staging/h3control-staging.sh | bash
