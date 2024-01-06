// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "/Users/uchennaokolo/Desktop/here/entry-assessment/task-one/solutions/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

struct depositDetails {
    bool depositStatus;
    uint depositAmount;
    uint timeDeposited;
    uint lastRewardclaimTime;
}

interface IbalancerPool {
    function enterpool(uint amount, address user) external;

    function withdrawReward(uint Rewardamount, address user) external;

    function userDetails(
        address user
    ) external view returns (depositDetails memory);

    function exitpool(address user, uint rewardAmount) external;

    function calculatereward(address _user) external view returns (uint);
}

contract Yield {
    address token_addr;
    address pool_addr;

    constructor(address pool, address token) {
        pool_addr = pool;
        token_addr = token;
    }

    function Deposit(uint amount) public {
        IERC20(token_addr).transferFrom(msg.sender, pool_addr, amount);
        IbalancerPool(pool_addr).enterpool(amount, msg.sender);
    }

    function claimReward() public {
        uint rewards = IbalancerPool(pool_addr).calculatereward(msg.sender);
        require(rewards != 0, "no reward");
        IbalancerPool(pool_addr).withdrawReward(rewards, msg.sender);
    }

    function exitYield() public {
        uint rewards = IbalancerPool(pool_addr).calculatereward(msg.sender);
        IbalancerPool(pool_addr).exitpool(msg.sender, rewards);
    }
}
