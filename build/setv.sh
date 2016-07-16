#!/bin/bash -e
ver=$(cat ver)
build=$(cat build)
git pull
git commit -am "Version assigned manually: $ver.$build" || git push
