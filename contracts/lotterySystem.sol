// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
contract lotterySystem is ERC721 {
    using SafeMath for uint256;
    address public owner;
    uint256 totalAmount = 0;
    uint256 ticketprice = 0.1 ether;
    uint256 sold_tickets = 5 ;
    uint256 ticketcounter;
    mapping(address => bool) public person;
    address[] public _person;
    string public collectionName;
    string public collectionNameSymbol;
    event TicketBuy(uint256 ticketId);
    event Pickwinner();
    constructor() ERC721("Lottery System Collection", "LSC") {
    collectionName = name();
    collectionNameSymbol = symbol();
    owner = msg.sender;
    }
    receive() external payable {}
    function ticket(uint256 amount) external {
        require(!_exists(ticketcounter));
        require (msg.sender == owner,"owner can");
        for(uint256 i = ticketcounter; i<= amount; i++){
        // mint the token
        _mint(msg.sender, i);
        ticketcounter = i;
        }
    }
    function purchaseticket(uint256 ticketId) public payable {
        require(msg.value == ticketprice, "value should be 0.1 ether");
        require(person[msg.sender] == false, "user already participiant");
        _person.push(msg.sender);
        person[msg.sender] = true;
        payable(address(this)).transfer(ticketprice);
        _transfer(owner,msg.sender,ticketId);
        totalAmount = totalAmount.add(ticketprice);
        emit  TicketBuy (ticketId);
    }
    function changevale(uint256 _ticketprice) public {
        require(msg.sender == owner, "owner can call ");
        ticketprice = _ticketprice;
    }
    function getBalance() public view returns (uint) {
        // return the current balance of smart contract
        return address(this).balance;
    }
    function reset() internal {
        // iterate over the array to iterate over the mapping and reset all to value
        for (uint i = 0; i < _person.length; i++) {
            person[_person[i]] = false;
        }
    }
    function random() private view returns (uint256) {
        // select a random person from person aray  
        return uint256(keccak256(abi.encode(block.timestamp, _person)));
    }
    function pickWinner() public {
        require(_person.length == sold_tickets, "tickets is not sold for certain amount");
        uint256 index1 = random() % _person.length;
        payable(_person[index1]).transfer(getBalance());
        _person = new address[](0);
        totalAmount = 0;
        reset();
        emit Pickwinner();
    }
}