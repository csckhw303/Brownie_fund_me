//SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


contract FundMe {
    mapping(address => uint256) public addressToAmountFunded;
    address public owner;
    address[] public funders;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
       owner = msg.sender;
       priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function fund() public payable {
       uint256 minVal = 50 * (10 ** 18);
       require(getEitherInUsd(msg.value) > minVal, "Need to be over 50 USD");
       addressToAmountFunded[msg.sender] += msg.value;
       funders.push(msg.sender);

    }

    function getVersion() public view returns (uint256) {
        //AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        return priceFeed.version();
    }

    function getEitherToUsdRateInWei() public view returns (uint256) {
        //AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);

        (,int256 answer,,,) = priceFeed.latestRoundData();
        //ether 2,069.69000000 * (10**8)
        //wei => answer * (10 ** 10)  256: 204896394572
        return uint256(answer * (10 ** 10)) ;
    }

    function getEitherInUsd(uint256 etherInWei) public view returns (uint256) {
        uint256 etherInUsd = (etherInWei * uint256(getEitherToUsdRateInWei())) / (10**18);
        return etherInUsd;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function getEntranceFee() public view returns (uint256) {
        uint256 mimimumUSD = 50 * 10**18;
        uint256 price = getEitherToUsdRateInWei();
        uint256 precision = 1* 10**18;
        return (mimimumUSD * precision) / price;
    }
    function withdraw() payable onlyOwner public  {
        payable(msg.sender).transfer(address(this).balance);
        
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
             address funder = funders[funderIndex];
             addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
    }

}