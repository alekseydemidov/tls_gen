# SSL/TLS generator

This script generates self signed certificate with custom ca and SAN record

# Using:

Pretty easy:   
edit config file  
edit variables in run.sh   
execute ./run.sh

# Result:

CA.crt, CA.key, client.csr, client.crt, client.key, client.pem

Update notes:

- 24 Oct 19: added extendedKeyUsage to certificate has beed passed in Chrome for MacOS Catalina (Fixing Errors: NET::ERR_CERT_REVOKED and NET::ERR_CERT_INVALID)

