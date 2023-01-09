// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

// In this contract, we will delete the AggregatorV3Interface pricFeed address from the contract and store it to the config file
// So the contract can be deployed and verified in the local ganache network

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; //copying the exact interface code from github
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe2 {
    //mapping to store which address depositeded how much ETH
    mapping(address => uint256) public addressToAmountFunded; //help us track all the addresses that sent us value(money)
    // array of all funders' addresses
    address[] public funders;
    //address of the owner (who deployed the contract)
    address public owner;
    AggregatorV3Interface public priceFeed;

    // the first person to deploy the contract is the owner
    constructor(address _priceFeedAddress) public {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
        owner = msg.sender;
    }

    function fund() public payable {
        // 18 digit number to be compared with donated amount
        uint256 minimumUSD = 1 * 10**18; //unit is gwei here
        //is the donated amount less than 5USD?
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more ETH!"
        );
        //if not, add to mapping and funders array
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    //function to get the version of the chainlink pricefeed contract
    function getVersion() public view returns (uint256) {
        /*AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);*/
        //The above line has been replaced by the constructor code
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        /*AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);*/
        //The above line has been replaced by the constructor code
        (, int256 answer, , , ) = priceFeed.latestRoundData(); //function "latestRoundData" returns 5 variables
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000); //return 18 decimal places instead of 10
    }

    // 1000000000
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

    function getEntranceFee() public view returns (uint256) {
        // minimumUSD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        // return (minimumUSD * precision) / price;
        // We fixed a rounding error found in the video by adding one!
        return ((minimumUSD * precision) / price) + 1;
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
    function withdraw() public payable onlyOwner {
        address payable receiver = payable(owner);
        uint256 value = address(this).balance;
        receiver.transfer(value);

        /*msg.sender.transfer(address(this).balance);*/
        //old code, this code works for compiler ^0.6.0

        //iterate through all the mappings and make them 0, resetting everyone's balance in that mapping to 0
        //since all the deposited amount has been withdrawn
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //funders array will be initialized to 0
        funders = new address[](0);
    }
}
