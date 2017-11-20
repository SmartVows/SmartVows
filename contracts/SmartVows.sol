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
    uint256 public weddingDate;

    //Marital Status
    string public maritalStatus;

    // Couple Image Hash
    bytes public coupleImageIPFShash;

    // Marriage License Image Hash
    bytes public marriageLicenceImageIPFShash;

    //prenup Image
    bytes public prenupImageIPFShash;
    
    // Last Will Images
    bytes public partner1WillIPFShash;
    bytes public partner2WillIPFShash;

    // Partners Signed Marriage Contract
    bool public partner1_signed;
    bool public partner2_signed;
    
    // Partners Voted to update the prenup
    bool public partner1_voted_prenup_update;
    bool public partner2_voted_prenup_update;
    
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
        string url;
    }

    // Declare Life event structure
    event LifeEvent(string name, string description, string mesg);
        
    function SmartVows(string _partner1, address _partner1_address, string _partner2, address _partner2_address, uint256 _weddingDate, string _maritalStatus, string _officiant, string _witness, string _location, bytes _coupleImageIPFShash, bytes _marriageLicenceImageIPFShash, bytes _prenupImageIPFShash, bytes _partner1WillIPFShash, bytes _partner2WillIPFShash) public{
        
        partner1_name = _partner1;
        partner2_name = _partner2;  
        partner1_address=_partner1_address;
        partner2_address=_partner2_address;
        weddingDate =_weddingDate;
        maritalStatus = _maritalStatus;
        officiant=_officiant;
        witness=_witness;
        location=_location;
        coupleImageIPFShash=_coupleImageIPFShash;
        marriageLicenceImageIPFShash=_marriageLicenceImageIPFShash;
        prenupImageIPFShash = _prenupImageIPFShash;
        partner1WillIPFShash = _partner1WillIPFShash;
        partner2WillIPFShash = _partner2WillIPFShash;
        
        //Record contract creation in events
        saveLifeEvent("Marriage", "Blockchain Marriage contract created","");
        
        //Transfer ownership from SmartVows to Partner 1
        transferOwnership(partner1_address);
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
            partner1_voted_prenup_update = true;
        }
        if(msg.sender == partner2_address){
            partner2_voted_prenup_update = true;
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

    // Update prenup image, but only if both partners have voted to update the prenup
    function updatePrenupImageIPFShash(bytes _newPrenupImageIPFShash) public{
        require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_prenup_update == true)&&(partner2_voted_prenup_update == true));
        prenupImageIPFShash = _newPrenupImageIPFShash;
        partner1_voted_prenup_update = false;
        partner2_voted_prenup_update = false;
    }
    
    // Update partner 1 will, only partner 1 can update
    function updatePartner1_Will_IPFS_Hash(bytes _partner1WillIPFShash) public {
        require(msg.sender == partner1_address);
        partner1WillIPFShash = _partner1WillIPFShash;
    }

    // Update partner 2 will, only partner 2 can update
    function updatePartner2_Will_IPFS_Hash(bytes _partner2WillIPFShash) public {
        require(msg.sender == partner2_address);
        partner2WillIPFShash = _partner2WillIPFShash;
    }
    
}
