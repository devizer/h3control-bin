#!/bin/bash
set -e

src=/tmp/.build/h3control-ppc
rm -rf $src
mkdir -p $src
cd $src
git clone https://github.com/devizer/h3control.git
rm -rf h3control/.git
echo "[assembly: System.Reflection.AssemblyVersion(\"1.2.3.4\")]" > $src/h3control/H3Control/Properties/AssemblyVersion.cs
builddate=$(date --utc +"%a, %d %b %Y %T GMT")
echo "
   [assembly: System.Reflection.AssemblyVersion(\"1.2.3.4\")]
   [assembly: Universe.AssemblyBuildDateTime(\"$builddate\")]
" > $src/h3control/H3Control/Properties/AssemblyVersion.cs

cd h3control
wget --no-check-certificate -O h3control-src-dependencies.zip 'https://github.com/devizer/glist/raw/master/bin/h3control-src-dependencies.zip'
unzip -o h3control-src-dependencies.zip
# nuget restore H3Control.sln 
rm -rf H3Control/{bin,obj}
time ( xbuild H3Control.sln /t:Rebuild /p:Configuration=Release /verbosity:mininal )
nu-c -labels ./H3Control.Tests/bin/Release/H3Control.Tests.dll | tee H3Control.Tests.dll.log

