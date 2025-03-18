//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.28;
import {Lending} from "src/Lending.sol";
import {Test} from "lib/forge-std/src/Test.sol";
import{StdInvariant} from "lib/forge-std/src/StdInvariant.sol";
contract Invarienttest is StdInvariant,Test{
Lending lending;
function setUp()public{
lending=new Lending();
}

function invariant_interestshouldbepositive() public {
    assertGe(lending.gettotalinterestwinnings(), 0);
}

function invariant_token1priceshouldneverbezero() public {
    assertGt(lending.gettoken1price(), 0);
}

function invariant_token2priceshouldneverbezero() public {
  assertGt(lending.gettoken2price(), 0);
}
}