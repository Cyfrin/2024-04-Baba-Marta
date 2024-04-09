<p align="center">
<img src="https://res.cloudinary.com/droqoz7lg/image/upload/q_90/dpr_2.0/c_fill,g_auto,h_320,w_320/f_auto/v1/company/cjm9qalxsioqgbfpvrsl?_a=BATAUVAA0" width="300" alt="Grandma March">
<br/>

# Contest Details

### Prize Pool

- High - 100xp
- Medium - 20xp
- Low - 2xp

- Starts: April 11, 2024 Noon UTC
- Ends: April 18, 2024 Noon UTC

### Stats

- nSLOC: 239
- Complexity Score: 202

# Baba Marta

## Disclaimer

_This code was created for Codehawks as the first flight. It is made with bugs and flaws on purpose._
_Don't use any part of this code without reviewing it and audit it._

_Created by Bube_

# About

Every year on 1st March people in Bulgaria celebrate a centuries-old tradition called the day of Baba Marta ("Baba" means Grandma and "Mart" means March), related to sending off the winter and welcoming the approaching spring. On that day and a few days afterwards, people exchange and wear the so-called “Martenitsa”. The martenitsa consists of decorative pieces of red and white twisted threads, symbolising health and happiness. The martenitsas are given away to family and friends and are worn around the wrist or on clothes. The martenitsa is made of twined red and white threads – woolen, silk, or cotton. The most typical martenitsa represents two small dolls, known as Pizho and Penda. Pizho is the male doll, usually in white colour. Penda is the female doll, usually in red colour. Martenitsas come in a variety of shapes and sizes: bracelets, necklaces, tassels, pompoms and balls. The white is a symbol of purity, innocence, beauty and joy. The red is associated with health, vitality, fertility and bravery. According to the tradition, people wear martenitsas for a certain period, the end of which is usually associated with the first signs of spring – seeing a stork or a fruit tree in blossom.

The "Baba Marta" protocol allows you to buy `MartenitsaToken` and to give it away to friends. Also, if you want, you can be a producer. The producer creates `MartenitsaTokens` and sells them. There is also a voting for the best `MartenitsaToken`. Only producers can participate with their own `MartenitsaTokens`. The other users can only vote. The winner wins 1 `HealthToken`. If you are not a producer and you want a `HealthToken`, you can receive one if you have 3 different `MartenitsaTokens`. More `MartenitsaTokens` more `HealthTokens`. The `HealthToken` is a ticket to a special event (producers are not able to participate). During this event each participant has producer role and can create and sell own `MartenitsaTokens`.

## MartenitsaToken.sol

The Martenitsa NFT.
This contract manages a collection of digital tokens called `MartenitsaTokens`.

- `setProducer`: Allows the contract owner to add new producers by specifying their addresses.
- `createMartenitsa`: Allows registered producers to create a new martenitsa token with a specified design.
- `getDesign`: Retrieves the design of a given martenitsa token.
- `updateCountMartenitsaTokensOwner`: Allows updating the count of martenitsa tokens owned by a specific address.
- `getCountMartenitsaTokensOwner`: Retrieves the count of martenitsa tokens owned by a specific address.
- `getAllProducers`: Retrieves an array of all registered producers.
- `getNextTokenId`: Retrieves the next available token ID.

## MartenitsaMarketplace.sol

This contract provides a marketplace where users can buy and sell martenitsa tokens, with additional functionality for making presents, collecting rewards and managing listings. All users can participate in buying and collecting rewards, but only producers can list their tokens for sale and then sell them.

- `listMartenitsaForSale`: Allows registered producers to list a martenitsa token for sale with a specified price.
- `buyMartenitsa`: Allows users to buy a listed martenitsa token and transfer funds to the seller.
- `makePresent`: Allows users to make a present of a martenitsa token they own to someone else.
- `collectReward`: Allows users to collect `HealthTokens` as a reward based on the number of `MartenitsaTokens` they own. For every 3 different `MartenitsaTokens` you receive 1 `HealthToken`.
- `cancelListing`: Allows sellers to cancel the listing for sale of a martenitsa token.
- `getListing`: Retrieves the characteristics of a martenitsa token listed for sale.

## MartenitsaEvent.sol

This contract manages an event where participants can join, if they meet certain criteria and during the event the participants will become producers. That means they can create and sell `MartenitsaTokens`. Users who are already producers can not participate in the event.

- `startEvent`: Allows the owner to start the event by specifying its duration.
- `joinEvent`: Allows participants to join the event if they have sufficient `HealthToken` balance. The producers are not able to participate.
- `stopEvent`: Removes the producer role of the participants after the event is ended.
- `getParticipant`: Retrieves information about whether a given address has participated in the event.

## MartenitsaVoting.sol

The contract allows the users to participate in voting for martenitsa tokens listed on the marketplace (only producers can add their `MartenitsaTokens` for voting). After the voting period ends, the owner can announce the winner based on the number of votes, and the winner receives a `HealthToken` as a reward. The voting takes place only once.

- `startVoting`: Allows the owner to start the voting period.
- `voteForMartenitsa`: Allows users to vote for a specific martenitsa token ID during the voting period.
- `announceWinner`: Allows the owner to announce the winner of the voting and distribute a `HealthToken` as a reward.
- `getVoteCount`: Retrieves the count of votes for a given martenitsa token ID.

## HealthToken.sol

HealthToken is an ERC-20 token with additional functionality. The primary purpose of this token is to serve as a reward mechanism for participants who have more than 3 `MartenitsaTokens`. For every 3 different `MartenitsaTokens` they receive 1 `HealthToken`. This token is also a reward for the winner of the voting. These should be the two eligible ways to receive a `HealthToken` in this protocol.

- `setMarketAndVotingAddress`: Allows the owner to set the addresses of the `MartenitsaMarketplace` and `MartenitsaVoting` contracts.
- `distributeHealthToken`: Allows the marketplace and voting contracts to distribute `HealthTokens` as rewards to specified addresses.

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

```
git clone https://github.com/Cyfrin/2024-04-Baba-Marta
cd 2024-04-Baba-Marta
```

# Usage

## Testing

```
forge test
```

### Test Coverage

```
forge coverage
```

and for coverage based testing:

```
forge coverage --report debug
```

# Audit Scope Details
- In Scope:

```
├── src
│   ├── HealthToken.sol
│   ├── MartenitsaEvent.sol
│   ├── MartenitsaMarketplace.sol
│   ├── MartenitsaToken.sol
|   ├── MartenitsaVoting.sol
│   ├── SpecialMartenitsaToken.sol

```

## Compatibilities

- Solc Version: `^0.8.21`
- Chain(s) to deploy contract to:
  - Ethereum

# Roles

Producer - Should be able to create martenitsa and sell it. The producer can also buy martenitsa, make present and participate in vote. The martenitsa of producer can be candidate for the winner of voting.

User - Should be able to buy martenitsa and make a present to someone else. The user can collect martenitsa tokens and for every 3 different martenitsa tokens will receive 1 health token. The user is also able to participate in a special event and to vote for one of the producer's martenitsa.

# Known Issues

None

