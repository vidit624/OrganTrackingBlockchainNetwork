
#!/bin/bash -e




	
	echo "Building channel for cartrackingchannel" 
	
	. setpeer.sh WBRTA peer0
	export CHANNEL_NAME="cartrackingchannel"
	peer channel create -o orderer.carscm.net:7050 -c $CHANNEL_NAME -f ./cartrackingchannel.tx --tls true --cafile $ORDERER_CA -t 1000s
	
		
        
            . setpeer.sh WBRTA peer0
            export CHANNEL_NAME="cartrackingchannel"
			peer channel join -b $CHANNEL_NAME.block
		
	
		
        
            . setpeer.sh JamesDistributers peer0
            export CHANNEL_NAME="cartrackingchannel"
			peer channel join -b $CHANNEL_NAME.block
		
	
		
        
            . setpeer.sh VectorCars peer0
            export CHANNEL_NAME="cartrackingchannel"
			peer channel join -b $CHANNEL_NAME.block
		
	
	
	
	
		. setpeer.sh WBRTA peer0
		export CHANNEL_NAME="cartrackingchannel"
		peer channel update -o  orderer.carscm.net:7050 -c $CHANNEL_NAME -f ./cartrackingchannelWBRTAMSPAnchor.tx --tls --cafile $ORDERER_CA 
	

	
	
		. setpeer.sh JamesDistributers peer0
		export CHANNEL_NAME="cartrackingchannel"
		peer channel update -o  orderer.carscm.net:7050 -c $CHANNEL_NAME -f ./cartrackingchannelJamesDistributersMSPAnchor.tx --tls --cafile $ORDERER_CA 
	

	
	
		. setpeer.sh VectorCars peer0
		export CHANNEL_NAME="cartrackingchannel"
		peer channel update -o  orderer.carscm.net:7050 -c $CHANNEL_NAME -f ./cartrackingchannelVectorCarsMSPAnchor.tx --tls --cafile $ORDERER_CA 
	




