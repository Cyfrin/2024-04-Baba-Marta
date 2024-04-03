// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";
import {BaseTest} from "./BaseTest.t.sol";

contract MartenitsaMarketplace is Test, BaseTest {
    
    function testListMartenitsaForSaleNonOwner() public createMartenitsa {
        vm.prank(chasy);
        vm.expectRevert();
        marketplace.listMartenitsaForSale(1, 1 wei);
    }

    function testListMartenitsaForSaleNonProducer() public hasMartenitsa {
        vm.prank(bob);
        vm.expectRevert();
        marketplace.listMartenitsaForSale(0, 1 wei);
    }

    function testListMartenitsaForSale() public createMartenitsa {
        vm.prank(chasy);
        marketplace.listMartenitsaForSale(0, 1 wei);
        list = marketplace.getListing(0);
        assert(list.seller == chasy);
        assert(list.price == 1 wei);
    }

    function testBuyMartenitsa() public listMartenitsa {
        vm.prank(chasy);
        martenitsaToken.approve(address(marketplace), 0);
        vm.prank(bob);
        marketplace.buyMartenitsa{value: 1 wei}(0);

        assert(martenitsaToken.ownerOf(0) == bob);
        assert(martenitsaToken.getCountMartenitsaTokensOwner(bob) == 1);
        assert(martenitsaToken.getCountMartenitsaTokensOwner(chasy) == 0);
    }

    function testBuyMartenitsaWrongTokenId() public {
        vm.prank(bob);
        vm.expectRevert();
        marketplace.buyMartenitsa{value: 1 wei}(0);
    }

    function testMakePresent() public hasMartenitsa {
        vm.startPrank(bob);
        martenitsaToken.approve(address(marketplace), 0);
        marketplace.makePresent(jack, 0);
        vm.stopPrank();

        assert(martenitsaToken.ownerOf(0) == jack);
        assert(martenitsaToken.getCountMartenitsaTokensOwner(bob) == 0);
        assert(martenitsaToken.getCountMartenitsaTokensOwner(jack) == 1);
    }

    function testMakePresentWrongTokenId() public hasMartenitsa {
        vm.startPrank(bob);
        vm.expectRevert();
        marketplace.makePresent(jack, 1);
        vm.stopPrank();
    }

    function testCollectReward() public eligibleForReward {
        vm.startPrank(bob);
        marketplace.collectReward();
        vm.stopPrank();
        assert(healthToken.balanceOf(bob) == 10 ** 18);
    }
    function testGetListing() public listMartenitsa {
        list = marketplace.getListing(0);
        assert(list.tokenId == 0);
        assert(list.seller == chasy);
        assert(list.price == 1 wei);
        assert(keccak256(abi.encodePacked(list.design)) == keccak256(abi.encodePacked("bracelet")));
        assert(list.forSale == true);
    }
}