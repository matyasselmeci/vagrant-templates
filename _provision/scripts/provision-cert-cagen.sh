#!/bin/bash

yum install -d1 -y osg-ca-generator

osg-ca-generator --expire-days=365 --force

