// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for ERC20 tokens
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// Barbershop contract
contract Barbershop {
    address public owner; // owner of the barbershop
    mapping(uint => Service) public services; // mapping of services
    uint public nextServiceId; // next service ID

    // Service struct
    struct Service {
        uint id;
        string serviceName;
        uint price;
        bool completed;
    }

    // Event triggered when a service is completed
    event ServiceCompleted(uint id, address customer, string serviceName);

    // Constructor initializes the owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure only the owner can add services
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can add services");
        _;
    }

    // Add a service
    function addService(string memory _serviceName, uint _price) public onlyOwner {
        nextServiceId++;
        Service memory newService = Service(nextServiceId, _serviceName, _price, false);
        services[nextServiceId] = newService;
    }

    // Perform a service
    function performService(uint _id, address _tokenERC20) public {
        Service storage service = services[_id];
        require(!service.completed, "Service has already been completed");
        require(_tokenERC20 != address(0), "Invalid ERC20 token address");

        IERC20 token = IERC20(_tokenERC20);
        require(token.transferFrom(msg.sender, owner, service.price), "Token transfer failed");

        service.completed = true;
        emit ServiceCompleted(_id, msg.sender, service.serviceName);
    }
}
