#!/bin/bash

rpm -q etckeeper || yum install -y -d1 etckeeper
rpm -q git || yum install -y -d1 git

(cd /etc; etckeeper init; git commit -m "initial commit") || :

