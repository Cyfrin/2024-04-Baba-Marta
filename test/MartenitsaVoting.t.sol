// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, Vm} from "forge-std/Test.sol";
import {BaseTest} from "./BaseTest.t.sol";

contract MartenitsaVoting is Test, BaseTest {
    
    function testStartVoting() public {
        vm.warp(block.timestamp);
        voting.startVoting();
        assert(voting.startVoteTime() == 1);
    }

    function testVoteForMartenitsa() public listMartenitsa {
        vm.prank(bob);
        voting.voteForMartenitsa(0);
        assert(voting.hasVoted(bob) == true);
        assert(voting.voteCounts(0) == 1);
    }

    function testVoteForWrongMartenitsa() public listMartenitsa {
        vm.prank(bob);
        vm.expectRevert();
        voting.voteForMartenitsa(1);
    }

    function testAnnounceWinnerActiveVoting() public listMartenitsa {
        vm.prank(bob);
        voting.voteForMartenitsa(0);
        vm.expectRevert();
        voting.announceWinner();
    }

    function testAnnounceWinner() public listMartenitsa {
        vm.prank(bob);
        voting.voteForMartenitsa(0);
        vm.warp(block.timestamp + 1 days + 1);
        vm.recordLogs();
        voting.announceWinner();

        Vm.Log[] memory entries = vm.getRecordedLogs();
        address winner = address(uint160(uint256(entries[0].topics[2])));
        assert(winner == chasy);
    }
    
    function testGetVoteCount() public listMartenitsa {
        vm.prank(bob);
        voting.voteForMartenitsa(0);
        assert(voting.getVoteCount(0) == 1);
    }


}