pragma solidity ^0.4.17;

//SmartVows Marriage Smart Contract for Partner 1 and Partner 2

import './Ownable.sol';
import './Util.sol';

contract SmartVows is Ownable, Util {

    // Names of marriage partners
    string public partner1_name;
    string public partner2_name;
    
    // Partners' eth address
    address public partner1_address;
    address public partner2_address;
    
    // Partners Vows
    string public partner1_vows;
    string public partner2_vows;

    // Marriage Date
    string public marriageDate;

    //Marital Status
    string public maritalStatus;

    // Couple Image Hash
    bytes public coupleImageIPFShash;

    // Marriage License Image Hash
    bytes public marriageLicenceImageIPFShash;

    // prenup Text
    string public prenupAgreement;
    
    //Last Will and Testaments
    string public partner1_will;
    string public partner2_will;

    // Partners Signed Marriage Contract
    bool public partner1_signed;
    bool public partner2_signed;
    
    // Partners Voted to update the prenup
    bool public partner1_voted_update_prenup;
    bool public partner2_voted_update_prenup;
    
    //Partners Voted to update the marriage status
    bool public partner1_voted_update_marriage_status;
    bool public partner2_voted_update_marriage_status;
    
    // Did both partners signed the contract
     bool public is_signed;
    
    // Officiant
    string public officiant;

    // Witnesses
    string public witnesses;

    // Location of marriage
    string public location;
    
    Event[] public lifeEvents;

    struct Event {
        uint date;
        string name;
        string description;
        string mesg;
    }
    
    uint public eventcount; 

    // Declare Life event structure
    event LifeEvent(string name, string description, string mesg);

    function SmartVows(string _partner1, address _partner1_address, string _partner2, address _partner2_address, string _marriageDate, string _maritalStatus, string _officiant, string _witnesses, string _location, bytes _coupleImageIPFShash, bytes _marriageLicenceImageIPFShash) public{        
        partner1_name = _partner1;
        partner2_name = _partner2;  
        partner1_address=_partner1_address;
        partner2_address=_partner2_address;
        marriageDate =_marriageDate;
        maritalStatus = _maritalStatus;
        officiant=_officiant;
        witnesses=_witnesses;
        location=_location;
        coupleImageIPFShash=_coupleImageIPFShash;
        marriageLicenceImageIPFShash=_marriageLicenceImageIPFShash;

        //Record contract creation in events
        saveLifeEvent("", "Blockchain Marriage contract","Marriage posted on the blockchain.");
        
    }

    // Add Life event, either partner can update
    function addLifeEvent(string name, string description, string mesg) public{
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        saveLifeEvent(name, description, mesg);
    }

    function saveLifeEvent(string name, string description, string mesg) private {
        lifeEvents.push(Event(block.timestamp, name, description, mesg));
        LifeEvent(name, description, mesg);
        eventcount++;
    }
    
    // Update partner 1 vows only once
    function updatePartner1_vows(string _partner1_vows) public {
        require((msg.sender == owner || msg.sender == partner1_address) && (bytes(partner1_vows).length == 0));
        partner1_vows = _partner1_vows;
    }

    // Update partner 2 vows only once
    function updatePartner2_vows(string _partner2_vows) public {
        require((msg.sender == owner || msg.sender == partner2_address) && (bytes(partner2_vows).length == 0));
        partner2_vows = _partner2_vows;
    }

    // Update Marriage status only if both partners have previously voted to update the prenup
    function updateMaritalStatus(string _maritalStatus) public {
        require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_update_marriage_status == true)&&(partner2_voted_update_marriage_status == true));
        saveLifeEvent("","Marital status updated", strConcat("Status changed from ", maritalStatus , " to ", _maritalStatus));
        maritalStatus = _maritalStatus;
        partner1_voted_update_marriage_status = false;
        partner2_voted_update_marriage_status = false;
    }

    // Partners can sign the contract
    function sign() public {
        require(msg.sender == partner1_address || msg.sender == partner2_address);
        if(msg.sender == partner1_address){
            partner1_signed = true;
            saveLifeEvent("","Marriage signed", "Marriage signed by Partner 1");
        }else {
            partner2_signed = true;
            saveLifeEvent("","Marriage signed", "Marriage signed by Partner 2");
        }
        
        if(partner1_signed && partner2_signed){// if both signed then make the contract as signed
            is_signed = true;
        }
    }
    
    //Function to vote to allow for updating marital status, both partners must vote true
        function voteToUpdateMaritalStatus() public {
        if(msg.sender == partner1_address){
            partner1_voted_update_marriage_status = true;
            saveLifeEvent("","Vote - Marital Status", "Partner 1 voted to updated Marital Status");
        }
        if(msg.sender == partner2_address){
            partner2_voted_update_marriage_status = true;
            saveLifeEvent("","Vote - Marital Status", "Partner 2 voted to updated Marital Status");
        }
    }
    
    //Function to vote to allow for updating prenup, both partners must vote true to allow update
    function voteToUpdatePrenup() public {
        if(msg.sender == partner1_address){
            partner1_voted_update_prenup = true;
            saveLifeEvent("","Vote - Prenup", "Partner 1 voted to updated Prenuptial Aggreement");
        }
        if(msg.sender == partner2_address){
            partner2_voted_update_prenup = true;
            saveLifeEvent("","Vote - Prenup", "Partner 2 voted to updated Prenuptial Aggreement");
        }
    }

    // Update coupleImage hash, either partner can update
    function updateCoupleImageIPFShash(bytes _coupleImageIPFShash) public{
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        coupleImageIPFShash = _coupleImageIPFShash;
    }

    // Update marriage licence image hash, either partner can update
    function updateMarriageLicenceImageIPFShash(bytes _marriageLicenceImageIPFShash) public{
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        marriageLicenceImageIPFShash = _marriageLicenceImageIPFShash;
    }

    // Update prenup text, but only if both partners have previously agreed to update the prenup
    function updatePrenup(string _prenupAgreement) public{
        require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_update_prenup == true)&&(partner2_voted_update_prenup == true));
        prenupAgreement = _prenupAgreement;
        saveLifeEvent("","Update - Prenup", "Prenuptial Agreement Updated");
        partner1_voted_update_prenup = false;
        partner2_voted_update_prenup = false;
    }
     
    // Update partner 1 will, only partner 1 can update
    function updatePartner1_will(string _partner1_will) public {
        require(msg.sender == partner1_address);
        partner1_will = _partner1_will;
        saveLifeEvent("","Update - Will", "Partner 1 Will Updated");
    }
  
    // Update partner 2 will, only partner 2 can update
    function updatePartner2_will(string _partner2_will) public {
        require(msg.sender == partner2_address);
        partner2_will = _partner2_will;
        saveLifeEvent("","Update - Will", "Partner 2 Will Updated");
    }
    
}
