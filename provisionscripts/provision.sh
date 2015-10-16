#!/bin/bash


for x in /vagrant/provision.d/*; do
    if [[ ! -x $x ]]; then
        echo $x not executable - skipping
    else
        $x || :
    fi
done

