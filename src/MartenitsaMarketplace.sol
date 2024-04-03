// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import {HealthToken} from "./HealthToken.sol";
import {MartenitsaToken} from "./MartenitsaToken.sol";

contract MartenitsaMarketplace is Ownable {

    HealthToken public healthToken;
    MartenitsaToken public martenitsaToken;

    uint256 public requiredMartenitsaTokens = 3;

    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 price;
        string design;
        bool forSale;
    }

    mapping(address => uint256) private _collectedRewards;
    mapping(uint256 => Listing) public tokenIdToListing;

    event MartenitsaListed(uint256 indexed tokenId, address indexed seller, uint256 indexed price);
    event MartenitsaSold(uint256 indexed tokenId, address indexed buyer, uint256 indexed price);

    constructor(address _healthToken, address _martenitsaToken) Ownable(msg.sender) {
        healthToken = HealthToken(_healthToken);
        martenitsaToken = MartenitsaToken(_martenitsaToken);
    }

    /**
    * @notice Function to list the martenitsa for sale. Only producers can call this function.
    * @param tokenId The tokenId of martenitsa.
    * @param price The price of martenitsa.
    */
    function listMartenitsaForSale(uint256 tokenId, uint256 price) external {
        require(msg.sender == martenitsaToken.ownerOf(tokenId), "You do not own this token");
        require(martenitsaToken.isProducer(msg.sender), "You are not a producer!");
        require(price > 0, "Price must be greater than zero");

        Listing memory newListing = Listing({
            tokenId: tokenId,
            seller: msg.sender,
            price: price,
            design: martenitsaToken.getDesign(tokenId),
            forSale: true
        });

        tokenIdToListing[tokenId] = newListing;
        emit MartenitsaListed(tokenId, msg.sender, price);
    }

    /**
    * @notice Function to buy a martenitsa.
    * @param tokenId The tokenId of martenitsa.
    */
    function buyMartenitsa(uint256 tokenId) external payable {
        Listing memory listing = tokenIdToListing[tokenId];
        require(listing.forSale, "Token is not listed for sale");
        require(msg.value >= listing.price, "Insufficient funds");
        
        address seller = listing.seller;
        address buyer = msg.sender;
        uint256 salePrice = listing.price;

        martenitsaToken.updateCountMartenitsaTokensOwner(buyer, "add");
        martenitsaToken.updateCountMartenitsaTokensOwner(seller, "sub");

         // Clear the listing
        delete tokenIdToListing[tokenId];

        emit MartenitsaSold(tokenId, buyer, salePrice);

        // Transfer funds to seller
        (bool sent, ) = seller.call{value: salePrice}("");
        require(sent, "Failed to send Ether");

        // Transfer the token to the buyer
        martenitsaToken.safeTransferFrom(seller, buyer, tokenId);
    }

    /**
    * @notice Function to make a present to someone. The caller should own the martenitsa.
    * @param presentReceiver The address of the receiver.
    * @param tokenId The tokenId of martenitsa.
    */
    function makePresent(address presentReceiver, uint256 tokenId) external {
        require(msg.sender == martenitsaToken.ownerOf(tokenId), "You do not own this token");
        martenitsaToken.updateCountMartenitsaTokensOwner(presentReceiver, "add");
        martenitsaToken.updateCountMartenitsaTokensOwner(msg.sender, "sub");
        martenitsaToken.safeTransferFrom(msg.sender, presentReceiver, tokenId);
    }

    /**
    * @notice Function to collect HealthToken. The user can get for every 3 different MartenitsaTokens 1 HealthToken.
    * @notice Producers are not able to call this function.
    */
    function collectReward() external {
        require(!martenitsaToken.isProducer(msg.sender), "You are producer and not eligible for a reward!");
        uint256 count = martenitsaToken.getCountMartenitsaTokensOwner(msg.sender);
        uint256 amountRewards = (count / requiredMartenitsaTokens) - _collectedRewards[msg.sender];
        if (amountRewards > 0) {
            _collectedRewards[msg.sender] = amountRewards;
            healthToken.distributeHealthToken(msg.sender, amountRewards);
        }
    }

    /**
    * @notice Function to get the characteristics for a given martenitsa for sale.
    * @param tokenId The tokenId of martenitsa.
    */
    function getListing(uint256 tokenId) external view returns (Listing memory) {
        Listing memory listing = tokenIdToListing[tokenId];
        require(listing.forSale, "Token is not listed for sale");
        return tokenIdToListing[tokenId];
    }
}