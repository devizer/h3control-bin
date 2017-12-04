#!/bin/bash
cd /tmp
wget -O h3control.tar.gz https://github.com/devizer/h3control-bin/raw/master/public/h3control.tar.gz

pidfile=/var/run/h3control.pid

# Stop Prev Version
sudo systemctl stop h3control >/dev/null 2>&1 || true
pid=$(cat $pidfile 2>/dev/null)
if [ -n "$pid" ]; then
  sudo kill -12 $pid        >/dev/null 2>&1 
else
  sudo killall -q -s 12 mono   >/dev/null 2>&1 
fi

rm -rf h3control
tar xzf h3control.tar.gz
bash h3control/h3control-console.sh --pid-file=$pidfile --binding=*:5000
