pragma solidity ^0.4.17;


import './Ownable.sol';
import './Util.sol';


contract SmartVows is Ownable, Util {

    // partners for contract
    string public partner1;
    string public partner2;

    // Wedding date
    uint256 public weddingDate;

    //Marriage status
    bytes32 public marriageStatus;

    // Couple Image
    bytes public coupleImage;

    // Marriage License Image
    bytes public marriageLicenceImage;

    // prenup Image
    bytes public prenupImage;

    // Last Will Image
    bytes public lastWillImage;

    // Partners eth address
    address public partner1_address;
    address public partner2_address;

    // Partners Vows
    string public partner1_vows;
    string public partner2_vows;

    // Partners Signed
    bool public partner1_signed;
    bool public partner2_signed;

    // signed the contract
    bool public is_signed;

    // Brides maid
    string public bridesmaid;

    // Grooms men
    string public groomsmen;

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

    function SmartVows(string _partner1, address _partner1_address, string _partner2, address _partner2_address, uint256 _weddingDate, string url) public{
        partner1 = _partner1;
        partner2 = _partner2;
        partner1_address = _partner1_address;
        //check if partner 1 address is present
        if(_partner1_address != address(0)){
            //transfer ownership
            transferOwnership(partner1_address);
        }
        partner2_address = _partner2_address;
        weddingDate = _weddingDate;
        marriageStatus = "married";
        addLifeEvent("Marriage", "Marriage registration", url);
    }

    function addLifeEvent(string name, string description, string url) private {
        lifeEvents.push(Event(block.timestamp, name, description, url));
        LifeEvent(name, description, url);
    }

    // Add Partner 1 address only if by owner and already not present
    function addPartner1Address(address _partner1_address) public onlyOwner{
        require(partner1_address == address(0));
        partner1_address = _partner1_address;
        transferOwnership(partner1_address);
    }

    // Add Partner 2 address only if by owner and already not present
    function addPartner2Address(address _partner2_address) public onlyOwner{
        require(partner2_address == address(0));
        partner2_address = _partner2_address;
    }

    // Update Marriage status
    function updateMarriageStatus(bytes32 _marriageStatus) public {
        require(msg.sender == owner || msg.sender == partner1_address || msg.sender == partner2_address);
        marriageStatus = _marriageStatus;
        addLifeEvent("Marriage status updated", strConcat("Marriage status updated by ", toString(msg.sender)), "");
    }

    // Sign the contract
    function sign() public {
        require(msg.sender == partner1_address || msg.sender == partner2_address);
        if(msg.sender == partner1_address){
            partner1_signed = true;
        }else {
            partner2_signed = true;
        }
        addLifeEvent("Marriage signed", strConcat("Marriage signed by ", toString(msg.sender)), "");
    }

    // Save coupleImage hash
    function saveCoupleImage(bytes _coupleImage) public onlyOwner{
        coupleImage = _coupleImage;
    }

    // Save marriage licence image hash
    function saveMarriageLicenceImage(bytes _marriageLicenceImage) public onlyOwner{
        marriageLicenceImage = _marriageLicenceImage;
    }

    // Save prenup image hash
    function savePrenupImage(bytes _prenupImage) public onlyOwner{
        prenupImage = _prenupImage;
    }

    // Save last will image hash
    function saveLastWillImage(bytes _lastWillImage) public onlyOwner{
        lastWillImage = _lastWillImage;
    }

    // Save Brides maid only once
    function setBridesmaid(string _bridesmaid) public onlyOwner{
        require(bytes(bridesmaid).length == 0);
        bridesmaid = _bridesmaid;
    }

    // Save grooms men only once
    function setGroomsmen(string _groomsmen) public onlyOwner{
        require(bytes(groomsmen).length == 0);
        groomsmen = _groomsmen;
    }

    // Save officiant only once
    function setOfficiant(string _officiant) public onlyOwner{
        require(bytes(officiant).length == 0);
        officiant = _officiant;
    }

    // Save witness only once
    function setWitness(string _witness) public onlyOwner{
        require(bytes(witness).length == 0);
        witness = _witness;
    }

    // Save Location only once
    function setLocation(string _location) public onlyOwner{
        require(bytes(location).length == 0);
        location = _location;
    }


}
