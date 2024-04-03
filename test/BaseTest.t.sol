// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";
import {MartenitsaToken} from "./../src/MartenitsaToken.sol";
import {HealthToken} from "./../src/HealthToken.sol";
import {MartenitsaMarketplace} from "./../src/MartenitsaMarketplace.sol";
import {MartenitsaVoting} from "./../src/MartenitsaVoting.sol";
import {MartenitsaEvent} from "./../src/MartenitsaEvent.sol";

contract BaseTest is Test {
   
   MartenitsaToken public martenitsaToken;
   HealthToken public healthToken;
   MartenitsaMarketplace public marketplace;
   MartenitsaVoting public voting;
   MartenitsaMarketplace.Listing list;
   MartenitsaEvent public martenitsaEvent;

   address[] public producers;
   address jack;
   address chasy;
   address bob;

   function setUp() public {
      jack = makeAddr("jack");
      chasy = makeAddr("chasy");
      bob = makeAddr("bob");
      producers.push(jack);
      producers.push(chasy);

      vm.deal(bob, 5 ether);

      martenitsaToken = new MartenitsaToken();
      healthToken = new HealthToken();
      marketplace = new MartenitsaMarketplace(address(healthToken), address(martenitsaToken));
      voting = new MartenitsaVoting(address(marketplace), address(healthToken));
      martenitsaEvent = new MartenitsaEvent(address(healthToken));
      
      healthToken.setMarketAndVotingAddress(address(marketplace), address(voting));
      martenitsaToken.setProducers(producers);
      
   }

   modifier createMartenitsa() {
        vm.startPrank(chasy);
        martenitsaToken.createMartenitsa("bracelet");
        vm.stopPrank();
        _;
   }

   modifier hasMartenitsa() {
      vm.startPrank(chasy);
      martenitsaToken.createMartenitsa("bracelet");
      martenitsaToken.approve(address(marketplace), 0);
      marketplace.makePresent(bob, 0);
      vm.stopPrank();
      _;
   }

   modifier listMartenitsa() {
      vm.startPrank(chasy);
      martenitsaToken.createMartenitsa("bracelet");
      marketplace.listMartenitsaForSale(0, 1 wei);
      vm.stopPrank();
      _;
   }

   modifier eligibleForReward() {
      vm.startPrank(chasy);
      martenitsaToken.createMartenitsa("bracelet");
      martenitsaToken.createMartenitsa("bracelet");
      martenitsaToken.createMartenitsa("bracelet");
      marketplace.listMartenitsaForSale(0, 1 wei);
      marketplace.listMartenitsaForSale(1, 1 wei);
      marketplace.listMartenitsaForSale(2, 1 wei);
      martenitsaToken.approve(address(marketplace), 0);
      martenitsaToken.approve(address(marketplace), 1);
      martenitsaToken.approve(address(marketplace), 2);
      marketplace.makePresent(bob, 0);
      marketplace.makePresent(bob, 1);
      marketplace.makePresent(bob, 2);
      vm.stopPrank();
      _;
   }

   modifier startVoting() {
      vm.warp(block.timestamp);
      voting.startVoting();
      _;
   }

   modifier activeEvent() {
      martenitsaEvent.startEvent(1 days);
      _;
   }
   
}
