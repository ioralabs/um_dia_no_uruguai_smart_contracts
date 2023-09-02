// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract CoffeeShop {
    address public owner; // owner of the CoffeeShop
    mapping(uint => Coffee) public coffees; // mapping of coffees
    uint public nextCoffeeId; // next coffee ID

    // Coffee struct
    struct Coffee {
        uint id;
        string name;
        uint price;
        bool sold;
    }

    // Event triggered when a coffee is sold
    event CoffeeSold(uint id, address customer, string name);

    // Constructor initializes the owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure only the owner can add coffees
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can add coffees");
        _;
    }

    // Add a coffee
    function addCoffee(string memory _name, uint _price) public onlyOwner {
        nextCoffeeId++;
        Coffee memory newCoffee = Coffee(nextCoffeeId, _name, _price, false);
        coffees[nextCoffeeId] = newCoffee;
    }

    // Purchase a coffee
    function buyCoffee(uint _id, address _tokenERC20) public {
        Coffee storage coffee = coffees[_id];
        require(!coffee.sold, "Coffee has already been sold");

        IERC20 token = IERC20(_tokenERC20);
        require(token.transferFrom(msg.sender, owner, coffee.price), "Token transfer failed");

        coffee.sold = true;
        emit CoffeeSold(_id, msg.sender, coffee.name);
    }
}
