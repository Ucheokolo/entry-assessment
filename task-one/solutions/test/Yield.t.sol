// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Balancerpool.sol";
import "../src/yeildcontract.sol";
import "../src/Token.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract YeildTest is Test {
    BalancerPool balancepool;
    yieldcontract yield;
    Token token;

    address owner = 0x02A3d139330F2Ee3290B4e13CAaEe59d0B5d9E45;
    address user1 = 0x14c9594d44114cFB41945Dc8995fE4a693D5CB4d;
    address user2 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address user3 = 0xDBA00511eD84Cef732635f4bfEAbB31B89c88801;
    address user4 = 0xA1c55b18611f5D2cF6E9DD5615b8D0049902Bf73;

    function setUp() public {
        address[5] memory users = [owner, user1, user2, user3, user4];
        vm.startPrank(owner);
        token = new Token("testUsdt", "usdt");
        balancepool = new BalancerPool(5, address(token));
        yield = new yeildcontract(address(balancerpool), address(token));
        balancerpool.init(address(yield));
        for (uint256 index = 0; index < users.length; index++) {
            token.Mint(users[index], 50 ether);
        }
        vm.stopPrank();
    }

    function test_Deposit() public {
        vm.startPrank(user1);
        token.approve(address(yield), 1 ether);
        yield.Deposit(1 ether);
        vm.stopPrank();

        vm.startPrank(user2);
        token.approve(address(yield), 50 ether);
        yield.Deposit(50 ether);
        vm.stopPrank();

        vm.startPrank(user3);
        token.approve(address(yield), 50 ether);
        yield.Deposit(50 ether);
        vm.stopPrank();

        vm.startPrank(user4);
        token.approve(address(yield), 50 ether);
        yield.Deposit(50 ether);
        vm.stopPrank();
    }

    function test_exitpool() public {
        test_Deposit();
        vm.startPrank(user1);
        vm.warp(block.timestamp + 365 days);
        yield.exitYield();
        vm.stopPrank();
    }
}
