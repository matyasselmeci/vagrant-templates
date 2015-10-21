#!/bin/bash

utils_root=/usr/local/bin
utils_path=$utils_root/utils

rpm -q git || yum install -y git
echo "export PATH=$utils_path:\$PATH" > /etc/profile.d/utils.sh
echo "setenv PATH $utils_path:\$PATH" > /etc/profile.d/utils.csh

pushd $utils_root
git clone http://pages.cs.wisc.edu/~matyas/utils.git
popd

#first_if=$($utils_path/list-eth-interfaces | head -n 1)
#if [[ $? == 0 && -n $first_if ]]; then
#    ipaddr=$($utils_path/get-ip-address $first_if)
#    if [[ $? == 0 && -n $ipaddr ]]; then
#        echo "$ipaddr `cat /etc/hostname`" >> /etc/hosts
#    fi
#fi

