#!/bin/bash

yum install -y epel-release
yum install -y buildah shadow-utils podman podman-docker

echo "user.max_user_namespaces=10000" > /etc/sysctl.d/99-namespaces.conf
sysctl user.max_user_namespaces=10000

touch /etc/sub{u,g}id
# need 200 for centos:7 and centos:8
# There doesn't seem to be a limit -- each user on my laptop uses 65k --
# so might as well use 1000.
# if you get lchown invalid argument errors, increase this,
# log out, and log back in
usermod --add-subuids 10000-10999 vagrant
usermod --add-subgids 10000-10999 vagrant

