#!/bin/bash

interface=$(ip link | grep '^[0-9]*: \(en\|eth\)' | awk '{print $2}' | cut -d: -f1 | head -n 1)
ipaddr=$(ip -4 addr show $interface | grep inet | awk '{print $2}' | cut -d/ -f1)

printf "%s   %s\n" $ipaddr $(cat /etc/hostname) >> /etc/hosts

# dnsmasq instructions adapted from https://wiki.archlinux.org/index.php/Dnsmasq

yum install -y dnsmasq

echo 'listen-address=127.0.0.1' >> /etc/dnsmasq.conf

# EL7 uses NetworkManager
# This is a ghetto way of editing a specific section in a config file
perl -i.bak -lne '
    BEGIN {
        $in_main = 0;
        $START_OF_MAIN = qr{\[main\]};
        $NEW_SECTION = qr{\[.+\]};
    }
    if ($_ =~ $START_OF_MAIN) {
        $in_main = 1;
        print $_;
        print "dns=dnsmasq";
        next;
    } elsif ($in_main && $_ =~ $NEW_SECTION) {
        $in_main = 0;
    }

    unless (/^\s*dns\s*=/ && $in_main) {
        print $_;
    }
'  /etc/NetworkManager/NetworkManager.conf

systemctl restart NetworkManager

