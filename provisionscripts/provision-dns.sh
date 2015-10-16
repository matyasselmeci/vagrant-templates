#!/bin/bash

get_redhat_release () {
    # provided by Tim C
    sed -e 's/^[^0-9]*//' -e 's/\..*$//' /etc/redhat-release
}


interface=$(ip link | grep '^[0-9]*: \(en\|eth\)' | awk '{print $2}' | cut -d: -f1 | head -n 1)
ipaddr=$(ip -4 addr show $interface | grep inet | awk '{print $2}' | cut -d/ -f1)

printf "%s   %s\n" $ipaddr $(cat /etc/hostname) >> /etc/hosts

# dnsmasq instructions adapted from https://wiki.archlinux.org/index.php/Dnsmasq

yum install -y dnsmasq

echo 'listen-address=127.0.0.1' >> /etc/dnsmasq.conf

if [[ $(get_redhat_release) == 7 ]]; then

    echo 'dns=dnsmasq' >> /etc/NetworkManager/NetworkManager.conf
    # EL7 uses NetworkManager

    systemctl restart NetworkManager

elif [[ $(get_redhat_release) == 6 ]]; then

    echo 'prepend domain-name-servers 127.0.0.1;' >> /etc/dhclient.conf

    hostname -F /etc/hostname

    dhclient

fi

