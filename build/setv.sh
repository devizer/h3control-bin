#!/bin/bash -e
ver=$(cat ver)
build=$(cat build)
git pull || true
git commit -am "Version assigned manually: $ver.$build" || true
git push
