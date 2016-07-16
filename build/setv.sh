#!/bin/bash -e
ver=$(cat ver)
build=$(cat build)
git pull || true
git commit -am "Building version assigned manually: $ver.$build" || true
git push
