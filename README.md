# h3control-bin
h3control is a console/daemon for H3 based PI board. It displays temperature, frequency and usage via built-in http server. It allows to control min/max cpu and ddr frequency. This repository holds installers of h3control only

## prerequisite
The only prerequisite is mono with .NET 4.5 runtime. By the way, first mono (version 3.2), which supports ARM hard float arch, exposes .NET 4.5 runtime.

## launch using h3control-console.sh
Step 1: wget & run the *latest* h3control-console.sh
```bash
cd /tmp
wget -O h3control.tar.gz https://github.com/devizer/h3control-bin/raw/master/public/h3control.tar.gz
killall -q -12 mono || echo "stop of h3control is skipped"
rm -rf h3control
tar xzf h3control.tar.gz
h3control/h3control-console.sh --binding=*:5000
# this code also suitable for upgrade
```

Step 2: Switch to your `Firefox` | `Chrome` | `IE` | `Opera` | `Safary`, and check http://orange-pi-address:5000/ works fine. 

Step 3: Return to your PI board and press Ctrl-C to stop consolas h3control. Install h3control daemon to start h3control during build
```
h3control/h3control-install-daemon.sh
```

## install/update h3control daemon using `h3control-install-daemon.sh`
```bash
wget -q -O - https://github.com/devizer/h3control-bin/raw/master/build/target/h3control-install-daemon.sh | bash
```

### Screenshot: h3control just works
![h3control in normal](https://github.com/devizer/h3control-bin/raw/master/images/h3control_v1.21_normal.jpg "h3control in normal")


### Screenshot: h3control in readonly mode
![h3control in readonly mode](https://github.com/devizer/h3control-bin/raw/master/images/h3control_v1.21_readonly.jpg "h3control in readonly mode")


### Screenshot: h3control is offline
![h3control is offline](https://github.com/devizer/h3control-bin/raw/master/images/h3control_v1.21_offline.jpg "h3control is offline")

