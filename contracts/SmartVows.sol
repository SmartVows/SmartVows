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

    // Marriage License Image
    bytes public prenupImage;

    // last Will Image
    bytes public lastWillImage;

    // partners eth address
    address public partner1_address;
    address public partner2_address;

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
        addLifeEvent("Marriage status updated", strConcat("Marriage status upodated by ", toString(msg.sender)), "");
    }


}
