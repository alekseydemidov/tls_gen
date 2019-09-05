#!/bin/bash

### Put variable here###################################################################################
ROOTCA=rootCA           #filename CA certificate
DAYS=3650               #how long certs valid
CERT_NAME=haproxy       #filename certificate
SAN=IP:127.0.0.1        #subjectAltName

########################################################################################################
rm -rf $ROOTCA.* $CERT_NAME.*
echo " Generate CA key: "
openssl genrsa -des3 -out $ROOTCA.key 4096
echo " Generate CA certificate: "
openssl req -x509 -new -config config -nodes -key $ROOTCA.key -sha256 -days $DAYS -out $ROOTCA.crt
echo ""
echo "Generate Client key:"
openssl genrsa -out $CERT_NAME.key 2048
echo "Generate certificate request:"
#openssl req -new -config config -extensions req_ext  -key $CERT_NAME.key -out $CERT_NAME.csr
openssl req -new -reqexts SAN -config <(cat config <(printf "\n[SAN]\nsubjectAltName="$SAN)) -key $CERT_NAME.key -out $CERT_NAME.csr
openssl req -in $CERT_NAME.csr -noout -text
echo "Generate Client certificate"
openssl x509 -req -extfile <(printf "subjectAltName="$SAN ) -in $CERT_NAME.csr -CA $ROOTCA.crt -CAkey $ROOTCA.key -CAcreateserial -out $CERT_NAME.crt -days $DAYS -sha256
openssl x509 -in $CERT_NAME.crt -noout -text
echo ""
echo "Generate PEM certificate"
cat $CERT_NAME.crt $CERT_NAME.key > $CERT_NAME.pem
echo "Completed!"
########################################################################################################
