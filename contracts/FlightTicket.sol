// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlightTicket {
    address public owner; // Owner of the contract
    mapping(uint => Ticket) public tickets; // Mapping of tickets
    uint public nextTicketId; // Next ticket ID

    // Ticket struct
    struct Ticket {
        uint id;
        address ticketOwner;
        string passengerName;
        bool checkinCompleted;
    }

    // Event triggered when a new ticket is issued
    event TicketIssued(uint id, address ticketOwner, string passengerName);
    // Event triggered when check-in is completed
    event CheckinCompleted(uint id);
    // Event triggered when a ticket is transferred
    event TicketTransferred(uint id, address newOwner);

    // Constructor to initialize the owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure only the owner can issue tickets
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can issue tickets");
        _;
    }

    // Modifier to ensure only the ticket owner can perform this action
    modifier onlyTicketOwner(uint _id) {
        require(msg.sender == tickets[_id].ticketOwner, "Only the ticket owner can perform this action");
        _;
    }

    // Function to issue a new ticket
    function issueTicket(address _ticketOwner, string memory _passengerName) public onlyOwner {
        nextTicketId++;
        Ticket memory newTicket = Ticket(nextTicketId, _ticketOwner, _passengerName, false);
        tickets[nextTicketId] = newTicket;
        emit TicketIssued(nextTicketId, _ticketOwner, _passengerName);
    }

    // Function to complete the check-in
    function checkIn(uint _id) public onlyTicketOwner(_id) {
        Ticket storage ticket = tickets[_id];
        require(!ticket.checkinCompleted, "Check-in has already been completed");

        ticket.checkinCompleted = true;
        emit CheckinCompleted(_id);
    }

    // Function to transfer the ticket
    function transferTicket(uint _id, address _newOwner) public onlyTicketOwner(_id) {
        Ticket storage ticket = tickets[_id];
        ticket.ticketOwner = _newOwner;
        emit TicketTransferred(_id, _newOwner);
    }
}
