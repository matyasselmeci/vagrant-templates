#!/bin/bash

yum install -d1 -y etckeeper git

git config --global --get user.name &> /dev/null || (
    git config --global user.name "root"
    git config --global user.email "root@$(hostname -f)"
)
(etckeeper init; etckeeper commit "initial commit"; etckeeper vcs gc) > /dev/null || :

