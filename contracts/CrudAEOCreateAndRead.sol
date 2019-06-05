pragma solidity ^0.4.23;

import "./CrudAEOStructures.sol" ;

import { StructuresAndVariables } from "./CrudAEOStructures.sol" ;


contract CrudAEOCreateAndRead //is CrudAEOStructures 

{

event AEOEvent(string AEOfunctionalReferenceNumber, uint256 messageFunctionCodeAEO);

event AEOUNamepdate(string AEOpartyOldName , string AEOpartyNewName);  

CrudAEOStructures public contractNeeded;  

constructor(address addressOfDeployedCrudAEOStructures) public {
       // bytecode will be loaded into memory from an existing deployment
       CrudAEOStructures public contractNeeded= CrudAEOStructures(addressOfDeployedCrudAEOStructures);
   }

 function createMasterDataAEO (uint256 messageFunctionCodeAEO, string memory functionalReferenceNumberAEO, string memory documentNameAEO,
                                 string memory recipientTypeAEO, string memory recipientAEO,
                                 string memory senderTypeAEO, string memory senderAEO,
                                 string endDateAEO)
                                 public returns (uint256 newTotalAEOs){
    bool exists= false;

    StructuresAndVariables.MasterDataRecipient memory newMasterDataRecipient= StructuresAndVariables.MasterDataRecipient(recipientTypeAEO, recipientAEO);
    StructuresAndVariables.MasterDataSender memory newMasterDataSender= StructuresAndVariables.MasterDataSender(senderTypeAEO, senderAEO);
    StructuresAndVariables.AEOMasterData memory newAEO = StructuresAndVariables.AEOMasterData(messageFunctionCodeAEO, functionalReferenceNumberAEO, documentNameAEO, newMasterDataRecipient, newMasterDataSender, endDateAEO);

    for(uint256 i =0; i< contractNeeded.totalAEOs(); i++){

      if(compareStrings(contractNeeded.retrieveFRN(i), functionalReferenceNumberAEO)){
          exists=true;
        }
     }
      if (!exists){
             contractNeeded.insertNewAEO(newAEO);
             contractNeeded.increaseTotalAEOs();
             contractNeeded.masterDataAEOsmapping(functionalReferenceNumberAEO,contractNeeded.totalAEOs());
             //emit event
             emit AEOEvent (functionalReferenceNumberAEO, messageFunctionCodeAEO);
          }

        return contractNeeded.totalAEOs();
   }
   
    //associate a Master Data Party to a Master Data
   function associateMasterDataParty(string memory functionalReferenceNumberAEO, string memory partyNameAEO, string memory partyShortNameAEO, string memory businessTypeAEO, uint256 partyIdAEO, string memory identificationIssuingCountryAEO, string memory roleCodeAEO)
                   public returns(bool){



    StructuresAndVariables.MasterDataParty memory newMasterDataParty= StructuresAndVariables.MasterDataParty(partyNameAEO, partyShortNameAEO, businessTypeAEO, partyIdAEO, identificationIssuingCountryAEO, roleCodeAEO);


    if(contractNeeded.masterDataPartiesExists[functionalReferenceNumberAEO]){

       bool exists=false;
       uint masterDataPartyLength = contractNeeded.masterDataPartiesAEO[functionalReferenceNumberAEO].length;
       StructuresAndVariables.MasterDataParty[] memory temporaryMasterDataPartyArray= contractNeeded.masterDataPartiesAEO[functionalReferenceNumberAEO];

      for(uint256 i =0; i< masterDataPartyLength; i++){
        //aca posible cambio para retrieve name 
        if(compareStrings(contractNeeded.retrievePartyName(temporaryMasterDataPartyArray,i),partyNameAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
                contractNeeded.masterDataPartiesAEOmapping(functionalReferenceNumberAEO, newMasterDataParty);
                return true;
          }

    } else{

        contractNeeded.masterDataPartiesAEOmapping(functionalReferenceNumberAEO, newMasterDataParty);
        contractNeeded.setExistance(1,functionalReferenceNumberAEO);
        return true;
    }

    return false;
   }
   
    //stack too deep compile error, couldnt set it inside func associate address


   //Associate an AddressAndContact to certain masterDataParty si le agrego un error da stack too deep compile error
   //Cant add return value, stack too deep error compile
   
    function associateAddress(uint256 partyIdAEO, string memory typeOfAddressAEO, string memory cityNameAEO, string memory countryCodeAEO, string memory countryNameAEO, string memory countrySubEntityIdentificationAEO, string memory streetAEO, uint256 numberAEO, string memory postCodeIdAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it         
    StructuresAndVariables.MasterDataPartyAddress memory newMasterDataPartyAddress= StructuresAndVariables.MasterDataPartyAddress(typeOfAddressAEO, cityNameAEO, countryCodeAEO, countryNameAEO, countrySubEntityIdentificationAEO, streetAEO, numberAEO, postCodeIdAEO);

    if(contractNeeded.addressExists[partyIdAEO]){

       //bool exists=false;
       uint addressLength = contractNeeded.addressesAEO[partyIdAEO].length;
       StructuresAndVariables.MasterDataPartyAddress[] memory temporaryMasterDataPartyAddressArray= contractNeeded.addressesAEO[partyIdAEO];

      for(uint256 i =0; i< addressLength; i++){
        //posible cambio retrieve address
        if(compareStrings( temporaryMasterDataPartyAddressArray[i].street,  streetAEO) && (temporaryMasterDataPartyAddressArray[i].number==numberAEO)) {
            //exists=true;
            return false;
          }
       }
        //if (!exists){
                contractNeeded.addressesAEOmapping(partyIdAEO, newMasterDataPartyAddress);
                return true;
          //}

    } else{

        contractNeeded.addressesAEOmapping(partyIdAEO, newMasterDataPartyAddress);
        contractNeeded.setExistanceForCertainId(1,partyIdAEO);
        return true;
    }

    //return false;
  }
  
   function associateContact(uint256 partyIdAEO, string memory contactNameAEO, string memory contactFunctionCodeAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    StructuresAndVariables.MasterDataPartyContact memory newMasterDataPartyContact= StructuresAndVariables.MasterDataPartyContact(contactNameAEO,contactFunctionCodeAEO);

    if(contractNeeded.partiesContExists[partyIdAEO]){

       bool exists=false;
       uint partiesContLength = contractNeeded.partiesContAEO[partyIdAEO].length;
       StructuresAndVariables.MasterDataPartyContact[] memory temporaryMasterDataPartyContactArray= contractNeeded.partiesContAEO[partyIdAEO];

      for(uint256 i =0; i< partiesContLength; i++){
        if(compareStrings( temporaryMasterDataPartyContactArray[i].contactName, contactNameAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
            contractNeeded.partiesContAEOmapping(partyIdAEO,newMasterDataPartyContact);
            return true;
          }

    } else{

        contractNeeded.partiesContAEOmapping(partyIdAEO,newMasterDataPartyContact);
        contractNeeded.setExistanceForCertainId(2,partyIdAEO);
        return true;
    }

    return false;
   }
   
   function associateContactComm(string memory contactNameAEO, string memory communicationContNumberAEO, string memory communicationContNumberTypeAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    StructuresAndVariables.MasterDataPartyContactCommunication memory newMasterDataPartyContactCommunication= StructuresAndVariables.MasterDataPartyContactCommunication(communicationContNumberAEO,communicationContNumberTypeAEO);

    if(contractNeeded.partiesContCommExists[contactNameAEO]){

       bool exists=false;
       uint partiesContCommLength = contractNeeded.partiesContCommAEO[contactNameAEO].length;
       StructuresAndVariables.MasterDataPartyContactCommunication[] memory temporaryMasterDataPartyContactCommArray= contractNeeded.partiesContCommAEO[contactNameAEO];

      for(uint256 i =0; i< partiesContCommLength; i++){
        if(compareStrings( temporaryMasterDataPartyContactCommArray[i].communicationNumber, communicationContNumberAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
            contractNeeded.partiesContCommAEOmapping(contactNameAEO, newMasterDataPartyContactCommunication);
            return true;
          }

    } else{

        contractNeeded.partiesContCommAEOmapping(contactNameAEO, newMasterDataPartyContactCommunication);
        contractNeeded.setExistance(2,contactNameAEO);
        return true;
    }

    return false;
   }
   function associateComm(uint256 partyIdAEO, string memory communicationNumberAEO, string memory communicationNumberTypeAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    StructuresAndVariables.MasterDataPartyCommunication memory newMasterDataPartyCommunication= StructuresAndVariables.MasterDataPartyCommunication(communicationNumberAEO,communicationNumberTypeAEO);

    if(contractNeeded.partiesCommExists[partyIdAEO]){

       bool exists=false;
       uint partiesCommLength = contractNeeded.partiesCommAEO[partyIdAEO].length;
       StructuresAndVariables.MasterDataPartyCommunication[] memory temporaryMasterDataPartyCommArray= contractNeeded.partiesCommAEO[partyIdAEO];

      for(uint256 i =0; i< partiesCommLength; i++){
        if(compareStrings( temporaryMasterDataPartyC ommArray[i].partyCommunicationNumber, communicationNumberAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
            contractNeeded.partiesCommAEOmapping(partyIdAEO, newMasterDataPartyCommunication);
            return true;
          }

    } else{

        contractNeeded.partiesCommAEOmapping(partyIdAEO, newMasterDataPartyCommunication);
        contractNeeded.setExistanceForCertainId(3,partyIdAEO);
        return true;
    }

    return false;
   }
   
    function associateAdditionalId(uint256 partyIdAEO, uint256 sequenceNumberAEO,  string memory additionalIdentificationCodeAEO, string memory additionalIdentificationIssuingCountryAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    StructuresAndVariables.MasterDataPartyAdditionalIdentifier memory newMasterDataPartyAdditionalIdentifier= StructuresAndVariables.MasterDataPartyAdditionalIdentifier(sequenceNumberAEO,additionalIdentificationCodeAEO,additionalIdentificationIssuingCountryAEO);

    if(contractNeeded.additionalIdentifiersExists[partyIdAEO]){

       bool exists=false;
       uint additionalIdLength = contractNeeded.additionalIdentifiersAEO[partyIdAEO].length;
       StructuresAndVariables.MasterDataPartyAdditionalIdentifier[] memory temporaryMasterDataPartyAdditionalIdentifierArray= contractNeeded.additionalIdentifiersAEO[partyIdAEO];

      for(uint256 i =0; i< additionalIdLength; i++){
        if(temporaryMasterDataPartyAdditionalIdentifierArray[i].sequenceNumber == sequenceNumberAEO){
            exists=true;
            return false;
          }
       }
        if (!exists){
            contractNeeded.additionalIdentifiersAEOmapping(partyIdAEO,newMasterDataPartyAdditionalIdentifier);
            return true;
          }

    } else{
        contractNeeded.additionalIdentifiersAEOmapping(partyIdAEO,newMasterDataPartyAdditionalIdentifier);
        contractNeeded.setExistanceForCertainId(4,partyIdAEO);
        return true;
    }

    return false;
   }
   
    function associateAdditionalDoc(uint256 partyIdAEO, string memory documentCategoryCodeAEO, string memory documentEffectiveDateAEO, string memory documentExpirationDateAEO, string memory additionalDocumentReferenceNumberAEO, string memory documentMessageStatusAEO, string memory additionalDocumentTypeAEO, string memory manufacturingLocationAEO)
                             public returns (bool) {
    //A variable declaration could be avoided by setting the struct directly when pushing it
    StructuresAndVariables.MasterDataPartyAdditionalDocument memory newMasterDataPartyAdditionalDocument= StructuresAndVariables.MasterDataPartyAdditionalDocument(documentCategoryCodeAEO,documentEffectiveDateAEO,documentExpirationDateAEO, additionalDocumentReferenceNumberAEO, documentMessageStatusAEO, additionalDocumentTypeAEO, manufacturingLocationAEO);

    if(contractNeeded.additionalDocumentExists[partyIdAEO]){

       bool exists=false;
       uint additionalDocLength = contractNeeded.additionalDocumentsAEO[partyIdAEO].length;
       StructuresAndVariables.MasterDataPartyAdditionalDocument[] memory temporaryMasterDataPartyAdditionalDocumentArray= contractNeeded.additionalDocumentsAEO[partyIdAEO];

      for(uint256 i =0; i< additionalDocLength; i++){
        if(compareStrings(temporaryMasterDataPartyAdditionalDocumentArray[i].additionalDocumentReferenceNumber, additionalDocumentReferenceNumberAEO)){
            exists=true;
            return false;
          }
       }
        if (!exists){
            contractNeeded.additionalDocumentsAEOmapping(partyIdAEO,newMasterDataPartyAdditionalDocument);
            return true;
          }

    } else{
        contractNeeded.additionalDocumentsAEOmapping(partyIdAEO,newMasterDataPartyAdditionalDocument);
        contractNeeded.setExistanceForCertainId(5,partyIdAEO);
        return true;
    }
    return false;
   }
   
    function readAEO(string memory functionalReferenceNumberAEO, //string memory senderAEO,
                   string memory partyNameAEO) //uint256 partyIdAEO, string memory roleCodeAEO)
                   public view returns(string endDateAEO, string memory recipientAEO,
                                    string memory partyShortNameAEO, string memory businessTypeAEO, string memory identificationIssuingCountryAEO)
{

    if(contractNeeded.masterDataPartiesExists[functionalReferenceNumberAEO]){
      uint indexAEO= contractNeeded.masterDataAEOs[functionalReferenceNumberAEO];
      StructuresAndVariables.MasterDataParty[] memory temporaryMasterDataPartyArray= contractNeeded.masterDataPartiesAEO[functionalReferenceNumberAEO];
      endDateAEO= contractNeeded.AEOs[indexAEO].endDate;
      recipientAEO="Custom";
      //recipientAEO= AEOs[indexAEO].masterDataRec.recipient;
      for(uint256 i =0; i< temporaryMasterDataPartyArray.length; i++){
        if(compareStrings(temporaryMasterDataPartyArray[i].partyName,partyNameAEO)){
           partyShortNameAEO=temporaryMasterDataPartyArray[i].partyShortName;
           businessTypeAEO=temporaryMasterDataPartyArray[i].businessType;
           identificationIssuingCountryAEO=temporaryMasterDataPartyArray[i].identificationIssuingCountry;
       
          return (endDateAEO,recipientAEO,partyShortNameAEO,businessTypeAEO,identificationIssuingCountryAEO);

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
