#### UPDATE 31 (1.30.785)
- Added control of **online cores**. 

#### UPDATE 30 (1.30.780)
- Default daemon managment changed to SystemD, if available. SysV Init (update-rc.d and chkconfig) are also supported.

#### UPDATE 29 (1.29.773)
- Added --pid-file option and `h3control-install-daemon.sh` updated.

#### UPDATE 28
- Fixed one-liner daemon instaler on Armbian

#### UPDATE 27 (1.27.748)
- Added "turn-off" button for hover process on **top processes** widget. Not yet available in public build.
- Added "flushing kernel buffers" visuals

#### UPDATE 26
- Added resizing to **top processes** widget

#### UPDATE 25
- Layout of the dashboard rearranged.
- Dashbord initialization accelerated.
- Added hostname to the dashboard title. 
- &laquo;**CPU usage**&raquo; widget improved: added visualization during offline and initialization. Fixed underflow and overflow in normal mode.
- Added description of network interfaces during http-server startup. Here is an example of normal output of startup:
```
$ ./h3control-console.sh
H3Control 1.25.734 is a console/daemon which
   * "Displays" temperature, frequency and usage via built-in http server.
   * Allows to control CPU & DDR frequency

Configuration by command line:
   * Url is http://*:5000
   * Warning: white-list isn't specified, so ip restrictions are absent
   * Logs are located in /tmp/h3control.logs
   * h3control http-server is binding to all these network adapters:
      - network 'eth0': 192.168.0.11, fe80::505f:83ff:fe19:fc6d%2
      - network 'lo': 127.0.0.1, ::1

HTTP server successefully has been started.
Press Ctlr-C to quit.
```

#### UPDATE 24 (1.24.632)
- Added &laquo;**OS Name**&raquo; to the dashboard.
- Added &laquo;**CPU Usage**&raquo; column to the top processes widget.
- Fixed top processes' columns width (1.24.674).

#### UPDATE 23.1 (1.23.563)
- Fixed h3control on ancient mono 3.2.8 (the first ARM-HF mono)

#### UPDATE 23 (1.23.559)
- Added whats-new/history feature. 
- Added &laquo;New version available&raquo; notification.
- Removed roundtrip to server during dashboard initialization. 
- Added handler of click on &laquo;Buffers and Cache&raquo;. It flushes kernel buffers :)

#### UPDATE 22
- Important fix 1.22.542. It fixes wierd rare incomplete initialization of dashboard during loading
- Fixed launchers (`h3control-console.sh` & `h3control-install-daemons.sh`)
- Building moved to github


#### UPDATE 21
- Improoved responsiblity of frequency control. E.g. gauges are updated immediately in response to click | tap on frequency. Intervals of refresh extended to `10s`.
- Dashboard is redesigned. All the widgets of dashboard fit on a tablet 1024x768 or above.
- Dashboard in disabled state (when H3-board is down) is also redesigned.
- Added **swap** utilization column to the list of the top processes widget.
- Added sorting choice for top processes list.
- Fixed permissions inside h3control.tar.gz


#### UPDATE 19 (1.19.386)
- LESS colors, LESS gradients, LESS blur
- Added preliminary &laquo;**top processes**&raquo; widget


#### UPDATE 18 (1.18.310)
- Fixed support of Fedora and OpenSUSE in `./h3control-install-daemon.sh` script.
- Added info about mono and OS into logs.


#### UPDATE 17
- Added logging: log are writing into /tmp/h3control.logs/, /var/log/h3control.logs/ or /var/tmp/h3control.logs depending on permissions to that folder. h3control automatically trims own old logs.
- Added optional password protection of changing frequency. Screenshot: h3control_v1.17_readonly_mode.  How Dow do we do it? First, encrypt password:
````
    $ ./h3control-console.sh -g=mySecret
    7D018BB3DF0E523692845AF1F27E992CE8A41650
````
Note, space before command above causes shell to eliminate the command from the history. By this way clear password will be stored nowhere. Finally, add parameter -p=7D018BB3DF0E523692845AF1F27E992CE8A41650 to h3control-console.sh or /etc/init.d/h3control daemon. For example:

````
    $ ./h3control-console.sh -p=7D018BB3DF0E523692845AF1F27E992CE8A41650 -b=*:5000
````
Without -p option behavior is the same as prev version - anybody from white-list, or anybody, could change frequency of an Orange PI


#### UPDATE 16 (1.16.255)
- Server side redesigned. Samart cache improoved according to best practice recommendations (if-modified-since, etag).
- UI wasn't changed, Ctrl-F5 is still required after upgrade.
- [1.16.256] Cache of js and css was agressively improoved in comparision with 1.16.255
- Added bug: Icons for mobile browsers were lost. Fixed in 1.16.260

#### UPDATE 15 (1.15.239)
- Added 'Rate Me' and version number on the dashboard. Five Stars are welcome

#### UPDATE 14 (1.14.225)
- Added Memory Usage (Ctrl-F5). Compatiblity with old IE on Windows XP restored.

#### UPDATE 12
- CPU Usage bar was rearranged
- Warning: IE on Windows XP isnt supported since 1.12 Sorry for that. Please use Chrome or Firefox on Windows XP

#### UPDATE 11 (1.11.180)
- Improved UI perfomance (Ctrl-F5). Owners of old smartphones/tablets should prize this update

#### UPDATE 10 (1.10.172)
- Added update speed selector: 0.5s, 1s, 2s or 5s

#### UPDATE 9 (1.9.166)
- Dependencies (jquery, bootstrap) moved from the internet to h3control distribution. So h3control app works without the internet since 1.9.166

#### UPDATE 8 (1.8.151):
- Added CPU usage bar. (Ctrl-F5)
- Fixed CPU usage bar for old IE (1.8.161)

#### UPDATE 7 (1.7.116):
- Fixed the vaule of the DDR RANGE
- Added H3 icons for mobile & desktop browsers

#### UPDATE 6
- Added versioning during build. Current version is 1.6.102.
- Added h3control-install-daemon.sh to the tarball, default deployment path of the daemon is $HOME/bin/h3control
- Improved handling of `/etc/init.d/h3control stop`


#### UPDATE 5:
- Added 60 Mhz choice of a frequency


#### UPDATE 4: 
- Added command line **parameters** of http server and ip's white-list configuration:
````
~>./h3control-console --help
    -b, --binding=VALUE         HTTP binding, e.g. ip:port, default is *:5000
    -w, --white-list=VALUE      Comma separated IPs, default or empty arg turns restrictions off
    -v, --version               Show version
    -h, -?, --help              Display this help
    -n, --nologo                Hide logo
````

#### UPDATE 3:
- **Control** CPU frequency

#### UPDATE 2: 
- Added user defined **limits** of CPU & DDR frequency

#### FIRST Version:
![first version](https://github.com/devizer/h3control-bin/raw/master/images/h3control-first.jpg   "h3control first version")
