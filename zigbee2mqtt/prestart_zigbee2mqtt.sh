#!/bin/bash

# add devfs rules to allow USB devices to be seen from within domoticz
if ! grep -q "devfsrules_jail=5" /etc/devfs.rules; then
    cat <<"EOF" >>  /etc/devfs.rules

[devfsrules_jail=5]
add include $devfsrules_hide_all
add include $devfsrules_unhide_basic
add include $devfsrules_unhide_login
add path zfs unhide
add path 'tty*' unhide
add path 'ugen*' unhide
add path 'cu*' unhide
add path 'usb/*' unhide
EOF
    /usr/sbin/service devfs restart
fi