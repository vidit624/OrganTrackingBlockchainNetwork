#!/bin/bash
. setpeer.sh WBRTA peer0 
export CHANNEL_NAME="cartrackingchannel"
peer chaincode install -n ctrack -v 1.0 -l golang -p  github.com/ctrack
. setpeer.sh JamesDistributers peer0 
export CHANNEL_NAME="cartrackingchannel"
peer chaincode install -n ctrack -v 1.0 -l golang -p  github.com/ctrack
. setpeer.sh VectorCars peer0 
export CHANNEL_NAME="cartrackingchannel"
peer chaincode install -n ctrack -v 1.0 -l golang -p  github.com/ctrack
peer chaincode instantiate -o orderer.carscm.net:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C cartrackingchannel -n ctrack -v 1.0 -c '{"Args":["init",""]}' -P " OR( 'WBRTAMSP.member','JamesDistributersMSP.member','VectorCarsMSP.member' ) " 
