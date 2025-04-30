// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public totalRaised;
    mapping(address => uint) public contributions;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }

    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= deadline, "Campaign still active");
        require(totalRaised >= goal, "Goal not met");

        payable(owner).transfer(address(this).balance);
    }

    function refund() external {
        require(block.timestamp >= deadline, "Campaign still active");
        require(totalRaised < goal, "Goal was met");

        uint amount = contributions[msg.sender];
        require(amount > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function getCampaignDetails() external view returns (
        address _owner,
        uint _goal,
        uint _deadline,
        uint _totalRaised
    ) {
        return (owner, goal, deadline, totalRaised);
    }

    function getContributorAmount(address contributor) external view returns (uint) {
        return contributions[contributor];
    }
}
