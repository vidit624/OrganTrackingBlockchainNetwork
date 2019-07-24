
#!/bin/bash
fabric-ca-client enroll  -u https://admin:adminpw@ca.wbrta.gov.in:7054 --tls.certfiles /etc/hyperledger/fabric-ca-server-config/ca.wbrta.gov.in-cert.pem 
fabric-ca-client affiliation add wbrta  -u https://admin:adminpw@ca.wbrta.gov.in:7054 --tls.certfiles /etc/hyperledger/fabric-ca-server-config/ca.wbrta.gov.in-cert.pem 
