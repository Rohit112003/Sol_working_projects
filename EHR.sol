//SPDX-License-Identifier: Gpl-3.0
pragma solidity 0.8.18;

contract EHR{
    address owner;
    
    constructor(){
        owner = msg.sender;
    }
struct Patient {
    uint256 id;
    string  Fullname;
    string email;
    string Dob;
    string gender;
    string presentdisease;
    string[] prevousProblem;
    string[] prevSergeries;
    string[] recordsofHospital;
    string medicine;
    string surgeries;
    string immuneStatus;
 }
 struct doctor{
    uint256  DocId;
    string name;
    string Dob;
    string specialist;
    string  id;
 }

    uint256 public  presentID =1000;
    uint256 public DoctorID = 1000;
    modifier restricted(){
        require(msg.sender==owner);
        _;
    }
    //mappind all
    mapping(bytes32=> doctor) doctorData;
    mapping(uint256 => bytes32)  doctorHash;
    mapping(uint256=> bool) valid;
    mapping(uint256 => Patient) patientDetail;
    mapping(uint256 => bool) valid1;

//doctor create
function doctorCreate(string memory _name, string  memory uniqueData,string memory _dob,string memory _specialist, string memory _id ) public restricted returns(uint256){
    bytes32 salt = bytes32(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))));
    bytes32 hash =  keccak256(abi.encodePacked(salt,_name,uniqueData));
    doctorData[hash] =  doctor(DoctorID, 
    _name,
    _dob,
    _specialist,
    _id
    );
    valid[DoctorID] = true;
    doctorHash[DoctorID++] = hash;
    return  DoctorID-1;
}

//patient create

function patientCreate(uint256 _docId, string memory _fullName,string memory _email, string memory _dob, string memory _presentdisease,   string memory _gender, 
string memory _Surgery, 
string memory _hospitalName, string memory _medicine,string memory _immuneStatus   )  public returns (uint256){
    require(valid[_docId]==true,"current Doctor not listed in the server");
    Patient storage patient= patientDetail[presentID];

        patient.id = presentID;
        patient.Fullname = _fullName;
        patient.email = _email;
        patient.Dob = _dob;
        patient.gender = _gender;
        patient.presentdisease = _presentdisease;
        patient.prevousProblem.push(_presentdisease);
        patient.prevSergeries.push(_Surgery);
        patient.recordsofHospital.push(_hospitalName);
        patient.medicine = _medicine;
        patient.surgeries = _Surgery;
        patient.immuneStatus = _immuneStatus;

        valid1[presentID] = true;

        presentID++;
        return presentID-1;


   
}
//patient update

function patientDetailAdd(uint256 _docId, uint256 _patientId, string memory _presentdisease, string memory _hospitalName,  string memory _medicine, 
string memory _immuneStatus ) public {
    require(valid[_docId]==true,"you are not listed on the server");
    require(valid1[_patientId]=true,"you are not listed on the server please create you in our server");
    Patient storage patient = patientDetail[_patientId];
    patient.prevousProblem.push(_presentdisease);
    patient.recordsofHospital.push(_hospitalName);
    patient.medicine = _medicine;
    patient.immuneStatus = _immuneStatus;
}

//get particular patient data

function patientData(uint256 _patientId) public view returns (
    uint256,
    string memory,
    string memory,
    string memory,
    string memory,
    string memory,
    string[] memory,
    string[] memory,
    string[] memory,
    string memory,
    string memory,
    string memory
    
) {
    require(valid1[_patientId], "You are not listed on the server, please create your profile on our server");
    Patient memory patient = patientDetail[_patientId];
    return (
        patient.id,
        patient.Fullname,
        patient.email,
        patient.Dob,
        patient.gender,
        patient.presentdisease,
        patient.prevousProblem,
        patient.prevSergeries,
        patient.recordsofHospital,
        patient.medicine,
        patient.surgeries,
        patient.immuneStatus
    );
}

}