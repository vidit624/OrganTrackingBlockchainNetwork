# Hyperledger Fabric network setup for the workshop

### Make sure you have the correct proxy settings in your machine 

##Steps to download the setup 

1. Goto your home directory 

```sh
cd $HOME
```

2. Create the nework direcory 

```sh
mkdir -p projects/cartrack/network
```

3. Change directory to the network directory 

```sh
cd $HOME/projects/cartrack/network

```
4. Clone the repository 

```sh

git clone https://github.com/suddutt1/workshopnetwork.git . # Do not miss the DOT(.) at the end of the command
```


## Blockchain network setup 

All the commands must be executed from  $HOME/projects/cartrack/network directory.  

#### ========First time setup instructions ( START)============= 

First time setup. Run the following commands 
 1. Download the binaries 
```sh
 . ./downloadbin.sh 
```

 2. To Generate the cryto config and other configurations

```sh
  . ./generateartifacts.sh 
```

 3. Create the chain code directiory.

```sh
  mkdir -p chaincode/github.com/ctrack 
```

 4. Copy the chain code files in the chaincode/github.com/ctrack ( Separate instructions will given for this step) 

 5. Start the netowrk  

```sh
  . setenv.sh 
  docker-compose up -d 
```

 6. Build and join channel. Make sure that network is running 

```sh
   docker exec -it cli bash -e ./buildandjoinchannel.sh 
```

 7. Install and intantiate the chain codes 
  
```sh
  docker exec -it cli bash -e  ./ctrack_install.sh
```
#### ========First time setup instructions ( END)============= 


#### ========When chain code is modified ( START)============= 
To update the chain code , first update the chain code source files in the above mentioned directory.Then run the following commands as appropriate

```sh
  docker exec -it cli bash -e  ./ctrack_update.sh <version>
```

#### ========When chain code is modified ( END)============= 


#### ========To bring up an existing network ( START)============= 
```sh
. setenv.sh 
  docker-compose up -d 
```

#### ========To bring up an existing network ( END)============= 


#### ========To destory  an existing network ( START)============= 
```sh
  . setenv.sh 
  docker-compose down 
```

If you are stoping a network using the above commands,to start the network again , you have to execute steps 2,5,6,7 of the first time setup.
 

#### ========To destory  an existing network ( END)============= 
