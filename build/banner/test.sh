#!/bin/bash
sudo xvfb-run --server-args="-screen 0, 1024x768x24" ./webkit2png.py -o test-google.png http://www.google.com


export BUILD_LABEL=staging
export BUILD_DATE=$(date +"%A, %B %d %Y %R %Z")
export BUILT_VERSION='1.23.456'

./make-banner.sh test-result.png
sleep 5
