#!/bin/bash

utils_root=/usr/local/bin
utils_path=$utils_root/utils:$utils_root/utils/tiny
newshell_path=/usr/local/share/newshell

yum install -y -d1 git zsh curl

echo "export PATH=$utils_path:\$PATH" > /etc/profile.d/utils.sh
echo "[ -d $utils_path/shellfn ] && for x in $utils_path/shellfn/*.sh; do . \$x || : ; done" >> /etc/profile.d/utils.sh
echo "setenv PATH $utils_path:\$PATH" > /etc/profile.d/utils.csh

pushd $utils_root
curl -Ls https://git.doit.wisc.edu/MATYAS/publicutils/-/archive/master/publicutils-master.tar.gz | tar -xz && \
    mv publicutils-master* utils
popd

mkdir -p $(dirname $newshell_path)
curl -Ls https://git.doit.wisc.edu/MATYAS/newshell/-/archive/master/newshell-master.tar.gz | tar -xz && \
    mv newshell-master* $newshell_path
$newshell_path/install.sh ~
$newshell_path/install.sh ~vagrant

curl -Lso ~/.screenrc http://pages.cs.wisc.edu/~matyas/screenrc
cp ~/.screenrc ~vagrant/.screenrc

chown -R vagrant: ~vagrant

if [[ -x /bin/zsh ]]; then
    chsh -s /bin/zsh root
    chsh -s /bin/zsh vagrant
fi

