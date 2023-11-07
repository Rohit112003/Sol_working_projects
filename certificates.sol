//SPDX-License-Identifier: Gpl-3.0
pragma solidity 0.8.18;


contract newCertificate{
    address public owner;
    uint256 public birthNumber = 1000;
    struct birthcertificate{
        string Dob;
        string name;
        string PermanentAddress;
        string FatherName;
        string motherName;
        string sex;
        string eyeRatina;
        string fingerScan;
        string url;
        string signature;

    }
    constructor(){
        owner = msg.sender;
    }
    event CertificateIssued(uint256 birth ,string  Dob, string  name, string  PermanentAddress
    , string  FatherName, string  MotherName,string sex);
    event CertificateAadhar(uint256 birth ,string  Dob, string  name, string  PermanentAddress, string  FatherName,
     string  MotherName,string sex, string eyeRatina,string fingerScan);

    mapping(bytes32 => birthcertificate) public birthCandidate;
    mapping(uint256 => bytes32)  public  birthCandidateNumber;
     modifier onlyOwner(){
        require(owner==msg.sender,"only owner can perform an action");
        _;
    }

    function issueBirthCertificate(string memory  _Dob, string memory _name, string memory _PermanentAddress
    , string memory _FatherName, string memory _MotherName,
    string  memory _sex) public onlyOwner returns(uint256){
        bytes32 salt = bytes32(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))));
        bytes32 certificateId = keccak256(abi.encodePacked(salt,_Dob,_name,_PermanentAddress,_FatherName,_MotherName,_sex));
        birthCandidate[certificateId] = birthcertificate(_Dob
        ,_name,
        _PermanentAddress,
        _FatherName,
        _MotherName,_sex,
        "",
        "",
        "",
        "");
        emit CertificateIssued(birthNumber,_Dob,_name,_PermanentAddress,_FatherName,_MotherName ,_sex);
        birthCandidateNumber[birthNumber++] = certificateId;
        
        return birthNumber-1;
        
    }
    function issueAadhar(uint256 _birthNumber,bytes32 _id, string memory eyeRatina,
     string memory fingerScan) public returns(uint256){
        require(birthCandidateNumber[_birthNumber]==_id, "Not a valid id");
        birthcertificate storage certificate =  birthCandidate[_id];
        certificate.eyeRatina = eyeRatina;
        certificate.fingerScan= fingerScan;
        emit CertificateAadhar(birthNumber,certificate.Dob,certificate.name,certificate.PermanentAddress,
        certificate.FatherName,certificate.motherName ,certificate.sex,eyeRatina,fingerScan);
        return _birthNumber;

       
    }

    function returnHash(uint256 _id) view public returns(bytes32){
        bytes32 hash = birthCandidateNumber[_id];
        return hash;
    }

    
}