# ERC20_MyToken  
This is a simple ERC20 token contract written in Solidity. It allows for the creation, transfer, and burning of tokens. The contract also includes an onlyOwner modifier to restrict access to certain functions.  

## Features  
1. Implements the ERC20 token standard  
2. Allows the owner of the contract to mint new tokens
3. Allows the owner of the contract to burn tokens
4. Supports name, symbol, and decimals metadata  

## Getting Started  
To use this contract, you will need a Solidity development environment and a wallet that supports ERC20 tokens, such as MetaMask.

1. Clone this repository.  
2. Open the contract file in a Solidity IDE.  
3. Compile and deploy the contract to your preferred blockchain network.  
4. Interact with the contract using a wallet that supports ERC20 tokens.  

## Functions  
- mint(address account, uint256 amount): Allows the contract owner to mint new tokens to an account.  
- burn(address account, uint256 amount): Allows the contract owner to burn tokens from an account.  
- transfer(address to, uint256 amount): Allows an account to transfer tokens to another account.  
- approve(address spender, uint256 amount): Allows an account to approve another account to spend a certain amount of tokens on their behalf.  
- transferFrom(address from, address to, uint256 amount): Allows an account with approved allowance to transfer tokens from another account.  

## Modifiers  
- onlyOwner(): Restricts access to certain functions to the contract owner.  

## Token Details
- name(): Returns the name of the token.  
- symbol(): Returns the symbol of the token.  
- decimals(): Returns the number of decimal places used by the token.  



