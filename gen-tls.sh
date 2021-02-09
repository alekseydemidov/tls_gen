#!/bin/bash

if [[ "${1}" == '-h' || "${1}" == '--help' ]]; then
  cat >&2 <<"EOF"
gen-tls.sh generates self signed certificate with custom CA and SAN record
USAGE:
  gen-tls.sh ROOTCA CERT_NAME DAYS ROOTCA_REQ
EXAMPLE
  gen-tls.sh rootCA http-server 365 true
  would generate:
  rootCA.* - CA certificate files
  http-server.* - client cerificate files signed by rootCA certificate
  with certificate TTL = 365
  ROOTCA_REQ: True - generate CA certificate; False - using existed here rootCA
EOF
   exit 1
fi
### Setup variable here################################################################################

#ROOTCA_REQ=True         #Generate rootCA certificate?
#ROOTCA=rootCA           #filename CA certificate
#DAYS=3650                    #how long certs valid
#CERT_NAME=cert_dashboard     #filename certificate
#SAN=IP:10.202.180.100        #subjectAltName
#SAN=DNS:os.bell-cloud.ml,DNS:openstack.bell-cloud.ml
ROOTCA=${1:-rootCA}
CERT_NAME=${2:-server}
DAYS=${3:-3650}
ROOTCA_REQ=${4:-False}

#######################################################################################################
if [[ $ROOTCA_REQ != False ]]; then
	rm -rf $ROOTCA.* $CERT_NAME.*
	echo " Generate CA key: "
	openssl genrsa -out $ROOTCA.key 4096
	echo " Generate CA certificate: "
	openssl req -x509 -new -config config -nodes -key $ROOTCA.key -sha256 -days $DAYS -out $ROOTCA.crt
fi
echo ""
echo "Generate Client key:"
openssl genrsa -out $CERT_NAME.key 2048
echo "Generate certificate request:"
openssl req -new -config config -extensions req_ext -key $CERT_NAME.key -out $CERT_NAME.csr
openssl req -in $CERT_NAME.csr -noout -text
echo "Generate Client certificate"
SAN=`cat config | grep -Ev '^#' |grep -E 'IP|DNS' | tr -d ' ' |tr '\n' ',' | sed 's/=/:/g' |sed 's/.$//'`
echo $SAN; echo
openssl x509 -req -extfile <(printf "extendedKeyUsage=serverAuth \nsubjectAltName=$SAN" ) -in $CERT_NAME.csr -CA $ROOTCA.crt -CAkey $ROOTCA.key -CAcreateserial -out $CERT_NAME.crt -days $DAYS -sha256
openssl x509 -in $CERT_NAME.crt -noout -text
echo ""
echo "Generate PEM certificate"
cat $CERT_NAME.crt $CERT_NAME.key > $CERT_NAME.pem
echo "Completed!"
########################################################################################################
