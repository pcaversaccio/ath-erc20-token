# Alethena – ATH Token 

Swiss Blockchain-Asset Rating Agency:
Alethena – Empowering Investment

## Overview
The Alethena ATH token is a standard ERC20 token which will be deployed to the Ethereum blockchain. 
In addition, the ATH token supports a hard-coded vesting which has to be set properly in the source code before the deployment. 

## ATH Properties
- Token Type: ERC20.
- Symbol: ATH.
- Name: Alethena Token.
- Decimals: 18 Decimals.
- Max Tokens: Will be set at the end of the ICO. Amount of sold tokens.
- Vested Token Holders: Not yet defined. 

## The Contract and Functionalities
The `ATHToken.sol` provides several features.

### ERC20
Implements the standard ERC20 interface. See [page](https://theethereum.wiki/w/index.php/ERC20_Token_Standard).

### Vesting
As a business requirement a vesting functionality is implemented. There will be a set of token holders which have tokens assigned to their address, but are not able to transfer/spend these tokens. They will be locked for a defined time. This is hard-coded. 
The vesting is technical bound to the address. Be aware: If somebody transfer tokens to an active vested address, these tokens will be locked as well. 

- `isLocked(address): bool`: Returns true if the address is locked (vesting period). In that case tokens assigned to that address are not able to be transferred. Returns false if there is no vesting or if the vesting period is expired.

- `lockTime(address): uint256`: Returns the locking time in epoche unix time seconds. If return 0 no locking time was set. 

### Minting
The contract owner is able to mint the maximum amount of tokens.
There is no mint finish or mint end function. You can mint until the maximum amount of ATH token is minted. 
In this case `isMintDone()` will return true.

`function mint(address[] recipients, uint256[] tokens) public onlyOwner returns (bool)`
Minting allows an array of recipients and an array of tokens. So it's possible to mint for multiple recipients in one transaction. Used to save Gas. 

### Transfer Ownership
The owner of the contract is able to transfer the ownership to an new owner.
The owner of the contract is allowed to mint. When the minting process ended (maximum amount of tokens minted), even the owner of the contract has no more functionality.

### Voting
Token holders will be able to vote with their ATH tokens for specific ballots defined by Alethena. The voting functionality itself is not part of the token and will be implemented by a voting DApp.

### Others
- The contract does not allow Ether.
- The contract can not be destroyed.
- There is no update mechanism.
- There is a function `transferArray`. It's the same principe as in the minting. Transfer tokens to a list of recipients in one transaction. Used to save Gas. 

## Security
- The well known minor `approve(spender, value)` issue from ERC20 is not handled at all. See [Issue, page 12](https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view) or [here](https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729). Workaround with `increase/decreaseApproval()` [here](https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol) are implemented.
- Rule: throw exceptions instead of value return. In the ERC20 interface the most methods returns `true` or  `false` if you're doing a transaction. We prefer throwing an exception if something went wrong by using `require()`. In that case it's sure that no state change happened. With `require()` remaining gas will be returned to the sender.

## To Dos (Post-ICO Before Minting)
- Define MAX_SUPPLY.
- Define vesting addresses.
- Define vesting time per address.
- Define number of vested tokens per vesting address.

## Voting DApp Functionality

### Proposal Verification
The Merkle proof attached to the first proposal’s vote makes sure it existed at a given time and cannot be changed anymore. However, if the proposal creator wants to delete a proposal including its responses he is free to do so. This design decision was taken on purpose to make managing the content creation and management easier. If the latter discussed property is unwanted, the client DApp saves the Merkle proofs in its local storage and the result is that if the client does not find a proposal for which a proof was made it identifies something was deleted.

### Response Creation
The client consuming the DApp will sign a message with its private key. The message contains the option the client wants to vote for and a hash of the previous vote (or if the first vote, the previous hash will be set to the proposal’s hash). This chain of hashes makes sure, no vote can be adapted or deleted without resulting in a loss of all subsequent votes. The voting backend extracts the address from the signature and commits the response.

The states a response has are:
- Committed: Notarisation is ongoing but not done yet.
- Notarised: The response has a Merkle proof hooked into the blockchain.

### Response Weighting
To calculate the result of a vote, the individual votes need to be weighted first. Weighting is done on the client DApp side using the “balanceOf” of the token contract at “start block time”. All responses that have a Merkle proof will be iterated through and weighted accordingly. Only proofs that happen between “start block time” and “end block time” will be counted.

### Response Verification
The Merkle proof attached to the responses makes sure it existed at a given time and cannot be changed anymore. However, if the proposal creator wants to delete a proposal including its responses he is free to do so. This design decision was taken on purpose to make managing the content creation and management easier. If the latter discussed property is unwanted, the client DApp saves the Merkle proofs in its local storage and the result is that if the client does not find a response for which a proof was made it identifies something was deleted. Furthermore, the client DApp can always tell a user whether he/she already voted, making it easy for humans to spot if responses are deleted.
