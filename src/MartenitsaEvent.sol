// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {HealthToken} from "./HealthToken.sol";
import {MartenitsaToken} from "./MartenitsaToken.sol";

contract MartenitsaEvent is MartenitsaToken {
    
    HealthToken private _healthToken;

    uint256 public eventStartTime;
    uint256 public eventDuration;
    uint256 public eventEndTime;
    uint256 public healthTokenRequirement = 10 ** 18;
    address[] public participants;

    mapping(address => bool) private _participants;

    event EventStarted(uint256 indexed startTime, uint256 indexed eventEndTime);
    event ParticipantJoined(address indexed participant);

    constructor(address healthToken) onlyOwner {
        _healthToken = HealthToken(healthToken);
    }

    /**
    * @notice Function to start an event.
    * @param duration The duration of the event.
    */
    function startEvent(uint256 duration) external onlyOwner {
        eventStartTime = block.timestamp;
        eventDuration = duration;
        eventEndTime = eventStartTime + duration;
        emit EventStarted(eventStartTime, eventEndTime);
    }

    /**
    * @notice Function to join to event. Each participant is a producer during the event.
    * @notice The event should be active and the caller should not be joined already.
    * @notice Producers are not allowed to participate.
    */
    function joinEvent() external {
        require(block.timestamp < eventEndTime, "Event has ended");
        require(!_participants[msg.sender], "You have already joined the event");
        require(!isProducer[msg.sender], "Producers are not allowed to participate");
        require(_healthToken.balanceOf(msg.sender) >= healthTokenRequirement, "Insufficient HealthToken balance");
        
        _participants[msg.sender] = true;
        participants.push(msg.sender);
        emit ParticipantJoined(msg.sender);
        
        (bool success) = _healthToken.transferFrom(msg.sender, address(this), healthTokenRequirement);
        require(success, "The transfer is not successful");
        _addProducer(msg.sender);
    }

    /**
    * @notice Function to remove the producer role of the participants after the event is ended.
    */
    function stopEvent() external onlyOwner {
        require(block.timestamp >= eventEndTime, "Event is not ended");
        for (uint256 i = 0; i < participants.length; i++) {
            isProducer[participants[i]] = false;
        }
    }

    /**
    * @notice Function to get information if a given address is a participant in the event.
    */
    function getParticipant(address participant) external view returns (bool) {
        return _participants[participant];
    }

    /**
    * @notice Function to add a new producer.
    * @param _producer The address of the new producer.
    */
    function _addProducer(address _producer) internal {
        isProducer[_producer] = true;
        producers.push(_producer);
    } 
}