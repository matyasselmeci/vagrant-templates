#!/bin/bash

yum install -d1 -y osg-test

osg-test -a --no-cleanup --no-tests --hostcert

