#!/bin/bash -e
ver=$(cat ver)
build=$(cat build)
build=$(( $build + 1 ))
echo $build > build
git pull || true
git commit -am "Building and deploing staging script: ($ver.$build)" || true
git push
