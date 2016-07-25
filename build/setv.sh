#!/bin/bash -e
git config credential.helper store
ver=$(cat ver)
build=$(cat build)
build=$(( $build + 1 ))
echo $build > build
echo NEW h3control version is $ver.$build
git pull || true
git commit -am "Build scripts and murkup updates ($ver.$build)" || true
git push
sleep 2
