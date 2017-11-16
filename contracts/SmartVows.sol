pragma solidity ^0.4.17;


import './Ownable.sol';
import './Util.sol';


contract SmartVows is Ownable, Util {

    // Married partner names
    string public partner1_name;
    string public partner2_name;
    
    // Partners eth address
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

    // prenup Text
    string public prenupAgreement;
    
    // Last Will and Testaments
    string public partner1_will;
    string public partner2_will;

    // Partners Signed Marriage Contract
    bool public partner1_signed;
    bool public partner2_signed;
    
    // Partners Voted to update the prenup
    bool public partner1_voted_prenup_update;
    bool public partner2_voted_prenup_update;

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
    event LifeEvent(string name, string description, string url);

    function SmartVows() public{
        
        //For testing
        partner1_name="Mike";
        partner2_name="Tiffany";
        partner1_address=0x1413F25382f9CA2Fd205f8AeaBac3e38b2700136;
        partner2_address=0x186f931e0853FBdE85b44ffF7B777E33b98D1CA0;
        weddingDate = 1177113600;
        maritalStatus = "Married";
        officiant="Joe Mama";
        location="Tampa, FL";
        coupleImageIPFShash="";
        marriageLicenceImageIPFShash="";
        

        //Set contract values
        //partner1_name="%partner1%"
        //partner2_name ="%partner2%"
        //partner1_address="%partner1_address%";
        //partner2_address="%partner2_address%";
        //weddingDate="%weddingDate%";
        //maritalStatus="%maritalStatus%";
        //officiant="%officiant%";
        //location="%location%";
        //coupleImageIPFShash="%coupleImageIPFShash%";
        //marriageLicenceImageIPFShash="%marriageLicenceImageIPFShash%";
        
        //Set vows in additional transaction
        //Update prenup in additional transaction
        //Update wills in additional transaction
        
        //Transfer ownership from SmartVows to Partner 1
        transferOwnership(partner1_address);
        
        //Record contract creation in events
        saveLifeEvent("Marriage", "Blockchain Marriage contract created", "");
    }

    // Add Life event, either partner can update
    function addLifeEvent(string name, string description, string url) public{
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        saveLifeEvent(name, description, url);
    }

    function saveLifeEvent(string name, string description, string url) private {
        lifeEvents.push(Event(block.timestamp, name, description, url));
        LifeEvent(name, description, url);
    }

    // Update Marriage status, either partner can update
    function updateMaritalStatus(string _maritalStatus) public {
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        maritalStatus = _maritalStatus;
        saveLifeEvent("Marriage status updated", strConcat("Marriage status updated by ", toString(msg.sender)), "");
    }

    // Sign the contract, both partners should sign
    function sign() public {
        require(msg.sender == partner1_address || msg.sender == partner2_address);
        if(msg.sender == partner1_address){
            partner1_signed = true;
        }else {
            partner2_signed = true;
        }
        saveLifeEvent("Marriage signed", strConcat("Marriage signed by ", toString(msg.sender)), "");
    }
    
    //Function to vote to allow for updating prenup, both must vote true
    function voteToUpdatePrenup() public {
        if(msg.sender == partner1_address){
            partner1_voted_prenup_update = true;
        }
        if(msg.sender == partner2_address){
            partner2_voted_prenup_update = true;
        }
    }
    
    // Update coupleImage hash, either partner can
    function saveCoupleImage(bytes _coupleImageIPFShash) public{
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        coupleImageIPFShash = _coupleImageIPFShash;
    }

    // Update marriage licence image hash, either partner can
    function saveMarriageLicenceImageIPFShash(bytes _marriageLicenceImageIPFShash) public{
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        marriageLicenceImageIPFShash = _marriageLicenceImageIPFShash;
    }

    // Update prenup text, but only if both partners have previously agreed to update the prenup
    function savePrenupText(string _prenupAgreement) public{
        require((msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address) && (partner1_voted_prenup_update == true)&&(partner2_voted_prenup_update == true));
        prenupAgreement = _prenupAgreement;
        partner1_voted_prenup_update = false;
        partner2_voted_prenup_update = false;
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
    
    // Update partner 1 will, only partner 1 can update
    function updatePartner1_will(string _partner1_will) public {
        require(msg.sender == partner1_address);
        partner1_will = _partner1_will;
    }

    // Update partner 2 will, only partner 2 can update
    function updatePartner2_will(string _partner2_will) public {
        require(msg.sender == partner2_address);
        partner2_will = _partner2_will;
    }

}
