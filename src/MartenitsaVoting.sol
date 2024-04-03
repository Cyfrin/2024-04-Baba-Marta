// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import {MartenitsaMarketplace} from "./MartenitsaMarketplace.sol";
import {HealthToken} from "./HealthToken.sol";

contract MartenitsaVoting is Ownable {

    MartenitsaMarketplace private _martenitsaMarketplace;
    MartenitsaMarketplace.Listing list;
    HealthToken private _healthToken;

    uint256 public startVoteTime;
    uint256 public duration = 1 days;
    uint256[] private _tokenIds;

    //mapping MartenitsaTokenId -> count of votes
    mapping(uint256 => uint256) public voteCounts;
    //mapping user address -> if this address is already voted
    mapping(address => bool) public hasVoted;

    event WinnerAnnounced(uint256 indexed winnerTokenId, address indexed winner);
    event Voting(uint256 indexed startTime, uint256 indexed duration);

    constructor (address marketplace, address healthToken) Ownable(msg.sender) {
        _martenitsaMarketplace = MartenitsaMarketplace(marketplace);
        _healthToken = HealthToken(healthToken);
    }

    /**
    * @notice Function to start the voting.
    */
    function startVoting() public onlyOwner {
        startVoteTime = block.timestamp;
        emit Voting(startVoteTime, duration);
    }

    /**
    * @notice Function to vote for martenitsa of the sale list.
    * @param tokenId The tokenId of the martenitsa.
    */
    function voteForMartenitsa(uint256 tokenId) external {
        require(!hasVoted[msg.sender], "You have already voted");
        require(block.timestamp < startVoteTime + duration, "The voting is no longer active");
        list = _martenitsaMarketplace.getListing(tokenId);
        require(list.forSale, "You are unable to vote for this martenitsa");

        hasVoted[msg.sender] = true;
        voteCounts[tokenId] += 1; 
        _tokenIds.push(tokenId);
    }

    /**
    * @notice Function to announce the winner of the voting. The winner receive 1 HealthToken.
    */
    function announceWinner() external onlyOwner {
        require(block.timestamp >= startVoteTime + duration, "The voting is active");

        uint256 winnerTokenId;
        uint256 maxVotes = 0;

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            if (voteCounts[_tokenIds[i]] > maxVotes) {
                maxVotes = voteCounts[_tokenIds[i]];
                winnerTokenId = _tokenIds[i];
            }
        }

        list = _martenitsaMarketplace.getListing(winnerTokenId);
        _healthToken.distributeHealthToken(list.seller, 1);

        emit WinnerAnnounced(winnerTokenId, list.seller);
    }

    /**
    * @notice Function to get the count of votes for a given tokenId.
    */
    function getVoteCount(uint256 tokenId) external view returns (uint256) {
        return voteCounts[tokenId];
    }
}