// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MartenitsaToken is ERC721, Ownable {
    
    uint256 private _nextTokenId;
    address[] public producers;

    mapping(address => uint256) public countMartenitsaTokensOwner;
    mapping(address => bool) public isProducer;
    mapping(uint256 => string) public tokenDesigns;

    event Created(address indexed owner, uint256 indexed tokenId, string indexed design);

    constructor() ERC721("MartenitsaToken", "MT") Ownable(msg.sender) {}

    /**
    * @notice Function to set producers.
    * @param _producersList The addresses of the producers.
    */
    function setProducers(address[] memory _producersList) public onlyOwner{
        for (uint256 i = 0; i < _producersList.length; i++) {
            isProducer[_producersList[i]] = true;
            producers.push(_producersList[i]);
        }
    }

    /**
    * @notice Function to create a new martenitsa. Only producers can call the function.
    * @param design The type (bracelet, necklace, Pizho and Penda and other) of martenitsa.
    */
    function createMartenitsa(string memory design) external {
        require(isProducer[msg.sender], "You are not a producer!");
        require(bytes(design).length > 0, "Design cannot be empty");
        
        uint256 tokenId = _nextTokenId++;
        tokenDesigns[tokenId] = design;
        countMartenitsaTokensOwner[msg.sender] += 1;

        emit Created(msg.sender, tokenId, design);

        _safeMint(msg.sender, tokenId);
    }

    /**
    * @notice Function to get the design of a martenitsa.
    * @param tokenId The Id of the MartenitsaToken.
    */
    function getDesign(uint256 tokenId) external view returns (string memory) {
        require(tokenId < _nextTokenId, "The tokenId doesn't exist!");
        return tokenDesigns[tokenId];
    }

    /**
    * @notice Function to update the count of martenitsaTokens for a specific address.
    * @param owner The address of the owner.
    * @param operation Operation for update: "add" for +1 and "sub" for -1.
    */
    function updateCountMartenitsaTokensOwner(address owner, string memory operation) external {
        if (keccak256(abi.encodePacked(operation)) == keccak256(abi.encodePacked("add"))) {
            countMartenitsaTokensOwner[owner] += 1;
        } else if (keccak256(abi.encodePacked(operation)) == keccak256(abi.encodePacked("sub"))) {
            countMartenitsaTokensOwner[owner] -= 1;
        } else {
            revert("Wrong operation");
        }
    }

    /**
    * @notice Function to get the count of martenitsaTokens for a specific address.
    * @param owner The address of the owner.
    */
    function getCountMartenitsaTokensOwner(address owner) external view returns (uint256) {
        return countMartenitsaTokensOwner[owner];
    }

    /**
    * @notice Function to get the list of addresses of all producers.
    */
    function getAllProducers() external view returns (address[] memory) {
        return producers;
    }

    /**
    * @notice Function to get the next tokenId.
    */
    function getNextTokenId() external view returns (uint256) {
        return _nextTokenId;
    }
}
