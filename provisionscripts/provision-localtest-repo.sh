#!/bin/bash

cat > /etc/yum.repos.d/localtest.repo <<'__EOF__'
[localtest]
name=localtest
baseurl=file:///vagrant/repo
priority=1
enabled=1
gpgcheck=0
skip_if_unavailable = 1
keepcache = 0
__EOF__

mkdir -p /vagrant/repo

