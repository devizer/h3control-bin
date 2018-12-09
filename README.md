
# h3control-bin [![travis status](https://travis-ci.org/devizer/h3control.svg?branch=master)](https://travis-ci.org/devizer/h3control)  <img src='https://github.com/devizer/h3control-bin/blob/master/public/status.png?raw=true' width='199' height='32' style='float: right' alt='public' title='public'></img><img src='https://github.com/devizer/h3control-bin/blob/master/staging/status.png?raw=true' width='199' height='32' style='float: right' alt='staging' title='staging'></img>
h3control is a console/daemon for H3 based PI boards. It displays temperature, frequency and usage via built-in http server. It allows to control min/max CPU and DDR frequency. This repository holds installers of h3control only

Web app is smoothly animated, supports wide range of browsers, including builtin browsers at many-years-old mobile devices.  Also it disables gauges when PI-board is down.

## prerequisite
The only mandatory prerequisite is mono with .NET 4.5 runtime. By the way, first mono (version 3.2), which supports ARM hard float arch, exposes .NET 4.5 runtime.

All the another prerequisites are optional 
- Optional prerequisites for launcher are `/bin/bash`, `dirname` and `pwd`. They are required by `h3control-console.sh` and `h3control-install-daemon.sh`. Without them h3control could be started using `mono H3Control.exe --binding=*:5000` command

- **CPU usage** and **top processes** widgets rely on `/proc` filesystem and linux kernel 3+. Optional

- **Top processes** widget relies upon `ps` command in the PATH. Optional

- Embedded http-server requires `mcs` for MS Razor engine in the PATH. `mcs` is builtin mono's command, as well as `mono` command

- **Bell**-button (new version available notification) requires internet connection on your PI-board. h3control each 5 minutes fetches few bytes from github for checking new versions. Internet connection on a PI board is optional.

By the way, h3control uses embedded http-server, so external http servers are not required.

Finally, changing CPU or DDR frequency requires advanced privileges.

## installation
Short instruction: extract [public/h3control.tar.gz](https://github.com/devizer/h3control-bin/raw/master/public/h3control.tar.gz) and launch `h3control-console.sh` or `h3control-install-daemon.sh` or `mono H3Control.exe --binding=*:5000`

Shorter option 1 (launch h3control in terminal)
```bash
wget -q -nv -O - https://github.com/devizer/h3control-bin/raw/master/public/h3control.sh | bash
```

Shorter option 2 (install h3control daemon and launch it)
```bash
wget -q -nv -O - https://github.com/devizer/h3control-bin/raw/master/public/h3control-install-daemon.sh | bash
```

Thats all. However its possible to launch so called ~~staging~~ version of h3control. Usually staging version works fine, but it MAY not be tested.
```bash
wget -q -nv -O - https://github.com/devizer/h3control-bin/raw/master/staging/h3control-staging.sh | bash
```

Consolas scripts download h3control.tar.gz into /tmp/h3control. h3control-install-daemon.sh script downloads h3control.tar.gz into $HOME/bin/h3control

## history
[WHATS-NEW.md](https://github.com/devizer/h3control-bin/blob/master/WHATS-NEW.md)

<a name="screenshots"></a>
### Screenshot: h3control just works
![h3control in normal](https://github.com/devizer/h3control-bin/raw/master/images/h3control_v1.31_normal.png "h3control in normal")


### Screenshot: h3control in readonly mode
![h3control in readonly mode](https://github.com/devizer/h3control-bin/raw/master/images/h3control_v1.25_readonly.png "h3control in readonly mode")


### Screenshot: h3control is offline
![h3control is offline](https://github.com/devizer/h3control-bin/raw/master/images/h3control_v1.25_offline.png "h3control is offline")

### Screenshot: first version 0.1, not available now
<center><img src='https://github.com/devizer/h3control-bin/raw/master/images/h3control-first.jpg' alt='h3control first build' border='0' width='840px' height='541px' style='width:840px; height:541px'></img></center>


# status as svg? <img src='https://cdn.jsdelivr.net/gh/devizer/h3control-bin@master/staging/h3control-staging.svg?raw=true' width='199' height='32' style='float: right' alt='public' title='public'>
