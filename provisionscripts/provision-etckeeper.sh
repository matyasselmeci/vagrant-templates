#!/bin/bash

rpm -q etckeeper || yum install -y -d1 etckeeper
rpm -q git || yum install -y -d1 git

git config --global --get user.name &> /dev/null || (
    git config --global user.name "root"
    git config --global user.email "root@$(hostname -f)"
)
(etckeeper init; etckeeper commit "initial commit"; etckeeper vcs gc) > /dev/null || :

