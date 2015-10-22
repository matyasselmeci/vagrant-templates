#!/bin/bash

# as root
cd /root
mkdir -p certs
cd certs

wget -B https://vdt.cs.wisc.edu/svn/new-test/trunk/vm-test-runs/ -i- <<EOF
OSG-Test-CA.namespaces
OSG-Test-CA.signing_policy
ca-generate-certs
openssl-cert-extensions-template.conf
openssl-config.patch
EOF

chmod +x ca-generate-certs
./ca-generate-certs `hostname -f`

mkdir -p /etc/grid-security/certificates
mv -f OSG-Test-CA.pem OSG-Test-CA.r0         /etc/grid-security/certificates/
install -m 0600 -o root -g root hostkey.pem  /etc/grid-security/
install -m 0644 -o root -g root hostcert.pem /etc/grid-security/

