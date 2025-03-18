//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.28;
import {Test} from "lib/forge-std/src/Test.sol";
import {Lending} from "../src/Lending.sol";
contract  TestLending is Test{
       Lending lending;
       uint256  intialsupply1=1000000 ether;
       mapping(address => uint256) public collateraldepositedvalue;
       mapping(address=> uint256) public borrowedtokenamountvalue;

function setUp() public{
    lending =new Lending();  
 }

 function testdeployment()public{
assertEq(lending.gettokensupply(lending.gettoken1()),1000000 ether);
assertEq(lending.gettoken2price(),1 ether);
assertEq(lending.gettoken1price(),1 ether);
}

function testmain()public{
    address token =makeAddr("token");
    uint256 amount =5 ;
    vm.expectRevert();
    lending.main(token,amount);
    uint256 amount1 =0;
    address token2 = lending.gettoken2();
    vm.expectRevert();
    lending.main(token2,amount1);
    uint256 collateral= 4;
    uint256 token1value =lending.gettoken1price();
    uint256 token2value =lending.gettoken2price();
    uint256 intialsupply = lending.gettokensupply(lending.gettoken1());
    uint256 beeta =( (100)*(collateral)*(token2value))/(token1value*200);
    uint256 finalsupplyexpected= intialsupply-beeta;
    lending.main(token2,collateral);
    uint256 finalsupplyactual = lending.gettokensupply(lending.gettoken1());
    assertEq(finalsupplyexpected,finalsupplyactual);
}

function testliquidate()public{
       address player =makeAddr("player");
       collateraldepositedvalue[player]=2 ether;
       borrowedtokenamountvalue[player]=1 ether;
       address token1 = lending.gettoken1();
       uint256 amount = 5 ;
       vm.expectRevert();
       lending.liquidate(player,token1 ,amount);
       address user =makeAddr("user");
       collateraldepositedvalue[user]=1 ether;
       borrowedtokenamountvalue[user]=1 ether;
       vm.expectRevert();
       lending.liquidate(user,player ,amount);
}

function testdeposit()public{
       address token2 = lending.gettoken2();
       uint256 amount = 5;
       vm.expectRevert();
       lending.deposit(token2,amount);
       address token1 = lending.gettoken1();
       uint256 intialsupply = lending.gettokensupply(lending.gettoken1());
       lending.deposit(token1,amount);
       uint256 finalsupplyexpected= intialsupply+amount;
       uint256 finalsupplyactual =lending.gettokensupply(lending.gettoken1());
       assertEq(finalsupplyexpected,finalsupplyactual);
}

function testupdatetoken1price()public{
       address user = makeAddr("user");
       uint256 amount = 5;
       vm.prank(user);
       vm.expectRevert();
       lending.updatepriceoftoken1(amount);
}
function testupdatetoken2price()public{
       address user = makeAddr("user");
       uint256 amount = 5;
       vm.prank(user);
       vm.expectRevert();
       lending.updatepriceoftoken2(amount);
}
 }
