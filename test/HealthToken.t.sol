// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";
import {BaseTest} from "./BaseTest.t.sol";

contract HealthToken is Test, BaseTest {
    
    function testDistributeHealthToken() public {
        vm.prank(bob);
        vm.expectRevert();
        healthToken.distributeHealthToken(bob, 1);
    }
}