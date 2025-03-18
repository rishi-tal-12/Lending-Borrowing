//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.28;
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
contract Token1 is ERC20{
    constructor(uint intialsupply)ERC20("Shinchan","SC"){
        _mint(msg.sender,intialsupply);
   
    }
}
contract Token2 is ERC20{
    constructor(uint intialsupply)ERC20("Harrypotter"," HP"){
        _mint(msg.sender,intialsupply);
    }
}