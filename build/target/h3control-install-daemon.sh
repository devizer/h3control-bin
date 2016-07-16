#!/bin/bash
command -v mono >/dev/null || ( echo 'mono NOT FOUND. Check "mono" executable is installed and present in the $PATH' ; exit 1 )
command -v dirname >/dev/null || ( echo 'dirname NOT FOUND. Check "dirname" executable is present in the $PATH' ; exit 1 )
command -v pwd >/dev/null || ( echo 'pwd NOT FOUND. Check "pwd" executable is present in the $PATH' ; exit 1 )
command -v mcs >/dev/null || ( echo 'mcs NOT FOUND. Check "mcs" executable is present in the $PATH' ; exit 1 )
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

mkdir -p $HOME/bin

# ***********************************************
# * The line below specifies deployment folder. *
# ***********************************************
cd $HOME/bin
wget -O h3control.tar.gz --no-check-certificate https://github.com/devizer/h3control-bin/raw/master/public/h3control.tar.gz
killall -q -12 mono || echo "h3control isn't running"
rm -rf h3control
tar xzf h3control.tar.gz
rm h3control.tar.gz
cd h3control 
./h3control-console.sh --help

deploydir=`pwd`

cat << _INIT_D_ > /tmp/h3control.tmp
#!/bin/bash
# /etc/init.d/h3control

### BEGIN INIT INFO
# Provides:          h3control
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: h3control daemon support script 
# Description:       A simple script which will start / stop a h3control daemon during a boot / shutdown.
### END INIT INFO

# this line catch the current PATH into startup environment
export PATH="$PATH"

# Carry out specific functions when asked to by the system
case "\$1" in
  start)
    echo "Starting h3control"
    # run application you want to start
    mono --desktop "$deploydir/bin/H3Control.exe" 1>/dev/null 2>/dev/null &
    ;;
  version)
    echo h3control daemon version is \`mono $deploydir/bin/H3Control.exe --version\` || echo h3control daemon is unavailable. please reinstall.
    ;;
  stop)
    echo "Stopping h3control"
    # kill application you want to stop
    killall -q -12 mono || echo "h3control isn't running"
    ;;
  *)
    echo "Usage: /etc/init.d/h3control {start|stop|version}"
    exit 1
    ;;
esac

exit 0
_INIT_D_

chmod +x /tmp/h3control.tmp
sudo cp /tmp/h3control.tmp /etc/init.d/h3control
command -v update-rc.d >/dev/null && sudo update-rc.d h3control remove
command -v update-rc.d >/dev/null && sudo update-rc.d h3control defaults
command -v chkconfig   >/dev/null && sudo chkconfig --level 2345 h3control off
command -v chkconfig   >/dev/null && sudo chkconfig --level 2345 h3control on
/etc/init.d/h3control version
sudo /etc/init.d/h3control start
sleep 4
