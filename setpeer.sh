
#!/bin/bash
export ORDERER_CA=/opt/ws/crypto-config/ordererOrganizations/carscm.net/msp/tlscacerts/tlsca.carscm.net-cert.pem

if [ $# -lt 2 ];then
	echo "Usage : . setpeer.sh VectorCars|JamesDistributers|WBRTA| <peerid>"
fi
export peerId=$2

if [[ $1 = "VectorCars" ]];then
	echo "Setting to organization VectorCars peer "$peerId
	export CORE_PEER_ADDRESS=$peerId.vectorcars.com:7051
	export CORE_PEER_LOCALMSPID=VectorCarsMSP
	export CORE_PEER_TLS_CERT_FILE=/opt/ws/crypto-config/peerOrganizations/vectorcars.com/peers/$peerId.vectorcars.com/tls/server.crt
	export CORE_PEER_TLS_KEY_FILE=/opt/ws/crypto-config/peerOrganizations/vectorcars.com/peers/$peerId.vectorcars.com/tls/server.key
	export CORE_PEER_TLS_ROOTCERT_FILE=/opt/ws/crypto-config/peerOrganizations/vectorcars.com/peers/$peerId.vectorcars.com/tls/ca.crt
	export CORE_PEER_MSPCONFIGPATH=/opt/ws/crypto-config/peerOrganizations/vectorcars.com/users/Admin@vectorcars.com/msp
fi

if [[ $1 = "JamesDistributers" ]];then
	echo "Setting to organization JamesDistributers peer "$peerId
	export CORE_PEER_ADDRESS=$peerId.jamesdistributers.net:7051
	export CORE_PEER_LOCALMSPID=JamesDistributersMSP
	export CORE_PEER_TLS_CERT_FILE=/opt/ws/crypto-config/peerOrganizations/jamesdistributers.net/peers/$peerId.jamesdistributers.net/tls/server.crt
	export CORE_PEER_TLS_KEY_FILE=/opt/ws/crypto-config/peerOrganizations/jamesdistributers.net/peers/$peerId.jamesdistributers.net/tls/server.key
	export CORE_PEER_TLS_ROOTCERT_FILE=/opt/ws/crypto-config/peerOrganizations/jamesdistributers.net/peers/$peerId.jamesdistributers.net/tls/ca.crt
	export CORE_PEER_MSPCONFIGPATH=/opt/ws/crypto-config/peerOrganizations/jamesdistributers.net/users/Admin@jamesdistributers.net/msp
fi

if [[ $1 = "WBRTA" ]];then
	echo "Setting to organization WBRTA peer "$peerId
	export CORE_PEER_ADDRESS=$peerId.wbrta.gov.in:7051
	export CORE_PEER_LOCALMSPID=WBRTAMSP
	export CORE_PEER_TLS_CERT_FILE=/opt/ws/crypto-config/peerOrganizations/wbrta.gov.in/peers/$peerId.wbrta.gov.in/tls/server.crt
	export CORE_PEER_TLS_KEY_FILE=/opt/ws/crypto-config/peerOrganizations/wbrta.gov.in/peers/$peerId.wbrta.gov.in/tls/server.key
	export CORE_PEER_TLS_ROOTCERT_FILE=/opt/ws/crypto-config/peerOrganizations/wbrta.gov.in/peers/$peerId.wbrta.gov.in/tls/ca.crt
	export CORE_PEER_MSPCONFIGPATH=/opt/ws/crypto-config/peerOrganizations/wbrta.gov.in/users/Admin@wbrta.gov.in/msp
fi

	