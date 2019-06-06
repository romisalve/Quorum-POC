pragma solidity ^0.4.23;

pragma experimental ABIEncoderV2;

 
 library StructuresAndVariables{

   struct MasterDataRecipient{
    string recipientType; /* identify the type of regulatory office that
                receives the Master Data*/
    string recipient;
  }

  struct MasterDataSender{
    string senderType; /* identify the type of regulatory office that
                sends the Master Data*/
    string sender;
  }

  struct MasterDataParty{
    string partyName;
    string partyShortName;
    string businessType;
    uint256 partyId;
    string identificationIssuingCountry; //ISO alpha code 2 digits
    string roleCode;
  }

  struct AEOMasterData{
    uint256 messageFunctionCode;
    string functionalReferenceNumber; /*Reference number identifying a
                      specific information exchange*/
    string documentName;
   MasterDataRecipient masterDataRec;
   MasterDataSender masterDataSen;
    string endDate;

  }

  struct MasterDataPartyAddress{
    string typeOfAddress;
    string cityName;
    string countryCode; // ISO alpha code 2 digit
    string countryName;
    string countrySubEntityIdentification;
    string street;
    uint256 number;
    string postCodeId;
  }

  struct MasterDataPartyContactCommunication{
    string communicationNumber;
    string communicationNumberType;
  }
 struct MasterDataPartyContact{
    string contactName;
    string contactFunctionCode;
  }

  struct MasterDataPartyCommunication{
    string partyCommunicationNumber;
    string partyCommunicationNumberType;
  }

  struct MasterDataPartyAdditionalIdentifier{
    uint256 sequenceNumber;
    string additionalIdentificationCode;
    string additionalIdentificationIssuingCountry; //ISO alpha code 2 digits
  }

  struct MasterDataPartyAdditionalDocument{
    string documentCategoryCode;
    string documentEffectiveDate;
    string documentExpirationDate;
    string additionalDocumentReferenceNumber; //esto?
    string documentMessageStatus;
    string additionalDocumentType;
    string manufacturingLocation;
  }

 }


contract CrudAEOStructures {
 
   //mapping to save index associated to each functionalRefNumber
   mapping (string=>uint256) public masterDataAEOs;
   //mapping functionalReferenceNumber->MasterDataParty
   mapping (string => StructuresAndVariables.MasterDataParty[]) public masterDataPartiesAEO;
   mapping (string => bool) public masterDataPartiesExists;
   //mapping idAEO->Address
   mapping (uint256 => StructuresAndVariables.MasterDataPartyAddress[]) public addressesAEO;
   mapping (uint256 => bool) public addressExists;
   //mapping idAEO->MasterDataPartyContact
   mapping (uint256 => StructuresAndVariables.MasterDataPartyContact[]) public partiesContAEO;
   mapping (uint256 => bool) public partiesContExists;
   //mapping contactName->MasterDataPartyContactComm
   mapping (string => StructuresAndVariables.MasterDataPartyContactCommunication[]) public partiesContCommAEO;
   mapping (string => bool) public partiesContCommExists;
    //mapping idAEO->MasterDataPartyCommunication
   mapping (uint256 => StructuresAndVariables.MasterDataPartyCommunication[]) public partiesCommAEO;
   mapping (uint256 => bool) public partiesCommExists;
   //mapping idAEO->AdditionalIdentifier
   mapping (uint256 => StructuresAndVariables.MasterDataPartyAdditionalIdentifier[]) public additionalIdentifiersAEO;
   mapping (uint256 => bool) public additionalIdentifiersExists;
   //mapping idAEO->AdditionalDocument
   mapping (uint256 => StructuresAndVariables.MasterDataPartyAdditionalDocument[]) public additionalDocumentsAEO;
   mapping (uint256 => bool) public additionalDocumentExists;
   
    StructuresAndVariables.AEOMasterData[] public AEOs;

   uint256 public totalAEOs;

   constructor() public {
       totalAEOs = 0;
   }

  
   event AEOExpDateUpdate(string AEOpartyName, string AEONewExpDate);

   event AEODelete(string AEOfunctionalReferenceNumber);

   
  function compareStrings (string a, string b) internal pure returns (bool){
       return keccak256(a) == keccak256(b);
  }   
   
   function getTotalAEOs() public view returns (uint256 length){
      return AEOs.length;
  }

  function retrieveFRN (uint256 i) public view returns (string fnr){

    return AEOs[i].functionalReferenceNumber; 
  }

  function retrievePartyName(StructuresAndVariables.MasterDataParty[] mdpArray, uint256 i)public view returns(string name){
    return mdpArray[i].partyName; 
  }

  function retrievePartyShortName(StructuresAndVariables.MasterDataParty[] mdpArray, uint256 i)public view returns(string shortName){
    return mdpArray[i].partyShortName; 
  }

  function retrieveBusinessType(StructuresAndVariables.MasterDataParty[] mdpArray, uint256 i)public view returns(string shortName){
    return mdpArray[i].businessType; 
  }

  function retrieveIssuingCountry(StructuresAndVariables.MasterDataParty[] mdpArray, uint256 i)public view returns(string shortName){
    return mdpArray[i].identificationIssuingCountry;
  }

  function retrieveStreetAddress(StructuresAndVariables.MasterDataPartyAddress[] mdpaArray, uint256 i)public view returns(string street){
    return mdpaArray[i].street;
  }

  function retrieveNumberAddress(StructuresAndVariables.MasterDataPartyAddress[] mdpaArray, uint256 i)public view returns(uint256 number){
    return mdpaArray[i].number;
  }

  function retrieveContactName(StructuresAndVariables.MasterDataPartyContact[] mdpcArray, uint256 i)public view returns(string contactName){
    return mdpcArray[i].contactName;
  }

  function retrieveCommNumber(StructuresAndVariables.MasterDataPartyContactCommunication[] mdpccommArray, uint256 i)public view returns(string commNum){
    return mdpccommArray[i].communicationNumber;
  }

  function retrievePartyCommNumber(StructuresAndVariables.MasterDataPartyCommunication[] mdpcommArray, uint256 i)public view returns(string partyCommNum){
    return mdpcommArray[i].partyCommunicationNumber;
  }

  function retrieveSequenceNumber(StructuresAndVariables.MasterDataPartyAdditionalIdentifier[] mdpaiArray, uint256 i)public view returns(uint256 seqNum){
    return mdpaiArray[i].sequenceNumber;
  }

  function retrieveADocRefNum(StructuresAndVariables.MasterDataPartyAdditionalDocument[] mdpadArray, uint256 i)public view returns(string addDocRefNum){
    return mdpadArray[i].additionalDocumentReferenceNumber;
  }

  function retrieveIndexAEO (string fnr) public returns (uint256 index) {
    return masterDataAEOs[fnr];
  }

  function retrieveEnDate (uint256 id) public returns (string date) {
    return AEOs[id].endDate;
  }


  function increaseTotalAEOs ()public{
    totalAEOs= totalAEOs++;

  }

  function insertNewAEO (StructuresAndVariables.AEOMasterData newAEOToInsert) public{
    AEOs.push(newAEOToInsert); 
  }

  function masterDataAEOsmapping (string fnr, uint256 i) public{
     masterDataAEOs[fnr]=i; 
  }

  function masterDataPartiesAEOmapping (string fnr, StructuresAndVariables.MasterDataParty mdp) public{
     masterDataPartiesAEO[fnr].push(mdp); 
  }

   function addressesAEOmapping (uint256 id, StructuresAndVariables.MasterDataPartyAddress mdpa) public{
     addressesAEO[id].push(mdpa); 
  }

   function partiesContAEOmapping (uint256 id, StructuresAndVariables.MasterDataPartyContact mdpc) public{
     partiesContAEO[id].push(mdpc); 
  }

   function partiesContCommAEOmapping (string fnr, StructuresAndVariables.MasterDataPartyContactCommunication mdpcc) public{
     partiesContCommAEO[fnr].push(mdpcc); 
  }

   function partiesCommAEOmapping (uint256 id, StructuresAndVariables.MasterDataPartyCommunication mdpcom) public{
     partiesCommAEO[id].push(mdpcom); 
  }

   function additionalIdentifiersAEOmapping (uint256 id, StructuresAndVariables.MasterDataPartyAdditionalIdentifier mdpai) public{
     additionalIdentifiersAEO[id].push(mdpai); 
  }

   function additionalDocumentsAEOmapping (uint256 id, StructuresAndVariables.MasterDataPartyAdditionalDocument mdpad) public{
     additionalDocumentsAEO[id].push(mdpad); 
  }

  function setExistanceForCertainId(uint256 idArray, uint256 id) public{

    if(idArray==1){
       addressExists[id]=true;
    }
    if(idArray==2){
      partiesContExists[id]=true;
    }
    if(idArray==3){
     partiesCommExists[id]=true;
    }
    if(idArray==4){
     additionalIdentifiersExists[id]=true;
    }
    if(idArray==5){
     additionalDocumentExists[id]=true;
    }
   }

   function setExistance(uint256 id, string fnr) public{

    if(id==1){
       masterDataPartiesExists[fnr]=true; 
    }
    if(id==2){
      partiesContCommExists[fnr]=true;
    }
    
   }

   function checkExistance(uint256 idArray, string key, uint256 keyInt)public view returns(bool answer){
   
    if(idArray==1){
     return masterDataPartiesExists[key];
    }
    if(idArray==2){
     return addressExists[keyInt];
    }
    if(idArray==3){
     return partiesContExists[keyInt];
    }
    if(idArray==4){
     return partiesContCommExists[key];
    }
    if(idArray==5){
     return partiesCommExists[keyInt];
    }
    if(idArray==6){
     return additionalIdentifiersExists[keyInt];
    }
    if(idArray==7){
     return additionalDocumentExists[keyInt];
    }    

   }

   function getLenght (uint256 id, string key, uint256 keyInt) public returns (uint256 arrayLenght){
    if(id==1){
     return masterDataPartiesAEO[key].length;
    }
    if(id==2){
     return addressesAEO[keyInt].length;
    }
    if(id==3){
     return partiesContAEO[keyInt].length;
    }
    if(id==4){
     return partiesContCommAEO[key].length;
    }
    if(id==5){
     return partiesCommAEO[keyInt].length;
    }
    if(id==6){
     return additionalIdentifiersAEO[keyInt].length;
    }
    if(id==7){
     return additionalDocumentsAEO[keyInt].length;
  }

}

  function retrieveMasterDataPartyArray (string key) public returns (StructuresAndVariables.MasterDataParty[] ){
    return masterDataPartiesAEO[key];
  }

  function retrieveAddressesArray (uint256 key) public returns(StructuresAndVariables.MasterDataPartyAddress[]){
    return addressesAEO[key];
  }

  function retrievePartyContArray (uint256 key) public returns(StructuresAndVariables.MasterDataPartyContact[]){
    return partiesContAEO[key];
  }

  function retrieveMasterDataPartyContCommArray (string key) public returns(StructuresAndVariables.MasterDataPartyContactCommunication[]){
    return partiesContCommAEO[key];
  }

  function retrieveMasterDataPartyCommArray (uint256 key) public returns(StructuresAndVariables.MasterDataPartyCommunication[]){
    return partiesCommAEO[key];
  }

  function retrieveMasterDataPartyAdIdArray (uint256 key) public returns(StructuresAndVariables.MasterDataPartyAdditionalIdentifier[]){
    return additionalIdentifiersAEO[key];
  }

  function retrieveMasterDataPartyAdDocArray (uint256 key) public returns(StructuresAndVariables.MasterDataPartyAdditionalDocument[]){
    return additionalDocumentsAEO[key];
  }

 }
