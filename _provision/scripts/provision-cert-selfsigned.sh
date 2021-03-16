#!/bin/bash

/bin/echo -e "\n\n\n\n\n"`hostname`"\n" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/pki/tls/private/localhost.key -out /etc/pki/tls/certs/localhost.crt > /dev/null 2>&1
chown root:root /etc/pki/tls/certs/localhost.crt /etc/pki/tls/private/localhost.key
chmod 644 /etc/pki/tls/certs/localhost.crt
chmod 600 /etc/pki/tls/private/localhost.key
cp /etc/pki/tls/certs/localhost.crt /etc/pki/ca-trust/source/anchors/localhost.pem
update-ca-trust extract

