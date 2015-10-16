#!/bin/bash

interface=$(ip link | grep '^[0-9]*: \(en\|eth\)' | awk '{print $2}' | cut -d: -f1 | head -n 1)
ipaddr=$(ip -4 addr show $interface | grep inet | awk '{print $2}' | cut -d/ -f1)

printf "%s   %s\n" $ipaddr $(cat /etc/hostname) >> /etc/hosts

yum install -y dnsmasq
systemctl enable dnsmasq
systemctl start dnsmasq

