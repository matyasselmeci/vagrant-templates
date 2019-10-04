#!/bin/bash


yum install -y epel-release
yum install -y buildah shadow-utils podman podman-docker

echo "user.max_user_namespaces=10000" > /etc/sysctl.d/99-namespaces.conf
sysctl user.max_user_namespaces=10000

touch /etc/sub{u,g}id
usermod --add-subuids 10000-75535 vagrant
usermod --add-subgids 10000-75535 vagrant

