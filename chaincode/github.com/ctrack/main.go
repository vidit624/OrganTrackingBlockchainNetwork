package main

import (
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	id "github.com/hyperledger/fabric/core/chaincode/shim/ext/cid"
	pb "github.com/hyperledger/fabric/protos/peer"
)

var _MainLogger = shim.NewLogger("CarTrackLogger")

//SmartContract for car tracking
type SmartContract struct {
}

//OrganDetails represents the car record to be stored in ledger
type OrganDetails struct {
	OrganType  string `json:"organType"`
	OrganID    string `json:"organID"`
	Year       string `json:"donationYear"`
	BloodGroup string `json:"bloodgroup"`
	Status     string `json:"status"`
	// Dealer      string `json:"dealer"`
	// OwnerName string `json:"owner"`
	UpdateTs string `json:"ts"`
	TrxnID   string `json:"trxnId"`
	UpdateBy string `json:"updBy"`
}

// Init initializes chaincode.
func (sc *SmartContract) Init(stub shim.ChaincodeStubInterface) pb.Response {
	_MainLogger.Infof("Inside the init method ")

	return shim.Success(nil)
}
func (sc *SmartContract) probe(stub shim.ChaincodeStubInterface) pb.Response {
	ts := ""
	_MainLogger.Info("Inside probe method")
	tst, err := stub.GetTxTimestamp()
	if err == nil {
		ts = tst.String()
	}
	output := "{\"status\":\"Success\",\"ts\" : \"" + ts + "\" }"
	_MainLogger.Info("Retuning " + output)
	return shim.Success([]byte(output))
}

func (sc *SmartContract) createOrganEntry(stub shim.ChaincodeStubInterface) pb.Response {
	_, args := stub.GetFunctionAndParameters()
	if len(args) < 1 {
		_MainLogger.Errorf("Invalid number of arguments")
		return shim.Error("Invalid number of arguments")
	}
	var organDetails OrganDetails
	if err := json.Unmarshal([]byte(args[0]), &organDetails); err != nil {
		_MainLogger.Errorf("Unable to parse the input organ details JSON %v", err)
		return shim.Error("Unable to parse the input organ details JSON")
	}
	idOk, manuf := sc.getInvokerIdentity(stub)
	if !idOk {
		return shim.Error("Unable to retrive the invoker ID")
	}
	if strings.TrimSpace(organDetails.OrganID) == "" {
		_MainLogger.Error("No Organ ID provided")
		return shim.Error("No Organ ID provided")
	}
	organDetails.UpdateBy = manuf
	organDetails.Status = "Available"
	organDetails.TrxnID = stub.GetTxID()
	organDetails.UpdateTs = sc.getTrxnTS(stub)
	jsonBytesToStore, _ := json.Marshal(organDetails)
	//TODO: Check the chasis number
	if err := stub.PutState(organDetails.OrganID, jsonBytesToStore); err != nil {
		_MainLogger.Errorf("Unable to store the Organ Deatils %v", err)
		return shim.Error("Unable to store the Organ Details")
	}

	return shim.Success([]byte(jsonBytesToStore))
}

func (sc *SmartContract) modifyOrganEntity(stub shim.ChaincodeStubInterface) pb.Response {
	_, args := stub.GetFunctionAndParameters()
	if len(args) < 1 {
		_MainLogger.Errorf("Invalid number of arguments")
		return shim.Error("Invalid number of arguments")
	}
	var organDetails OrganDetails
	if err := json.Unmarshal([]byte(args[0]), &organDetails); err != nil {
		_MainLogger.Errorf("Unable to parse the input car details JSON %v", err)
		return shim.Error("Unable to parse the input car details JSON")
	}
	idOk, who := sc.getInvokerIdentity(stub)
	if !idOk {
		return shim.Error("Unable to retrive the invoker ID")
	}
	if strings.TrimSpace(organDetails.OrganID) == "" {
		_MainLogger.Error("No Organ ID provided")
		return shim.Error("No Organ ID provided")
	}
	var existingEntity OrganDetails
	recordBytes, err := stub.GetState(organDetails.OrganID)
	if err != nil {
		_MainLogger.Error("Invalid Organ ID provided")
		return shim.Error("Invalid Organ ID provided")
	}
	if err := json.Unmarshal([]byte(recordBytes), &existingEntity); err != nil {
		_MainLogger.Errorf("Unable to parse the existing organ details JSON %v", err)
		return shim.Error("Unable to parse the existing organ details JSON")
	}
	existingEntity.UpdateBy = who
	existingEntity.TrxnID = stub.GetTxID()
	existingEntity.UpdateTs = sc.getTrxnTS(stub)
	//TODO: Checks on the status change
	if len(strings.TrimSpace(organDetails.Status)) > 0 {
		existingEntity.Status = organDetails.Status
	}
	// if len(existingEntity.Dealer) == 0 && len(strings.TrimSpace(organDetails.Dealer)) > 0 {
	// 	existingEntity.Dealer = organDetails.Dealer
	// }
	// if len(strings.TrimSpace(organDetails.OwnerName)) > 0 {
	// 	existingEntity.OwnerName = organDetails.OwnerName
	// }
	jsonBytesToStore, _ := json.Marshal(existingEntity)
	//TODO: Check the chasis number
	if err := stub.PutState(organDetails.OrganID, jsonBytesToStore); err != nil {
		_MainLogger.Errorf("Unable to store the organ details %v", err)
		return shim.Error("Unable to store the irgan details ")
	}

	return shim.Success([]byte(jsonBytesToStore))
}

func (sc *SmartContract) registerOrg(stub shim.ChaincodeStubInterface) pb.Response {
	_, args := stub.GetFunctionAndParameters()
	if len(args) < 1 {
		return shim.Error("Invalid number of arguments")
	}
	participantRole := args[0]
	idOk, who := sc.getInvokerIdentity(stub)
	if !idOk {
		return shim.Error("Unable to retrive the invoker ID")
	}
	key := fmt.Sprintf("PARTICIPANT_%s", who)
	stub.PutState(key, []byte(participantRole))
	return shim.Success([]byte("Organization registered"))
}
func (sc *SmartContract) queryOrgan(stub shim.ChaincodeStubInterface) pb.Response {
	_, args := stub.GetFunctionAndParameters()
	if len(args) < 1 {
		return shim.Error("Invalid number of arguments")
	}
	key := args[0]
	data, err := stub.GetState(key)
	if err != nil {
		return shim.Success(nil)

	}
	return shim.Success(data)
}
func (sc *SmartContract) queryOrganHistory(stub shim.ChaincodeStubInterface) pb.Response {
	_, args := stub.GetFunctionAndParameters()
	if len(args) < 1 {
		return shim.Error("Invalid number of arguments")
	}
	key := args[0]
	history, err := stub.GetHistoryForKey(key)
	if err != nil {
		return shim.Error("Unable to retrive history")

	}
	historyRecords := make([]map[string]interface{}, 0)
	for history.HasNext() {
		if rslt, err := history.Next(); err == nil {
			recordMap := make(map[string]interface{})
			if parseErr := json.Unmarshal(rslt.Value, &recordMap); parseErr == nil {
				historyRecords = append(historyRecords, recordMap)
			}
		}
	}
	outputJSON, _ := json.Marshal(historyRecords)
	return shim.Success(outputJSON)
}

//Invoke is the entry point for any transaction
func (sc *SmartContract) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	var response pb.Response
	action, _ := stub.GetFunctionAndParameters()
	switch action {
	case "probe":
		response = sc.probe(stub)
	case "createOrganDetails":
		response = sc.createOrganEntry(stub)
	case "modifyOrganDetails":
		response = sc.modifyOrganEntity(stub)
	case "queryOrgan":
		response = sc.queryOrgan(stub)
	case "queryHistory":
		response = sc.queryOrganHistory(stub)
	case "registerOrg":
		response = sc.registerOrg(stub)
	default:
		response = shim.Error("Invalid action provoided")
	}
	return response
}

func (sc *SmartContract) getInvokerIdentity(stub shim.ChaincodeStubInterface) (bool, string) {
	//Following id comes in the format X509::<Subject>::<Issuer>>
	/*enCert, err := id.GetX509Certificate(stub)
	if err != nil {
		return false, "Unknown."
	}*/

	mspID, err := id.GetMSPID(stub)
	if err != nil {
		return false, "Unknown."
	}
	return true, fmt.Sprintf("%s", mspID)

}
func (sc *SmartContract) getTrxnTS(stub shim.ChaincodeStubInterface) string {
	txTime, err := stub.GetTxTimestamp()
	if err != nil {
		return "0000.00.00.00.00.000"
	}
	var ts time.Time
	newTS := ts.Add(time.Duration(txTime.Seconds) * time.Second)
	return newTS.Format("2006.01.02.15.04.05.000")

}
func (sc *SmartContract) getOrganizationRole(stub shim.ChaincodeStubInterface) string {
	idOk, who := sc.getInvokerIdentity(stub)
	if !idOk {
		_MainLogger.Error("Unable to retrive the invoker ID")
		return ""
	}
	key := fmt.Sprintf("PARTICIPANT_%s", who)
	_MainLogger.Infof("User key %s", key)
	if roleJSON, err := stub.GetState(key); err == nil {
		_MainLogger.Infof("User key %s", string(roleJSON))
		role := string(roleJSON)
		return role
	}
	_MainLogger.Error("Unable to retrive the role , not registered")
	return ""

}
func main() {
	err := shim.Start(new(SmartContract))
	if err != nil {
		_MainLogger.Criticalf("Error starting  chaincode: %v", err)
	}
}
