// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, Vm} from "forge-std/Test.sol";
import {BaseTest} from "./BaseTest.t.sol";

contract MartenitsaEvent is Test, BaseTest {
    
    function testStartEvent() public {
        vm.recordLogs();
        martenitsaEvent.startEvent(1 days);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        uint256 eventStartTime = uint256(entries[0].topics[1]);
        uint256 eventEndTime = uint256(entries[0].topics[2]);
        assert(eventStartTime == block.timestamp);
        assert(eventEndTime == block.timestamp + 1 days);
    }

    function testJoinEvent() public activeEvent eligibleForReward {
        vm.startPrank(bob);
        marketplace.collectReward();
        healthToken.approve(address(martenitsaEvent), 10 ** 18);
        martenitsaEvent.joinEvent();
        vm.stopPrank();

        assert(healthToken.balanceOf(bob) == 0);
        assert(healthToken.balanceOf(address(martenitsaEvent)) == 10 ** 18);
        assert(martenitsaEvent.getParticipant(bob) == true);
        assert(martenitsaEvent.isProducer(bob) == true);
    }

    function testJoinEventTwice() public activeEvent eligibleForReward {
        vm.startPrank(bob);
        marketplace.collectReward();
        healthToken.approve(address(martenitsaEvent), 10 ** 18);
        martenitsaEvent.joinEvent();
        
        vm.expectRevert();
        martenitsaEvent.joinEvent();
        vm.stopPrank();
    }

    function testStopEvent() public eligibleForReward {
        martenitsaEvent.startEvent(1 days);
        vm.startPrank(bob);
        marketplace.collectReward();
        healthToken.approve(address(martenitsaEvent), 10 ** 18);
        
        martenitsaEvent.joinEvent();
        vm.warp(block.timestamp + 1 days + 1);
        vm.stopPrank();
        martenitsaEvent.stopEvent();
        assert(martenitsaEvent.isProducer(bob) == false);
    }

    function testGetParticipant() public view {
        assert(martenitsaEvent.getParticipant(bob) == false);
    }
}