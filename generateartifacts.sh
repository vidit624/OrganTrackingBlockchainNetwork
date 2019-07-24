
#!/bin/bash -e
export PWD=`pwd`

export FABRIC_CFG_PATH=$PWD
export ARCH=$(uname -s)
export CRYPTOGEN=$PWD/bin/cryptogen
export CONFIGTXGEN=$PWD/bin/configtxgen

function generateArtifacts() {
	
	echo " *********** Generating artifacts ************ "
	echo " *********** Deleting old certificates ******* "
	
        rm -rf ./crypto-config
	
        echo " ************ Generating certificates ********* "
	
        $CRYPTOGEN generate --config=$FABRIC_CFG_PATH/crypto-config.yaml
        
        echo " ************ Generating tx files ************ "
	
		$CONFIGTXGEN -profile OrdererGenesis -outputBlock ./genesis.block
		
		$CONFIGTXGEN -profile cartrackingchannel -outputCreateChannelTx ./cartrackingchannel.tx -channelID cartrackingchannel
		
		echo "Generating anchor peers tx files for  WBRTA"
		$CONFIGTXGEN -profile cartrackingchannel -outputAnchorPeersUpdate  ./cartrackingchannelWBRTAMSPAnchor.tx -channelID cartrackingchannel -asOrg WBRTAMSP
		
		echo "Generating anchor peers tx files for  JamesDistributers"
		$CONFIGTXGEN -profile cartrackingchannel -outputAnchorPeersUpdate  ./cartrackingchannelJamesDistributersMSPAnchor.tx -channelID cartrackingchannel -asOrg JamesDistributersMSP
		
		echo "Generating anchor peers tx files for  VectorCars"
		$CONFIGTXGEN -profile cartrackingchannel -outputAnchorPeersUpdate  ./cartrackingchannelVectorCarsMSPAnchor.tx -channelID cartrackingchannel -asOrg VectorCarsMSP
		

		

}
function generateDockerComposeFile(){
	OPTS="-i"
	if [ "$ARCH" = "Darwin" ]; then
		OPTS="-it"
	fi
	cp  docker-compose-template.yaml  docker-compose.yaml
	
	
	cd  crypto-config/peerOrganizations/vectorcars.com/ca
	PRIV_KEY=$(ls *_sk)
	cd ../../../../
	sed $OPTS "s/VECTORCARS_PRIVATE_KEY/${PRIV_KEY}/g"  docker-compose.yaml
	
	
	cd  crypto-config/peerOrganizations/jamesdistributers.net/ca
	PRIV_KEY=$(ls *_sk)
	cd ../../../../
	sed $OPTS "s/JAMESDISTRIBUTERS_PRIVATE_KEY/${PRIV_KEY}/g"  docker-compose.yaml
	
	
	cd  crypto-config/peerOrganizations/wbrta.gov.in/ca
	PRIV_KEY=$(ls *_sk)
	cd ../../../../
	sed $OPTS "s/WBRTA_PRIVATE_KEY/${PRIV_KEY}/g"  docker-compose.yaml
	
}
generateArtifacts 
cd $PWD
generateDockerComposeFile
cd $PWD

