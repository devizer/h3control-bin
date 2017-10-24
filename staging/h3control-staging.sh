#!/bin/bash
cd /tmp
wget -O h3control.tar.gz https://github.com/devizer/h3control-bin/raw/master/staging/h3control.tar.gz
killall -q -12 mono || echo ''
rm -rf h3control
tar xzf h3control.tar.gz
bash h3control/h3control-console.sh --binding=*:5000
