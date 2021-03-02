#!/bin/bash

function get_tty () {
    local vendor="${1}"
    local product="${2}"
    # return the tty{} value, eg; U2
    sysctl dev.umodem | grep "vendor=${vendor} product=${product}" | sed -r 's/.*ttyname=([^\s]+) .*/\1/'
}

function get_tty_2 () {
    local vendor="${1}"
    local product="${2}"
    # return the tty{} value, eg; U2
    sysctl dev.uslcom | grep "vendor=${vendor} product=${product}" | sed -r 's/.*ttyname=([^\s]+) .*/\1/'
}

function create_symlink () {
    local source="${1}"
    # failsafe
    if [ "${source}" == 'tty' ]; then return; fi
    local target="/mnt/systempool/iocage/jails/Zigbee2MQTT/root/dev/${2}"
    if [ -e "${target}" ]; then rm -f "${target}"; fi
    ln -s "${source}" "${target}"
}

# rflink is an arduino mega
create_symlink "tty$(get_tty '0x2341' '0x0010')" "ttyUrflink"

# zigbee is a Texas Instrument CC2531
create_symlink "tty$(get_tty '0x0451' '0x16a8')" "ttyUzigbee2531"

# zigbee is a Texas Instrument CC2652rb
create_symlink "tty$(get_tty_2 '0x10c4' '0xea60')" "ttyUzigbee2652"

# zwave is a Z-Stick Gen 5
# note: it needs the 'cua' device in domoticz, not the tty device
create_symlink "cua$(get_tty '0x0658' '0x0200')" "cuaUzwave"

#sysctl dev.uslcom | grep "vendor=0x10c4 product=0xea60" | sed -r 's/.*ttyname=([^\s]+) .*/\1/'
