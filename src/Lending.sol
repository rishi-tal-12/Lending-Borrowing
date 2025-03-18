//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.28;
import {Token1} from "src/Tokens.sol";
import {Token2} from "src/Tokens.sol";
contract Lending{
    error Not_correcttoken();
    error Not_owner();
    error Not_enoughcollateral();
    error Everthythingisgood();

    Token1 token1;
    Token2 token2;
    uint256 intialsupply1;
    uint256 intialsupply2;
    address owner;
    uint256 tokenprice1;
    uint256 tokenprice2;
    uint256 base1;
    uint256 base2;
    uint256 s_totalinterestwinnings;

mapping (address=>uint256) private s_tokensupplychange;
mapping (address=>uint256) public fractionofdepositer;
mapping(address=>uint256) public interestofborrower;
mapping(address => uint256) public collateraldepositedvalue;
mapping(address=> uint256) public borrowedtokenamountvalue;

uint256 constant LIQUIDATE_THERSHOLD= 150 ether;
uint256 constant LIQUIDATE_PRECISION =100 ether;
uint256 constant BASE_PERCENTAGE=0.08 ether;
uint256 constant MULTIPLIER =0.06 ether;
uint256 constant BONUS =0.1 ether;


    modifier onlyowner(){
        if(msg.sender!= owner){
            revert Not_owner();
        }
        _;
    }

    constructor (){
        base1=1e18 ether;
        base2=1e18 ether;
        intialsupply1=1_000_000 ether;
        intialsupply2=100000 ether;
        tokenprice1 =1 ether;
        tokenprice2 =1 ether;
        token1 =new Token1(base1);
        token2 =new Token2(base2);
        s_tokensupplychange[address(token1)]=intialsupply1;
        owner=msg.sender;
    }
    /*
    @notice token2 is getting deposited as collateral and token 1 is borrowed
    */
   
    function main(address token, uint256 collateral)external returns (uint256){
        if(token != address(token2)){
            revert Not_correcttoken();
    }
    /*
    @notice collateral is the amount of token2 he is depositing
    @notice 200% collateral deposit should be present
    @notice intrest =basepercentage + Multiplier*(total borrowed/total in liquidity pool)
    */
    if(collateral <= 0){
        revert Not_enoughcollateral();
    }
    /*
    @notice  ((100)*(tokenprice2)*(collateral))/((tokenprice1)*200)  this is the amount of token1 that the borrower is taking as loan
    */
    collateraldepositedvalue[msg.sender]= collateral*tokenprice2;
    borrowedtokenamountvalue[msg.sender]=((100)*(tokenprice2)*(collateral))/((tokenprice1)*200)*(tokenprice1);
    interestofborrower[msg.sender] = BASE_PERCENTAGE + MULTIPLIER*(((100)*(tokenprice2)*(collateral))/((tokenprice1)*200))/s_tokensupplychange[address(token1)];

    s_totalinterestwinnings+=(((100)*(tokenprice2)*(collateral))/((tokenprice1)*200))*(tokenprice1)*(interestofborrower[msg.sender]);
    s_tokensupplychange[address(token1)]-=((100)*(tokenprice2)*(collateral))/((tokenprice1)*200);
    return ((100)*(tokenprice2)*(collateral))/((tokenprice1)*200);
    }

    function liquidate (address user,address tokenhelper ,uint256 amounttoken)external returns(uint256){
    if ((collateraldepositedvalue[user] * LIQUIDATE_PRECISION) / borrowedtokenamountvalue[user] < LIQUIDATE_THERSHOLD){
        //borrowed token is token1 so the helper will help the user to pay back his loan and will get his collateral at an bonus of 10percent as 
        //for helping him pay the collateral
        if(tokenhelper == address(token1)){
            uint256 intialborrowedamountvalue = borrowedtokenamountvalue[user];
            borrowedtokenamountvalue[user]-=amounttoken*tokenprice1;
            //The helper would get the percentage of collateral based on how much debt he paid (debtpaid)/(totaldebt)*collateral
          uint256 collateraltohelperwithoutbonus = (amounttoken * tokenprice1) / intialborrowedamountvalue * (collateraldepositedvalue[user]);
        uint256 collateraltohelperwithbonus = collateraltohelperwithoutbonus + ((collateraltohelperwithoutbonus * BONUS) / 1 ether);
            //now the collateral deposited by user will decrease
            collateraldepositedvalue[user]-=collateraltohelperwithbonus;
            return collateraltohelperwithbonus;
        }
        else{
            revert  Not_correcttoken();
        }
    }
       else{
            revert Everthythingisgood();
    }
  }

    function deposit (address token, uint256 amount)external{
                if(token != address(token1)){
                revert Not_correcttoken();
    }
                s_tokensupplychange[address(token1)]+=amount;
                fractionofdepositer[msg.sender]=(amount)/s_tokensupplychange[address(token1)];
    }

    function withdrawofdepositer()external view  returns(uint256){
            return   (s_totalinterestwinnings)* (fractionofdepositer[msg.sender]);
    }

    function updatepriceoftoken1(uint256 newprice)external onlyowner{
        tokenprice1=newprice;
    }

    function updatepriceoftoken2(uint256 newprice)external onlyowner{
        tokenprice2=newprice;
    }

    function gettoken1price() external view returns(uint256){
    return tokenprice1;
  }

    function gettoken2price() external view returns(uint256){
    return tokenprice2;
  }
   function gettokensupply(address token) external view returns(uint256){
    return s_tokensupplychange[token];
   } 
   function gettoken1()external view returns (address){
    return address(token1);
   }
    function gettoken2()external view returns (address){
    return address(token2);
   }
   function getcollateraldepositedvalue(address user)external view returns(uint256){
    return collateraldepositedvalue[user];
   }

}

