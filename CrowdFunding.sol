//SPDX-License-Identifier:MIT

pragma solidity ^0.8.21;

contract CrowdFunding{
    

    struct Request{

        string description;
        address payable recepient;
        uint value;
        uint  noofvoters;
        bool completed;
        mapping(address=>bool)  voters;
       
    }


    mapping(address=>uint)public contributors;
    mapping(uint=>Request)public requests;
    uint public numrequest;
    address public manager;
    uint public mincontribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noofcontributors;

    constructor(uint _target, uint _deadline){

        target=_target;
        deadline=_deadline*block.timestamp;
        mincontribution = 100 wei;
        manager = msg.sender;
    }

    modifier onlymanager{

        require(manager==msg.sender, "your not the manager");
        _;
    }

    function createRequest(string calldata _description, address payable _recepient, uint _value)public onlymanager{

      
        Request storage newrequest = requests[numrequest];
        numrequest++;
        newrequest.description=_description;
        newrequest.recepient=_recepient;
        newrequest.value=_value;
        newrequest.completed=false;
        newrequest.noofvoters=0;
    }

    function contribution() public payable{

        require(block.timestamp<deadline, "deadline has passed");
        require(msg.value>mincontribution, "minimum contribution required is 100 wei");

        if(contributors[msg.sender]==0){

             noofcontributors++;
        }

        contributors[msg.sender]+=msg.value;
        raisedAmount+=msg.value;

    }

    function getBalance()public view returns(uint){

        return address(this).balance;
    }

    function refund()public{
        require(block.timestamp>deadline && raisedAmount< target, "not eligible to refund");
        require(contributors[msg.sender]>0, "your not the contributor");
        payable(msg.sender).transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;


    }

    function voteRequest(uint _requestNo)public{

        require(contributors[msg.sender]>=0, "your not the contributor");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false, "you have already voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noofvoters++;



    }

    function makePayment(uint _requestNo)public{

          require(raisedAmount>=target, "Target is not reached");
          Request storage thisRequest=requests[_requestNo];
          require(thisRequest.completed=false,"The request has been completed");
          require(thisRequest.noofvoters>noofcontributors/2, "majority does not support the request");
          thisRequest.recepient.transfer(thisRequest.value);
          thisRequest.completed=true;
    }




}