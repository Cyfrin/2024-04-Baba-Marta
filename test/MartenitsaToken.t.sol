// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";
import {BaseTest} from "./BaseTest.t.sol";

contract MartenitsaToken is Test, BaseTest {  
   function testCreateMartenitsa() public {
      vm.prank(jack);
      martenitsaToken.createMartenitsa("bracelet");
      
      assert(martenitsaToken.ownerOf(0) == jack);
   }

   function testCreateMartenitsaCalledByNonProducer() public {
      vm.prank(bob);
      vm.expectRevert();
      martenitsaToken.createMartenitsa("bracelet");
   }
   function testUpdateCount() public createMartenitsa {
      vm.prank(chasy);
      martenitsaToken.updateCountMartenitsaTokensOwner(chasy, "add");
      assert(martenitsaToken.getCountMartenitsaTokensOwner(chasy) == 2);
   }
   function testGetDesign() public createMartenitsa {
      vm.prank(bob);
      string memory expectedDesign = "bracelet";
      assertEq(martenitsaToken.getDesign(0), expectedDesign);
   }

   function testGetProducers() public {
      vm.prank(bob);
      address[] memory addressProducers = martenitsaToken.getAllProducers();
      assertEq(addressProducers, producers);
   }

   function testGetNextTokenId() public createMartenitsa{
      uint256 tokenId = martenitsaToken.getNextTokenId();
      assertEq(tokenId, 1);
   }
}