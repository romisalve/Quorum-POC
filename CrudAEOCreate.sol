pragma solidity ^0.4.23;

contract CrudAEOCreate {

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
   //mapping to save index associated to each functionalRefNumber
   mapping (string=>uint256) masterDataAEOs;
   //mapping functionalReferenceNumber->MasterDataParty
   mapping (string => MasterDataParty[]) masterDataPartiesAEO;
   mapping (string => bool) masterDataPartiesExists;
   //mapping idAEO->Address
   mapping (uint256 => MasterDataPartyAddress[]) addressesAEO;
   mapping (uint256 => bool) addressExists;
   //mapping idAEO->MasterDataPartyContact
   mapping (uint256 => MasterDataPartyContact[]) partiesContAEO;
   mapping (uint256 => bool) partiesContExists;
   //mapping contactName->MasterDataPartyContactComm
   mapping (string => MasterDataPartyContactCommunication[]) partiesContCommAEO;
   mapping (string => bool) partiesContCommExists;
    //mapping idAEO->MasterDataPartyCommunication
   mapping (uint256 => MasterDataPartyCommunication[]) partiesCommAEO;
   mapping (uint256 => bool) partiesCommExists;
   //mapping idAEO->AdditionalIdentifier
   mapping (uint256 => MasterDataPartyAdditionalIdentifier[]) additionalIdentifiersAEO;
   mapping (uint256 => bool) additionalIdentifiersExists;
   //mapping idAEO->AdditionalDocument
   mapping (uint256 => MasterDataPartyAdditionalDocument[]) additionalDocumentsAEO;
   mapping (uint256 => bool) additionalDocumentExists;
   
    AEOMasterData[] public AEOs;

   uint256 public totalAEOs;

   constructor() public {
       totalAEOs = 0;
   }

   event AEOEvent(string AEOfunctionalReferenceNumber, uint256 messageFunctionCodeAEO);

   event AEOUNamepdate(string AEOpartyOldName , string AEOpartyNewName);
   event AEOExpDateUpdate(string AEOpartyName, string AEONewExpDate);

   event AEODelete(string AEOfunctionalReferenceNumber);

   function createMasterDataAEO (uint256 messageFunctionCodeAEO, string memory functionalReferenceNumberAEO, string memory documentNameAEO,
                                 string memory recipientTypeAEO, string memory recipientAEO,
                                 string memory senderTypeAEO, string memory senderAEO,
                                 string endDateAEO)
                                 public returns (uint256 newTotalAEOs){
    bool exists= false;

   MasterDataRecipient memory newMasterDataRecipient= MasterDataRecipient(recipientTypeAEO, recipientAEO);
    MasterDataSender memory newMasterDataSender= MasterDataSender(senderTypeAEO, senderAEO);
    AEOMasterData memory newAEO = AEOMasterData(messageFunctionCodeAEO, functionalReferenceNumberAEO, documentNameAEO, newMasterDataRecipient, newMasterDataSender, endDateAEO);

    for(uint256 i =0; i< totalAEOs; i++){
      if(compareStrings(AEOs[i].functionalReferenceNumber,functionalReferenceNumberAEO)){
          exists=true;
        }
     }
      if (!exists){
             AEOs.push(newAEO);
             totalAEOs++;
             masterDataAEOs[functionalReferenceNumberAEO]=totalAEOs;
             //emit event
             emit AEOEvent (functionalReferenceNumberAEO, messageFunctionCodeAEO);
          }

        return totalAEOs;
   }
   
    //associate a Master Data Party to a Master Data
   function associateMasterDataParty(string memory functionalReferenceNumberAEO, string memory partyNameAEO, string memory partyShortNameAEO, string memory businessTypeAEO, uint256 partyIdAEO, string memory identificationIssuingCountryAEO, string memory roleCodeAEO)
                   public returns(bool){



    MasterDataParty memory newMasterDataParty= MasterDataParty(partyNameAEO, partyShortNameAEO, businessTypeAEO, partyIdAEO, identificationIssuingCountryAEO, roleCodeAEO);


    if(masterDataPartiesExists[functionalReferenceNumberAEO]){

       bool exists=false;
       uint masterDataPartyLength =  masterDataPartiesAEO[functionalReferenceNumberAEO].length;
       MasterDataParty[] memory temporaryMasterDataPartyArray= masterDataPartiesAEO[functionalReferenceNumberAEO];

      for(uint256 i =0; i< masterDataPartyLength; i++){
        if(compareStrings(temporaryMasterDataPartyArray[i].partyName,partyNameAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
                masterDataPartiesAEO[functionalReferenceNumberAEO].push(newMasterDataParty);
                return true;
          }

    } else{

        masterDataPartiesAEO[functionalReferenceNumberAEO].push(newMasterDataParty);
        masterDataPartiesExists[functionalReferenceNumberAEO]=true;
        return true;
    }

    return false;
   }
   
    //stack too deep compile error, couldnt set it inside func associate address
   function setExistanceForCertainId(uint256 idArray, uint256 id) internal{

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

   //Associate an AddressAndContact to certain masterDataParty si le agrego un error da stack too deep compile error
   //Cant add return value, stack too deep error compile
   
    function associateAddress(uint256 partyIdAEO, string memory typeOfAddressAEO, string memory cityNameAEO, string memory countryCodeAEO, string memory countryNameAEO, string memory countrySubEntityIdentificationAEO, string memory streetAEO, uint256 numberAEO, string memory postCodeIdAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it         
    MasterDataPartyAddress memory newMasterDataPartyAddress= MasterDataPartyAddress(typeOfAddressAEO, cityNameAEO, countryCodeAEO, countryNameAEO, countrySubEntityIdentificationAEO, streetAEO, numberAEO, postCodeIdAEO);

    if(addressExists[partyIdAEO]){

       //bool exists=false;
       uint addressLength = addressesAEO[partyIdAEO].length;
       MasterDataPartyAddress[] memory temporaryMasterDataPartyAddressArray= addressesAEO[partyIdAEO];

      for(uint256 i =0; i< addressLength; i++){
        if(compareStrings( temporaryMasterDataPartyAddressArray[i].street,  streetAEO) && (temporaryMasterDataPartyAddressArray[i].number==numberAEO)) {
            //exists=true;
            return false;
          }
       }
        //if (!exists){
                addressesAEO[partyIdAEO].push(newMasterDataPartyAddress);
                return true;
          //}

    } else{

        addressesAEO[partyIdAEO].push(newMasterDataPartyAddress);
        setExistanceForCertainId(1,partyIdAEO);
        return true;
    }

    //return false;
  }
  
   function associateContact(uint256 partyIdAEO, string memory contactNameAEO, string memory contactFunctionCodeAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    MasterDataPartyContact memory newMasterDataPartyContact= MasterDataPartyContact(contactNameAEO,contactFunctionCodeAEO);

    if(partiesContExists[partyIdAEO]){

       bool exists=false;
       uint partiesContLength = partiesContAEO[partyIdAEO].length;
       MasterDataPartyContact[] memory temporaryMasterDataPartyContactArray= partiesContAEO[partyIdAEO];

      for(uint256 i =0; i< partiesContLength; i++){
        if(compareStrings( temporaryMasterDataPartyContactArray[i].contactName, contactNameAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
            partiesContAEO[partyIdAEO].push(newMasterDataPartyContact);
            return true;
          }

    } else{

        partiesContAEO[partyIdAEO].push(newMasterDataPartyContact);
        setExistanceForCertainId(2,partyIdAEO);
        return true;
    }

    return false;
   }
   
   function associateContactComm(string memory contactNameAEO, string memory communicationContNumberAEO, string memory communicationContNumberTypeAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    MasterDataPartyContactCommunication memory newMasterDataPartyContactCommunication= MasterDataPartyContactCommunication(communicationContNumberAEO,communicationContNumberTypeAEO);

    if(partiesContCommExists[contactNameAEO]){

       bool exists=false;
       uint partiesContCommLength = partiesContCommAEO[contactNameAEO].length;
       MasterDataPartyContactCommunication[] memory temporaryMasterDataPartyContactCommArray= partiesContCommAEO[contactNameAEO];

      for(uint256 i =0; i< partiesContCommLength; i++){
        if(compareStrings( temporaryMasterDataPartyContactCommArray[i].communicationNumber, communicationContNumberAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
            partiesContCommAEO[contactNameAEO].push(newMasterDataPartyContactCommunication);
            return true;
          }

    } else{

        partiesContCommAEO[contactNameAEO].push(newMasterDataPartyContactCommunication);
        partiesContCommExists[contactNameAEO]=true;
        return true;
    }

    return false;
   }
   function associateComm(uint256 partyIdAEO, string memory communicationNumberAEO, string memory communicationNumberTypeAEO)
                             internal returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    MasterDataPartyCommunication memory newMasterDataPartyCommunication= MasterDataPartyCommunication(communicationNumberAEO,communicationNumberTypeAEO);

    if(partiesContExists[partyIdAEO]){

       bool exists=false;
       uint partiesCommLength = partiesCommAEO[partyIdAEO].length;
       MasterDataPartyCommunication[] memory temporaryMasterDataPartyCommArray= partiesCommAEO[partyIdAEO];

      for(uint256 i =0; i< partiesCommLength; i++){
        if(compareStrings( temporaryMasterDataPartyCommArray[i].partyCommunicationNumber, communicationNumberAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
            partiesCommAEO[partyIdAEO].push(newMasterDataPartyCommunication);
            return true;
          }

    } else{

        partiesCommAEO[partyIdAEO].push(newMasterDataPartyCommunication);
        setExistanceForCertainId(3,partyIdAEO);
        return true;
    }

    return false;
   }
   
    function associateAdditionalId(uint256 partyIdAEO, uint256 sequenceNumberAEO,  string memory additionalIdentificationCodeAEO, string memory additionalIdentificationIssuingCountryAEO)
                             internal returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    MasterDataPartyAdditionalIdentifier memory newMasterDataPartyAdditionalIdentifier= MasterDataPartyAdditionalIdentifier(sequenceNumberAEO,additionalIdentificationCodeAEO,additionalIdentificationIssuingCountryAEO);

    if(additionalIdentifiersExists[partyIdAEO]){

       bool exists=false;
       uint additionalIdLength = additionalIdentifiersAEO[partyIdAEO].length;
       MasterDataPartyAdditionalIdentifier[] memory temporaryMasterDataPartyAdditionalIdentifierArray= additionalIdentifiersAEO[partyIdAEO];

      for(uint256 i =0; i< additionalIdLength; i++){
        if(temporaryMasterDataPartyAdditionalIdentifierArray[i].sequenceNumber == sequenceNumberAEO){
            exists=true;
            return false;
          }
       }
        if (!exists){
            additionalIdentifiersAEO[partyIdAEO].push(newMasterDataPartyAdditionalIdentifier);
            return true;
          }

    } else{
        additionalIdentifiersAEO[partyIdAEO].push(newMasterDataPartyAdditionalIdentifier);
        setExistanceForCertainId(4,partyIdAEO);
        return true;
    }

    return false;
   }
   
    function associateAdditionalDoc(uint256 partyIdAEO, string memory documentCategoryCodeAEO, string memory documentEffectiveDateAEO, string memory documentExpirationDateAEO, string memory additionalDocumentReferenceNumberAEO, string memory documentMessageStatusAEO, string memory additionalDocumentTypeAEO, string memory manufacturingLocationAEO)
                             internal returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    MasterDataPartyAdditionalDocument memory newMasterDataPartyAdditionalDocument= MasterDataPartyAdditionalDocument(documentCategoryCodeAEO,documentEffectiveDateAEO,documentExpirationDateAEO, additionalDocumentReferenceNumberAEO, documentMessageStatusAEO, additionalDocumentTypeAEO, manufacturingLocationAEO);

    if(additionalDocumentExists[partyIdAEO]){

       bool exists=false;
       uint additionalDocLength = additionalDocumentsAEO[partyIdAEO].length;
       MasterDataPartyAdditionalDocument[] memory temporaryMasterDataPartyAdditionalDocumentArray= additionalDocumentsAEO[partyIdAEO];

      for(uint256 i =0; i< additionalDocLength; i++){
        if(compareStrings(temporaryMasterDataPartyAdditionalDocumentArray[i].additionalDocumentReferenceNumber, additionalDocumentReferenceNumberAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
            additionalDocumentsAEO[partyIdAEO].push(newMasterDataPartyAdditionalDocument);
            return true;
          }

    } else{
        additionalDocumentsAEO[partyIdAEO].push(newMasterDataPartyAdditionalDocument);
        setExistanceForCertainId(5,partyIdAEO);
        return true;
    }
    return false;
   }
   
    function readAEO(string memory functionalReferenceNumberAEO, //string memory senderAEO,
                   string memory partyNameAEO) //uint256 partyIdAEO, string memory roleCodeAEO)
                   public view returns(uint numero){

    if(masterDataPartiesExists[functionalReferenceNumberAEO]){
      //uint indexAEO=masterDataAEOs[functionalReferenceNumberAEO];
      MasterDataParty[] memory temporaryMasterDataPartyArray= masterDataPartiesAEO[functionalReferenceNumberAEO];
      // endDateAEO=AEOs[indexAEO].endDate;
      // recipientAEO="Custom";

      // recipientAEO= AEOs[indexAEO].masterDataRec.recipient;
      for(uint256 i =0; i< temporaryMasterDataPartyArray.length; i++){
        if(compareStrings(temporaryMasterDataPartyArray[i].partyName,partyNameAEO)){
          // partyShortNameAEO=temporaryMasterDataPartyArray[i].partyShortName;
          // businessTypeAEO=temporaryMasterDataPartyArray[i].businessType;
          // identificationIssuingCountryAEO=temporaryMasterDataPartyArray[i].identificationIssuingCountry;
        numero=26;
          return (numero);

        }
      }
    revert('AEO not found');

  }
}

   function compareStrings (string memory a, string memory b) internal pure returns (bool){
       return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
       return true;
  }
}
