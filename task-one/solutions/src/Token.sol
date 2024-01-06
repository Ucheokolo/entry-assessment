// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    string _name;
    string _symbol;
    address _owner;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Unauthorized Person");
        _;
    }

    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {
        _name = name_;
        _symbol = symbol_;
        _owner = msg.sender;
    }

    function Mint(address _recipient, uint value) public onlyOwner {
        _mint(_recipient, value * (10 ** decimals()));
    }
}
