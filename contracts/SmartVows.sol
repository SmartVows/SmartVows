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

    // Wedding Date
    uint256 public marriageDate;

    //Marital Status
    string public maritalStatus;

    // Couple Image Hash
    bytes public coupleImageIPFShash;

    // Marriage License Image Hash
    bytes public marriageLicenceImageIPFShash;

    // prenup Text
    string public prenupAgreement;
    
    //prenup Image
    //bytes public prenupImage
    
    // Partners Signed Marriage Contract
    bool public partner1_signed;
    bool public partner2_signed;
    
    // Partners Voted to update the prenup
    bool public partner1_voted_update_prenup;
    bool public partner2_voted_update_prenup;
    
    //Partners Voted to update the marriage status
    bool public partner1_voted_update_marriage_status;
    bool public partner2_voted_update_marriage_status;
    
    // signed the contract
    bool public is_signed;
    
    // Officiant
    string public officiant;

    // Witness
    string public witness;

    // Location of marriage
    string public location;
    
    Event[] public lifeEvents;

    struct Event {
        uint date;
        string name;
        string description;
        string mesg;
    }

    // Declare Life event structure
    event LifeEvent(string name, string description, string mesg);
        
    function SmartVows(string _partner1, address _partner1_address, string _partner2, address _partner2_address, uint256 _marriageDate, string _maritalStatus, string _officiant, string _witness, string _location, bytes _coupleImageIPFShash, bytes _marriageLicenceImageIPFShash) public{        
        partner1_name = _partner1;
        partner2_name = _partner2;  
        partner1_address=_partner1_address;
        partner2_address=_partner2_address;
        marriageDate =_marriageDate;
        maritalStatus = _maritalStatus;
        officiant=_officiant;
        witness=_witness;
        location=_location;
        coupleImageIPFShash=_coupleImageIPFShash;
        marriageLicenceImageIPFShash=_marriageLicenceImageIPFShash;

        //Record contract creation in events
        saveLifeEvent("Marriage", "Blockchain Marriage contract created","");
        
        //Transfer ownership from SmartVows to Partner 1
        //transferOwnership(partner1_address);
    }

    // Add Life event, either partner can update
    function addLifeEvent(string name, string description, string mesg) public{
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        saveLifeEvent(name, description, mesg);
    }

    function saveLifeEvent(string name, string description, string mesg) private {
        lifeEvents.push(Event(block.timestamp, name, description, mesg));
        LifeEvent(name, description, mesg);
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

    // Update Marriage status, but only if both partners have previously agreed to update the prenup
    function updateMaritalStatus(string _maritalStatus) public {
        //require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_update_marriage_status == true)&&(partner2_voted_update_marriage_status == true));
        maritalStatus = _maritalStatus;
        saveLifeEvent("Marriage status updated", strConcat("Marriage status updated by", toString(msg.sender)),"");
        partner1_voted_update_marriage_status = false;
        partner2_voted_update_marriage_status = false;
    }

    // Sign the contract, both partners should sign
    function sign() public {
        require(msg.sender == partner1_address || msg.sender == partner2_address);
        if(msg.sender == partner1_address){
            partner1_signed = true;
        }else {
            partner2_signed = true;
        }
        // if both signed then make the contract as signed
        if(partner1_signed && partner2_signed){
            is_signed = true;
        }
        saveLifeEvent("Marriage signed", strConcat("Marriage signed by ", toString(msg.sender)),"");
    }
    
    //Function to vote to allow for updating marital status, both partners must vote true
        function voteToUpdateMaritalStatus() public {
        if(msg.sender == partner1_address){
            partner1_voted_update_marriage_status = true;
        }
        if(msg.sender == partner2_address){
            partner2_voted_update_marriage_status = true;
        }
    }
    
    //Function to vote to allow for updating prenup, both partners must vote true
    function voteToUpdatePrenup() public {
        if(msg.sender == partner1_address){
            partner1_voted_update_prenup = true;
        }
        if(msg.sender == partner2_address){
            partner2_voted_update_prenup = true;
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
        partner1_voted_update_prenup = false;
        partner2_voted_update_prenup = false;
    }

}
