pragma solidity ^0.4.23;

contract CrudAEOStructures {

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

   }
