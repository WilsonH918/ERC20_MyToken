// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; //copying the exact interface code from github
// brownie cannot download the code from chainlink but can download the contract from github
// We need to tell brownie where to import these contracts from
// 1. Create a "brownie-config.yaml" file in the main folder (brownie_fund_me folder in this case)
// 2. Add "dependencies" to tell brownie where the chainlink link is from
// 3. Further instructions are mentioned in "brownie-config.yaml" file
// 4. After finish perparing for the "brownie-config.yaml" file, type in "brownie compile" in the powershell to run the contract
// 5. The contract is compiled in brownie_fund_me/buid/contracts --> FundMe.json, the dependencies are stored in brownie_fund_me/buid/contracts/dependencies..

import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    //mapping to store which address depositeded how much ETH
    mapping(address => uint256) public addressToAmountFunded; //help us track all the addresses that sent us value(money)
    // array of all funders' addresses
    address[] public funders;
    //address of the owner (who deployed the contract)
    address public owner;

    // the first person to deploy the contract is the owner
    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable {
        // 18 digit number to be compared with donated amount
        uint256 minimumUSD = 1 * 10**18;//unit is gwei here
        //is the donated amount less than 5USD?
        require(getConversionRate(msg.value) >= minimumUSD,"You need to spend more ETH!");
        //if not, add to mapping and funders array
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    //function to get the version of the chainlink pricefeed contract
    function getVersion() public view returns (uint256) { //priceFeed is a CONTRACT!!
        AggregatorV3Interface/*Interface Contract*/ priceFeed/*Contract Name*/ = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e); /*Contract Address*/
        //The Address of where this price feed contract is located on Goerli Testnet
        //The Address can be found on this link: https://docs.chain.link/data-feeds/price-feeds/addresses/#Goerli%20Testnet
        //The priceFeed contract has been deployed on etherscan: https://goerli.etherscan.io/address/0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e#code
        return priceFeed.version();//"priceFeed" is a contract and "version" is its function, the function returns the version of the contract
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (, int256 answer, , , ) = priceFeed.latestRoundData();//function "latestRoundData" returns 5 variables
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);//return 18 decimal places instead of 10
    }

    // 1000000000
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

    //modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    modifier onlyOwner() {
        //is the message sender owner of the contract?
        require(msg.sender == owner, "You are not the owner!!");
        _;
    }

    // onlyOwner modifer will first check the condition inside it
    // and
    // if true, withdraw function will be executed
    function withdraw() payable onlyOwner public{
        address payable receiver = payable(owner);
        uint256 value = address(this).balance;
        receiver.transfer(value);

        /*msg.sender.transfer(address(this).balance);*/ //old code, this code works for compiler ^0.6.0

        //iterate through all the mappings and make them 0, resetting everyone's balance in that mapping to 0
        //since all the deposited amount has been withdrawn
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //funders array will be initialized to 0
        funders = new address[](0);
    }
}