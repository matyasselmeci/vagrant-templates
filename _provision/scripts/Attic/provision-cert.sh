#!/bin/bash

set -e

if [[ `id -u` != 0 ]]; then
    echo "Must be root for this"
    exit 1
fi

patchdir=/vagrant/provisionscripts

# as root
cd /root
mkdir -p certs
cd certs

rpm -q subversion &> /dev/null || yum install -d1 -y subversion > /dev/null

# Get the files from subversion from a fixed revision (so the patch applies)
for f in OSG-Test-CA.namespaces \
         OSG-Test-CA.signing_policy \
         ca-generate-certs \
         openssl-cert-extensions-template.conf \
         openssl-config.patch
do
    svn cat  https://vdt.cs.wisc.edu/svn/new-test/trunk/vm-test-runs/$f@'{2015-10-23}'  >  $f
done


# Patch the newly downloaded files so the CA is named "OSG Test Host CA"
for patchfile in "$patchdir"/cert-0*.patch
do
    patch -p1 -i "$patchfile"
done

# in case patch(1) does not do renames:
# rename OSG-Test-CA.namespaces => OSG-Test-Host-CA.namespaces (70%)
# rename OSG-Test-CA.signing_policy => OSG-Test-Host-CA.signing_policy (74%)
[[ -f OSG-Test-Host-CA.namespaces ]] || mv OSG-Test-CA.namespaces OSG-Test-Host-CA.namespaces
[[ -f OSG-Test-Host-CA.signing_policy ]] || mv OSG-Test-CA.signing_policy OSG-Test-Host-CA.signing_policy



chmod +x ca-generate-certs
./ca-generate-certs $(hostname -f)

mkdir -p /etc/grid-security/certificates

certhash=$(openssl x509 -in OSG-Test-Host-CA.pem -noout -hash)

for file in OSG-Test-Host-CA.{r0,namespaces,signing_policy}; do
    install -m 0644 -o root -g root $file  /etc/grid-security/certificates/
    ln -snf $file  /etc/grid-security/certificates/${certhash}.${file#*.}
done

install -m 0644 -o root -g root OSG-Test-Host-CA.pem  /etc/grid-security/certificates
ln -snf OSG-Test-Host-CA.pem  /etc/grid-security/certificates/${certhash}.0

install -m 0600 -o root -g root hostkey.pem  /etc/grid-security/
install -m 0644 -o root -g root hostcert.pem /etc/grid-security/

