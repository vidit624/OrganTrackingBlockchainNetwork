
#!/bin/bash
fabric-ca-client enroll  -u https://admin:adminpw@ca.jamesdistributers.net:7054 --tls.certfiles /etc/hyperledger/fabric-ca-server-config/ca.jamesdistributers.net-cert.pem 
fabric-ca-client affiliation add jamesdistributers  -u https://admin:adminpw@ca.jamesdistributers.net:7054 --tls.certfiles /etc/hyperledger/fabric-ca-server-config/ca.jamesdistributers.net-cert.pem 
