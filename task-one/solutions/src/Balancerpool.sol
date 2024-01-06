// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract BalancerPool {
    struct depositDetails {
        bool depositStatus;
        uint depositAmount;
        uint timeDeposited;
        uint lastRewardclaimTime;
        uint tokenEarned;
    }
    address owner;
    address yieldAddress;
    address token;
    uint totaldeposit;
    uint cummulativeFees;
    uint8 feeOnEntryPercentage;
    uint totalAccumulatedFees;
    mapping(address => depositDetails) userInfo;

    constructor(uint8 percentageFee, address _token) {
        require(percentageFee != 0 && feepercent <= 10, "invalid");
        require(_token != address(0), "invalid");
        feeOnEntryPercentage = feepercent;
        owner = msg.sender;
        token = _token;
    }

    uint256 constant YEAR_IN_SECONDS = 31536000;

    function gateKeep(address _user, uint _amount) internal view {
        require(_user != address(0), "non-zero");
        require(_amount != 0, "invalid");
        require(msg.sender == yieldAddress, "not yield");
    }

    function enterpool(uint amount, address user) public {
        gateKeep(user, amount);
        require(amount >= 0.000005 ether, "below Minimum");
        uint fee = (amount * feeOnEntryPercentage) / 100;
        uint incomingDeposit = amount - fee;
        if (userInfo[user].depositStatus) {
            uint reward = calculatereward(user);
            userInfo[user].tokenEarned += reward;
            userInfo[user].lastRewardclaimTime = block.timestamp;
            userInfo[user].depositAmount += incomingDeposit;
            cummulativeFees = cummulativeFees + fee;
            totalAccumulatedFees += fee;
            totaldeposit += amount;
        } else {
            userInfo[user].depositStatus = true;
            userInfo[user].depositAmount = incomingDeposit;
            userInfo[user].timeDeposited = block.timestamp;
            cummulativeFees = cummulativeFees + fee;
            totalAccumulatedFees += fee;
            totaldeposit += amount;
        }
    }

    function exitpool(address user, uint rewardAmount) public {
        require(msg.sender == yieldAddress, "not yield");
        require(userInfo[user].depositStatus, "no deposit");
        uint totalWithdrawal = userInfo[user].depositAmount + rewardAmount;
        userInfo[user].lastRewardclaimTime = block.timestamp;
        userInfo[user].depositStatus = false;
        userInfo[user].depositAmount = 0;
        userInfo[user].timeDeposited = 0;
        totaldeposit -= totalWithdrawal;
        IERC20(token).transfer(user, totalWithdrawal);
    }

    function withdrawReward(uint Rewardamount, address user) public {
        gateKeep(user, Rewardamount);
        userInfo[user].lastRewardclaimTime = block.timestamp;
        uint cummulative = userInfo[user].tokenEarned;
        require(cummulativeFees > Rewardamount, "check back");
        cummulativeFees -= Rewardamount;
        IERC20(token).transfer(user, Rewardamount + cummulative);
    }

    function userDetails(
        address user
    ) public view returns (depositDetails memory) {
        return userInfo[user];
    }

    function getPoolBalance() public view returns (uint) {
        return totaldeposit;
    }

    function init(address yield) public {
        require(msg.sender == owner, "not authorized");
        require(yield != address(0), "non-zero");
        yieldAddress = yield;
    }

    function calculatereward(address _user) public view returns (uint) {
        uint amount = userInfo[_user].depositAmount;
        uint calculatedrewards;
        if (userInfo[_user].lastRewardclaimTime == 0) {
            uint rewardtime = block.timestamp - userInfo[_user].timeDeposited;

            calculatedrewards =
                (rewardtime * 50 * amount) /
                (YEAR_IN_SECONDS * 100);
        } else {
            uint rewardtime = block.timestamp -
                userInfo[_user].lastRewardclaimTime;
            calculatedrewards =
                (rewardtime * 50 * amount) /
                (YEAR_IN_SECONDS * 100);
        }
        return calculatedrewards;
    }
}
