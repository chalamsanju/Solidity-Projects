//SPDX-License-Identifier:MIT

pragma solidity ^0.8.21;

contract EventOrgamisation{

    struct Event{

        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint ticketremaining;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextid;

    function createEvent(string calldata name, uint date, uint price, uint ticketcount)public{

        require(block.timestamp<date,"not valible date");
        require(ticketcount>0, "count must be greater then 0");
        events[nextid] =Event(msg.sender,name,date,price,ticketcount,ticketcount);
        nextid++;
    }

    function butTicket(uint id, uint quantity)public payable{

        require(events[id].date!=0, "Event dosnot exist");
        require(events[id].date>block.timestamp,"Event has ended");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity), "Ether is not enough");
        require(_event.ticketremaining>=quantity, "not Enough ticket left");
        _event.ticketremaining-=quantity;
        tickets[msg.sender][id]+=quantity;


        
    }
    

    function transfer(uint id, uint quantity, address to)public payable{

        require(events[id].date!=0, "Event dosnot exist");
        require(events[id].date>block.timestamp,"Event has ended");
        require(tickets[msg.sender][id]>=quantity,"you donot have tickets to transfer");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]++;


    }
}