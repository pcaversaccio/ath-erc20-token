# Alethena - ATH - Token 

Swiss Blockchain-Asset Rating
Alethena – Empowering Investment

## Overview
The Alethena ATH token is a standard ERC20 token which will be deployed to the Ethereum blockchain. 
In addition the ATH token supports a hard-coded vesting which has to be set properly in the source code before the deployment. 

## ATH Properties
- Token Type: ERC20
- Symbol: ATH
- Name: ALETHENA Token
- Decimals: 18 Decimals
- Max Tokens: Will be set at the end of the ICO. Amount of sold tokens.
- Vested token holder: Not yet defined. 

## The contract and functionalities
The `ATHToken.sol` provides several features.

### ERC20
Implements the standard ERC20 interface. [page](https://theethereum.wiki/w/index.php/ERC20_Token_Standard)

### Vesting
As a business requirement a vesting functionality is implemented. There will be a set of token holders which have tokens assigned to their address, but are not able to transfer/spend these tokens. They will be locked for a defined time. This is hard coded. 
The vesting is technical bound to the address. Be aware: If somebody transfer tokens to an active vested address, these tokens will be locked as well. 

- `isLocked(address): bool`: Returns true if the address is locked (vesting period). In that case tokens assigned to that address are not able to be transferred. Returns false if there is no vesting or if the vesting period is expired.

- `lockTime(address): uint256`: Returns the locking time in epoche unix time seconds. If return 0 no locking time was set. 

### Minting
The contract owner is able to mint the maximum amount of tokens.
There is no mint finish or mint end function. You can mint until the maximum amount of ATH token is minted. 
In this case `isMintDone()` will return true.

`function mint(address[] recipients, uint256[] tokens) public onlyOwner returns (bool)`
Minting allows an array of recipients and an array of tokens. So it's possible to mint for multiple recipients in one transaction. Used to save Gas. 

### Transfer ownership
The owner of the contract is able to transfer the ownership to an new owner.
The owner of the contract is allowed to mint. When the minting process ended (maximum amount of tokens minted), even the owner of the contract has no more functionality.

### Voting
Token holder will be able to vote with their ATH tokens for specific ballots defined by Alethena. The voting functionality itself is not part of the token.

### Others
- The contract does not allow Ether 
- The contract can not be destroyed
- There is no update mechanism
- There is a function `transferArray`. It's the same principe as in the minting. Transfer tokens to a list of recipients in one transaction. Used to save Gas. 

## Security
- the well known minor `approve(spender, value)` issue from ERC20 is not handled at all. [Issue, page 12](https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view) or [here](https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729). Workaround with `increase/decreaseApproval()` [here](https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol) are implemented.
- Rule: throw exceptions instead of value return. In the ERC20 interface the most methods returns `true` or  `false` if you're doing a transaction. We prefer throwing an exception if something went wrong by using `require()`. In that case it's sure that no state change happened. With `require()` remaining gas will be returned to the sender. 
