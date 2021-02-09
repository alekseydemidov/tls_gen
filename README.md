# SSL/TLS generator

This script generates self signed certificate with custom ca and SAN record

# Using:

Pretty easy:   
edit config file  

```gen-tls.sh CA http-server 365 true```  
  would generate:  
  rootCA.* - CA certificate files  
  http-server.* - client cerificate files signed by rootCA certificate  
  with certificate TTL = 365  
  ROOTCA_REQ: True - generate CA certificate; False - using existed here rootCA  

# Result:

CA.crt, CA.key, http-server.csr, http-server.crt, http-server.key, http-server.pem

Update notes:

- 09 Feb 21: added parametrized
- 24 Oct 19: added extendedKeyUsage to certificate has beed passed in Chrome for MacOS Catalina (Fixing Errors: NET::ERR_CERT_REVOKED and NET::ERR_CERT_INVALID)

