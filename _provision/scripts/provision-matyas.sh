#!/bin/bash

utils_root=/usr/local/bin
utils_path=$utils_root/utils:$utils_root/utils/tiny
newshell_path=/usr/local/share/newshell

yum install -y -d1 git zsh wget

echo "export PATH=$utils_path:\$PATH" > /etc/profile.d/utils.sh
echo "[ -d $utils_path/shellfn ] && for x in $utils_path/shellfn/*.sh; do . \$x || : ; done" >> /etc/profile.d/utils.sh
echo "setenv PATH $utils_path:\$PATH" > /etc/profile.d/utils.csh

pushd $utils_root
#git clone http://pages.cs.wisc.edu/~matyas/utils.git
git clone https://git.doit.wisc.edu/MATYAS/publicutils.git
#for script in mr vcsh; do
#    if wget http://pages.cs.wisc.edu/~matyas/$script; then
#        chmod +x $script
#    fi
#done
popd

#git clone http://pages.cs.wisc.edu/~matyas/newshell.git $newshell_path
git clone https://git.doit.wisc.edu/MATYAS/newshell.git $newshell_path
$newshell_path/install.sh ~
$newshell_path/install.sh ~vagrant

wget -nc -O ~/.screenrc http://pages.cs.wisc.edu/~matyas/screenrc
wget -nc -O ~vagrant/.screenrc http://pages.cs.wisc.edu/~matyas/screenrc

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

