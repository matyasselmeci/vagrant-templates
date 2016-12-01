#!/bin/bash

utils_root=/usr/local/bin
utils_path=$utils_root/utils

yum install -y -d1 git zsh

echo "export PATH=$utils_path:\$PATH" > /etc/profile.d/utils.sh
echo "[ -d $utils_path/shellfn ] && for x in $utils_path/shellfn/*.sh; do . \$x || : ; done" >> /etc/profile.d/utils.sh
echo "setenv PATH $utils_path:\$PATH" > /etc/profile.d/utils.csh

pushd $utils_root
git clone http://pages.cs.wisc.edu/~matyas/utils.git
for script in mr vcsh; do
    if wget http://pages.cs.wisc.edu/~matyas/$script; then
        chmod +x $script
    fi
done
popd

cd ~
git clone http://pages.cs.wisc.edu/~matyas/newshell.git
./newshell/install.sh ~

cd ~vagrant
git clone http://pages.cs.wisc.edu/~matyas/newshell.git
./newshell/install.sh ~vagrant
chown -R vagrant:vagrant ~vagrant

if [[ -x /bin/zsh ]]; then
    chsh -s /bin/zsh root
    chsh -s /bin/zsh vagrant
fi

#first_if=$($utils_path/list-eth-interfaces | head -n 1)
#if [[ $? == 0 && -n $first_if ]]; then
#    ipaddr=$($utils_path/get-ip-address $first_if)
#    if [[ $? == 0 && -n $ipaddr ]]; then
#        echo "$ipaddr `cat /etc/hostname`" >> /etc/hosts
#    fi
#fi

