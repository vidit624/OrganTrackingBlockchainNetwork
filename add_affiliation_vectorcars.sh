
#!/bin/bash
fabric-ca-client enroll  -u https://admin:adminpw@ca.vectorcars.com:7054 --tls.certfiles /etc/hyperledger/fabric-ca-server-config/ca.vectorcars.com-cert.pem 
fabric-ca-client affiliation add vectorcars  -u https://admin:adminpw@ca.vectorcars.com:7054 --tls.certfiles /etc/hyperledger/fabric-ca-server-config/ca.vectorcars.com-cert.pem 
