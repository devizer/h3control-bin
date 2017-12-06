#!/bin/bash
command -v mono >/dev/null || ( echo 'mono NOT FOUND. Check "mono" executable is installed and present in the $PATH' ; exit 1 )
command -v dirname >/dev/null || ( echo 'dirname NOT FOUND. Check "dirname" executable is present in the $PATH' ; exit 1 )
command -v pwd >/dev/null || ( echo 'pwd NOT FOUND. Check "pwd" executable is present in the $PATH' ; exit 1 )
# command -v mcs >/dev/null || ( echo 'mcs NOT FOUND. Check "mcs" executable is present in the $PATH' ; exit 1 )
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

mkdir -p $HOME/bin

# ********************************************************************
# * The line below specifies deployment folder and pidfile location. *
# ********************************************************************
cd $HOME/bin
pidfile=/var/run/h3control.pid

wget --no-check-certificate -O h3control.tar.gz --no-check-certificate https://github.com/devizer/h3control-bin/raw/master/public/h3control.tar.gz

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
rm h3control.tar.gz
cd h3control
./h3control-console.sh --help

deploydir=$(pwd)
monocmd=$(command -v mono)
killcmd=$(command -v kill)
bashcmd=$(command -v bash)

echo '#!'$bashcmd'
# /etc/init.d/h3control

### BEGIN INIT INFO
# Provides:          h3control
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: h3control daemon support script
# Description:       A simple script which will start / stop a h3control daemon during a boot / shutdown.
### END INIT INFO

# this line catch the current PATH into startup environment
export PATH="'$PATH'"
pidfile='$pidfile'

case "$1" in
  start)
    echo "Starting h3control"
    # logs are usually written to /tmp/h3control.logs/
    (nohup mono --desktop "'$deploydir'/bin/H3Control.exe" --pid-file=$pidfile --binding=*:5000 1>/dev/null 2>&1 ) &
    ;;
  version)
    echo h3control daemon version is `mono "'$deploydir'/bin/H3Control.exe" --version` || echo h3control daemon is unavailable. please reinstall.
    ;;
  stop)
    pid=$(cat $pidfile 2>/dev/null)
    if [ -n "$pid" ]; then
      # New h3control version
      echo Stopping h3control. Sending shutdown request to process $pid
      rm -f $pidfile >/dev/null 2>&1 || true
      kill -12 $pid >/dev/null 2>&1 || echo "h3control isn'"'"'t running"
    else
      # Old h3control version
      echo "Stopping h3control"
      killall -q -s 12 mono   >/dev/null 2>&1 || echo "h3control isn'"'"'t running"
    fi
    ;;
  *)
    echo "Usage: /etc/init.d/h3control {start|stop|version}"
    exit 1
    ;;
esac

exit 0
<<<<<<< HEAD
' | sudo tee /etc/init.d/h3control >/dev/null
sudo chmod +x /etc/init.d/h3control


echo '
[Unit]
Description=h3control is a console/daemon for H3 based PI boards. It displays temperature, frequency and usage via built-in http server. It allows to control min/max CPU and DDR frequency
Documentation=https://github.com/devizer/h3control-bin
After=network.target

[Service]
Type=simple
PIDFile=/var/run/h3control.pid
WorkingDirectory='$deploydir'/bin
User=root
Group=root
ExecStart='$monocmd $deploydir'/bin/H3Control.exe --pid-file=/var/run/h3control.pid --binding=*:5000
ExecStop='$killcmd' -12 $MAINPID
SuccessExitStatus=SIGKILL SIGUSR2
TimeoutSec=30
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target

' | sudo tee /etc/systemd/system/h3control.service >/dev/null

hasUpdateRc=""; hasChkConfig=""; hasSystemCtl=""
command -v update-rc.d >/dev/null && hasUpdateRc=true
command -v chkconfig >/dev/null && hasChkConfig=true
command -v systemctl >/dev/null && hasSystemCtl=true
echo ""
if [ -n "$hasUpdateRc" ]; then
  # debian derivaties
  echo "Configuring /etc/init.d/h3control init-script using update-rc.d tool"
  sudo rm -f /etc/systemd/system/h3control.service
  sudo update-rc.d -f h3control remove
  sudo update-rc.d h3control defaults
  /etc/init.d/h3control version
  sudo /etc/init.d/h3control start
  sleep 4
elif [ -n "$hasChkConfig" ]; then
  # suse and redhat derivates
  echo "Configuring /etc/init.d/h3control init-script using chkconfig tool"
  sudo rm -f /etc/systemd/system/h3control.service
  sudo chkconfig --level 2345 h3control off
  sudo chkconfig --level 2345 h3control on
  /etc/init.d/h3control version
  sudo /etc/init.d/h3control start
  sleep 4
elif [ -n "$hasSystemCtl" ]; then
  # another exotic linux/bsd
  echo "Configuring /etc/systemd/system/h3control.service unit using systemctl"
  sudo rm -f /etc/init.d/h3control
  sudo systemctl disable h3control >/dev/null 2>&1
  sudo systemctl enable h3control
  sudo systemctl start h3control
  sleep 4
else
  echo "Unable to install daemon. System should support one of theese command:
  update-rc.d
  or chkconfig
  or systemclt"
fi
exit;

