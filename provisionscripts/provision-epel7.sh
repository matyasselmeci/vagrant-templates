#!/bin/bash

rpm -U https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
#rpm -U http://repo.grid.iu.edu/osg/3.3/el7/development/x86_64/osg-release-3.3-1.osg33.el7.noarch.rpm

# enable some repos
for repo_name in epel `#osg-testing osg-minefield` ; do
    sed -i '/\['$repo_name'\]/,/\[.*\]/s/enabled=0/enabled=1/' /etc/yum.repos.d/$repo_name.repo
done
# disable others
#for repo_name in osg; do
#    sed -i '/\['$repo_name'\]/,/\[.*\]/s/enabled=1/enabled=0/' /etc/yum.repos.d/$repo_name.repo
#done
## disable gpgcheck on all minefield repos
#sed -i 's/gpgcheck=1/gpgcheck=0/' /etc/yum.repos.d/osg-minefield.repo

yum install -y -d1 yum-priorities
yum install -y -d1 deltarpm || :

yum install --skip-broken -y -d1 bash-completion emacs-nox gdb git git-svn make mc rcs rpm rpmconf screen subversion sudo tmux vim-enhanced yum-utils yum-fastestmirror

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-* || :

