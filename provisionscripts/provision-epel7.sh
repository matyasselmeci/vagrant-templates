#!/bin/bash

rpm -U https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# enable some repos
for repo_name in epel `#osg-testing osg-minefield` ; do
    sed -i '/\['$repo_name'\]/,/\[.*\]/s/enabled=0/enabled=1/' /etc/yum.repos.d/$repo_name.repo
done

yum install -y -d1 yum-priorities
yum install -y -d1 deltarpm || :

yum install --skip-broken -y -d1 bash-completion emacs-nox gdb git git-svn make mc rcs rpm rpmconf screen subversion sudo tmux vim-enhanced yum-utils yum-fastestmirror

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-* || :

