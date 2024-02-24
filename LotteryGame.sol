//SPDX-License-Identifier:MIT

pragma solidity ^0.8.21;

contract Lottery{

    address public manager;
    address payable[] public players;
    address payable public winner;




    constructor(){

        manager=msg.sender;
    }

    function particpents() public payable{

        require(msg.value==10 wei, "please pay 10 weir");
        
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){

        require(manager==msg.sender, "your not the manager");
        return address(this).balance;
    }

    function random() public view returns(uint){

        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner()public{

      require(manager==msg.sender, "your not the manager");
      require(players.length>=3, "players are less then 3");

      uint r=random();
      uint index=r%players.length;
      winner=players[index];
      winner.transfer(getBalance());
      players = new address payable[](0);
    }


}