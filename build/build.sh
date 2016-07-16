#!/bin/bash
umount /m/v || true
mount -a || true
src=~/.build/h3control-tmp/source
target=~/.build/h3control-tmp/target
rm -rf `dirname $src`
mkdir -p $src
mkdir -p $target/bin
cd $src
git clone https://github.com/devizer/h3control.git

# root of repo
cd h3control
packages=/m/v/_GIT/h3control/packages
cp -R $packages .
rm -rf H3Control/{bin,obj}
time ( xbuild H3Control.sln /t:Rebuild /p:Configuration=Release /verbosity:normal )

cd H3Control/bin/Release
cp -R . $target/bin
cd ..
