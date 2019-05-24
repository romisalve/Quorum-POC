pragma solidity ^0.4.23;

import "./CrudAEOStructures.sol" ;

contract CrudAEOUpdateAndDelete is CrudAEOStructures {

  /* Keep functional reference number and acts as if Create procedure is taking place for
  that master data Party. Delete that masterDataParty from the array
  */
  function updateRegisteredAEO (string functionalReferenceNumberAEO, string partyNameAEO) internal view returns (uint256 idOfAEOToModify) {
      
    MasterDataParty[] memory temporaryMasterDataPartyArray= masterDataPartiesAEO[functionalReferenceNumberAEO];

    uint256 masterDataPartiesLength =temporaryMasterDataPartyArray.length;
    uint256 partyIdToMod;
    for(uint256 i =0; i< masterDataPartiesLength; i++){ 
      if(compareStrings(temporaryMasterDataPartyArray[i].partyName,partyNameAEO)){
          partyIdToMod=temporaryMasterDataPartyArray[i].partyId;
          /*It is assumed that no field of Master Data Party is being changed, and that
          all the mappings associated to it are going to be created from scratch    
          */
        }
     }
     return partyIdToMod;
  }

  function updateAddress(string functionalReferenceNumberAEO, string partyNameAEO,
                         string typeOfAddressAEO, string cityNameAEO, string countryCodeAEO, string countryNameAEO, string countrySubEntityIdentificationAEO, string streetAEO, uint256 numberAEO, string postCodeIdAEO)
                         public{

    uint256 partyIdToMod=updateRegisteredAEO(functionalReferenceNumberAEO,partyNameAEO);
    delete addressesAEO[partyIdToMod]; 

    MasterDataPartyAddress memory newMasterDataPartyAddress= MasterDataPartyAddress(typeOfAddressAEO, cityNameAEO, countryCodeAEO, countryNameAEO, countrySubEntityIdentificationAEO, streetAEO, numberAEO, postCodeIdAEO);
    addressesAEO[partyIdToMod].push(newMasterDataPartyAddress);

}

  function updateContactAndComm(string functionalReferenceNumberAEO, string partyNameAEO,
                                string contactNameAEO, string contactFunctionCode,
                                string communicationNumberAEO, string communicationNumberTypeAEO)
                                public{

    uint256 partyIdToMod=updateRegisteredAEO(functionalReferenceNumberAEO,partyNameAEO);
    delete partiesContAEO[partyIdToMod]; //delete mapping of contacts associated to that partyID
    delete partiesContCommAEO[contactNameAEO]; //delete mapping of comm numbers associated to that contactName

    MasterDataPartyContact memory newMasterDataPartyContact= MasterDataPartyContact(contactNameAEO,contactFunctionCode);
    partiesContAEO[partyIdToMod].push(newMasterDataPartyContact);
    MasterDataPartyContactCommunication memory newMasterDataPartyContactCommunication= MasterDataPartyContactCommunication(communicationNumberAEO,communicationNumberTypeAEO);
    partiesContCommAEO[contactNameAEO].push(newMasterDataPartyContactCommunication);
}

  function updateComm(string functionalReferenceNumberAEO, string partyNameAEO,
                      string partyCommunicationNumberAEO, string partyCommunicationNumberTypeAEO)
                      public{

    uint256 partyIdToMod=updateRegisteredAEO(functionalReferenceNumberAEO,partyNameAEO);
    delete partiesCommAEO[partyIdToMod]; 

    MasterDataPartyCommunication memory newMasterDataPartyCommunication= MasterDataPartyCommunication(partyCommunicationNumberAEO, partyCommunicationNumberTypeAEO);
    partiesCommAEO[partyIdToMod].push(newMasterDataPartyCommunication);

}

  function updateAdditionalId(string functionalReferenceNumberAEO, string partyNameAEO,
                              uint256 sequenceNumberAEO, string additionalIdentificationCodeAEO, string additionalIdentificationIssuingCountryAEO)
                              public{

    uint256 partyIdToMod=updateRegisteredAEO(functionalReferenceNumberAEO,partyNameAEO);
    delete additionalIdentifiersAEO[partyIdToMod]; 

    MasterDataPartyAdditionalIdentifier memory newMasterDataPartyAdditionalIdentifier= MasterDataPartyAdditionalIdentifier(sequenceNumberAEO, additionalIdentificationCodeAEO, additionalIdentificationIssuingCountryAEO);
    additionalIdentifiersAEO[partyIdToMod].push(newMasterDataPartyAdditionalIdentifier);

}

  function updateAdditionalDoc(string functionalReferenceNumberAEO, string partyNameAEO,
                              string documentCategoryCodeAEO, string documentEffectiveDateAEO, string documentExpirationDateAEO, string additionalDocumentReferenceNumberAEO, string documentMessageStatusAEO, string additionalDocumentTypeAEO, string manufacturingLocationAEO)
                              public{

    uint256 partyIdToMod=updateRegisteredAEO(functionalReferenceNumberAEO,partyNameAEO);
    delete additionalDocumentsAEO[partyIdToMod]; 

    MasterDataPartyAdditionalDocument memory newMasterDataPartyAdditionalDocument= MasterDataPartyAdditionalDocument(documentCategoryCodeAEO, documentEffectiveDateAEO, documentExpirationDateAEO, additionalDocumentReferenceNumberAEO, documentMessageStatusAEO, additionalDocumentTypeAEO, manufacturingLocationAEO);
    additionalDocumentsAEO[partyIdToMod].push(newMasterDataPartyAdditionalDocument);

}

  function deleteAEO(string functionalReferenceNumberAEO, bytes32 currentDate)
                     public{
    require(masterDataPartiesExists[functionalReferenceNumberAEO]);
    //shows all fields of registered AEO, is calling the read operations
    //set endDate to operation date 
    uint indexAEO=masterDataAEOs[functionalReferenceNumberAEO];
    AEOs[indexAEO].endDate=currentDate;
    emit AEODelete(functionalReferenceNumberAEO);
 

}




 }
