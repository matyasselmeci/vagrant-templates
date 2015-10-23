#!/bin/bash

set -e

if [[ `id -u` != 0 ]]; then
    echo "Must be root for this"
    exit 1
fi

# as root
cd /root
mkdir -p certs
cd certs

rpm -q subversion &> /dev/null || yum install -y subversion > /dev/null

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
patch -p1 <<'__EOF__'
From f7243673a651c49c9bf4b5e0974b584147e03e11 Mon Sep 17 00:00:00 2001
From: Matyas Selmeci <matyas@cs.wisc.edu>
Date: Thu, 22 Oct 2015 17:40:24 -0500
Subject: [PATCH] Change name of CA to OSG Test Host CA

This will prevent it from conflicting with the OSG Test CA that osg-test
makes when it runs (for making the user cert for the vdttest user).
---
 OSG-Test-CA.namespaces => OSG-Test-Host-CA.namespaces         | 6 +++---
 OSG-Test-CA.signing_policy => OSG-Test-Host-CA.signing_policy | 4 ++--
 ca-generate-certs                                             | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)
 rename OSG-Test-CA.namespaces => OSG-Test-Host-CA.namespaces (70%)
 rename OSG-Test-CA.signing_policy => OSG-Test-Host-CA.signing_policy (74%)

diff --git a/OSG-Test-CA.namespaces b/OSG-Test-Host-CA.namespaces
similarity index 70%
rename from OSG-Test-CA.namespaces
rename to OSG-Test-Host-CA.namespaces
index 3fbfbb9..ad1bf2a 100644
--- a/OSG-Test-CA.namespaces
+++ b/OSG-Test-Host-CA.namespaces
@@ -1,11 +1,11 @@
 ##############################################################################
 #NAMESPACES-VERSION: 1.0
 #
 # @(#)xyxyxyxy.namespaces
-# CA alias    : OSG-Test-CA
+# CA alias    : OSG-Test-Host-CA
 #    subord_of: 
-#    subjectDN: /DC=org/DC=Open Science Grid/O=OSG Test/CN=OSG Test CA
+#    subjectDN: /DC=org/DC=Open Science Grid/O=OSG Test/CN=OSG Test Host CA
 #    hash     : xyxyxyxy
 #
-TO Issuer "/DC=org/DC=Open Science Grid/O=OSG Test/CN=OSG Test CA" \
+TO Issuer "/DC=org/DC=Open Science Grid/O=OSG Test/CN=OSG Test Host CA" \
   PERMIT Subject "/DC=org/DC=Open Science Grid/.*"
diff --git a/OSG-Test-CA.signing_policy b/OSG-Test-Host-CA.signing_policy
similarity index 74%
rename from OSG-Test-CA.signing_policy
rename to OSG-Test-Host-CA.signing_policy
index a276cbe..12a2d15 100644
--- a/OSG-Test-CA.signing_policy
+++ b/OSG-Test-Host-CA.signing_policy
@@ -1,4 +1,4 @@
-# OSG Test CA Signing Policy
-access_id_CA		X509	'/DC=org/DC=Open Science Grid/O=OSG Test/CN=OSG Test CA'
+# OSG Test Host CA Signing Policy
+access_id_CA		X509	'/DC=org/DC=Open Science Grid/O=OSG Test/CN=OSG Test Host CA'
 pos_rights		globus	CA:sign
 cond_subjects		globus	'"/DC=org/DC=Open Science Grid/*"'
diff --git a/ca-generate-certs b/ca-generate-certs
index 8857605..46edac8 100755
--- a/ca-generate-certs
+++ b/ca-generate-certs
@@ -7,21 +7,21 @@ fi
 hostname=${1:-'osg-test.localdomain'}
 echo "Generating CA certificate and host certificate for '$hostname'"
 
 INDEX_FILE=index.txt
 SERIAL_FILE=serial
-PRIVATE_KEY_FILE=OSG-Test-CA-private.pem
-CA_FILE=OSG-Test-CA.pem
+PRIVATE_KEY_FILE=OSG-Test-Host-CA-private.pem
+CA_FILE=OSG-Test-Host-CA.pem
 OPENSSL_CONFIG=openssl.config
-CA_SUBJECT='/DC=org/DC=Open Science Grid/O=OSG Test/CN=OSG Test CA'
+CA_SUBJECT='/DC=org/DC=Open Science Grid/O=OSG Test/CN=OSG Test Host CA'
 HOST_REQUEST=host-cert-request.pem
 HOST_REQ_PRIV=hostkey.pem
 HOST_CERT_SUBJECT="/DC=org/DC=Open Science Grid/O=OSG Test/OU=Services/CN=$hostname"
 SERIAL_NUMBER=A1B2C3D4E5F6
 DAYS=10
 CRL_NUMBER_FILE=crlnumber
-CRL_FILE=OSG-Test-CA.r0
+CRL_FILE=OSG-Test-Host-CA.r0
 
 # Clean up from previous run
 rm -f *.pem *.r0
 rm -f $INDEX_FILE
 rm -f $PRIVATE_KEY_FILE
-- 
2.4.6
__EOF__


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

