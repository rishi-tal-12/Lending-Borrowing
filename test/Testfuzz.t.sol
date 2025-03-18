//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.28;
import {Lending} from "src/Lending.sol";
import {Test} from "lib/forge-std/src/Test.sol";
import {console} from "lib/forge-std/src/console.sol";

contract Fuzztest is Test{
    Lending lending;
    mapping(address => uint256) public collateraldepositedvalue;
    mapping(address=> uint256) public borrowedtokenamountvalue;
    function setUp()public{
        lending = new Lending();
    }

function testmainf(uint256 collateral)public{
 address token2 = lending.gettoken2();
 vm.assume( collateral>0 && collateral<1e36);
uint256 token1value =lending.gettoken1price();
uint256 token2value =lending.gettoken2price();
uint256 intialsupply = lending.gettokensupply(lending.gettoken1());
uint256 beeta =( (100*collateral*token2value))/(token1value*200);
vm.assume(beeta<intialsupply);
require(beeta <= intialsupply, "beeta is larger than initial supply");
uint256 finalsupplyexpected= intialsupply-beeta;
lending.main(token2,collateral);
uint256 finalsupplyactual = lending.gettokensupply(lending.gettoken1());
assertEq(finalsupplyexpected,finalsupplyactual);
}

function testdepositf(uint256 amount)public{
vm.assume(amount >0 && amount<1e36);
address token1 = lending.gettoken1();
uint256 intialsupply = lending.gettokensupply(lending.gettoken1());
lending.deposit(token1,amount);
uint256 finalsupplyexpected= intialsupply+amount;
uint256 finalsupplyactual =lending.gettokensupply(lending.gettoken1());
assertEq(finalsupplyexpected,finalsupplyactual);
}

}