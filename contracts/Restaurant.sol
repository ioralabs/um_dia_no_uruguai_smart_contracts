// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for ERC20 tokens
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// Restaurant contract
contract Restaurant {
    address public owner; // Owner of the restaurant
    mapping(uint => Dish) public dishes; // Mapping of dishes
    uint public nextDishId; // Next ID for a new dish

    // Dish struct
    struct Dish {
        uint id;
        string name;
        uint price;
        bool sold;
    }

    // Event triggered when a dish is sold
    event DishSold(uint id, address customer, string name);

    // Constructor to initialize the owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure only the owner can add dishes
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can add dishes");
        _;
    }

    // Function to add a new dish
    function addDish(string memory _name, uint _price) public onlyOwner {
        nextDishId++;
        Dish memory newDish = Dish(nextDishId, _name, _price, false);
        dishes[nextDishId] = newDish;
    }

    // Function to purchase a dish
    function buyDish(uint _id, address _tokenERC20) public {
        Dish storage dish = dishes[_id];
        require(!dish.sold, "Dish has already been sold");

        IERC20 token = IERC20(_tokenERC20);
        require(token.transferFrom(msg.sender, owner, dish.price), "Token transfer failed");

        dish.sold = true;
        emit DishSold(_id, msg.sender, dish.name);
    }
}
