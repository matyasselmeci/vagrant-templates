#!/bin/bash

get_redhat_release () {
    # provided by Tim C
    sed -e 's/^[^0-9]*//' -e 's/\..*$//' /etc/redhat-release
}

enablerepo () {
    reponame=$1
    repofile=${2:-$1}

    sed -i '/\['$reponame'\]/,/\[.*\]/s/enabled=0/enabled=1/' /etc/yum.repos.d/${repofile}.repo
}

rhel=$(get_redhat_release)

rpm -U https://dl.fedoraproject.org/pub/epel/epel-release-latest-${rhel}.noarch.rpm
rpm -U http://repo.grid.iu.edu/osg/3.3/osg-3.3-el${rhel}-release-latest.rpm

# enable some repos
enablerepo epel
if [[ $rhel == 6 ]]; then
    enablerepo osg-testing osg-el6-testing
    enablerepo osg-minefield osg-el6-minefield
elif [[ $rhel == 7 ]]; then
    enablerepo osg-testing
    enablerepo osg-minefield
fi
# disable gpgcheck on all minefield repos
sed -i 's/gpgcheck=1/gpgcheck=0/' /etc/yum.repos.d/osg-*minefield.repo

yum install --skip-broken -d1 -y \
    bash-completion \
    deltarpm \
    emacs-nox \
    gdb \
    git \
    git-svn \
    mailx \
    make \
    man \
    mc \
    rcs \
    rpmconf \
    screen \
    subversion \
    sudo \
    tmux \
    vim-enhanced \
    yum-fastestmirror \
    yum-priorities \
    yum-utils

rm -f /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Debug-7

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-* || :

