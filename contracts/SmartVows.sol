pragma solidity ^0.4.17;


import './Ownable.sol';


contract SmartVows is Ownable {

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

    function SmartVows(string _partner1, string _partner2, uint256 _weddingDate, string url) public{
        partner1 = _partner1;
        partner2 = _partner2;
        weddingDate = _weddingDate;
        marriageStatus = "married";
        lifeEvents.push(Event(block.timestamp, "Marriage", "Marriage registration", url));
        LifeEvent("Marrigage", "Marriage registration", url);
    }


}
