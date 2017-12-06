#!/bin/bash
cd /tmp
wget --no-check-certificate -O h3control.tar.gz https://github.com/devizer/h3control-bin/raw/master/public/h3control.tar.gz

pidfile=/var/run/h3control.pid

# Stop Prev Version
sudo systemctl stop h3control >/dev/null 2>&1 || true
pid=$(cat $pidfile 2>/dev/null)
if [ -n "$pid" ]; then
  rm -f $pidfile >/dev/null 2>&1 || true
  sudo kill -12 $pid >/dev/null 2>&1 || true
else
  sudo killall -q -s 12 mono >/dev/null 2>&1 || true
fi

rm -rf h3control
tar xzf h3control.tar.gz
bash h3control/h3control-console.sh --pid-file=$pidfile --binding=*:5000
