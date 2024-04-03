// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import {MartenitsaMarketplace} from "./MartenitsaMarketplace.sol";
import {MartenitsaVoting} from "./MartenitsaVoting.sol";

contract HealthToken is ERC20, Ownable {

    MartenitsaMarketplace private _martenitsaMarketplace;
    MartenitsaVoting private _martenitsaVoting;
    constructor() ERC20("HealthToken", "HT") Ownable(msg.sender) {}

    /**
    * @notice Function to set the market and voting addresses.
    */
    function setMarketAndVotingAddress(address martenitsaMarketplace, address martenitsaVoting) public onlyOwner {
        _martenitsaMarketplace = MartenitsaMarketplace(martenitsaMarketplace);
        _martenitsaVoting = MartenitsaVoting(martenitsaVoting);
    }

    /**
    * @notice Function to distribute HealthToken.
    * @notice The function can be called only from the market and voting address.
    */
    function distributeHealthToken(address to, uint256 amount) external {
        require(msg.sender == address(_martenitsaMarketplace) || msg.sender == address(_martenitsaVoting), "Unable to call this function");
        
        uint256 amountToMint = amount * 10 ** 18;
        _mint(to, amountToMint);
    }
}