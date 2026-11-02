// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title UnsafeBank
/// @notice A simple bank holding users' ETH deposits.
contract UnsafeBank {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "insufficient");
        balances[msg.sender] -= amount;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "transfer failed");
    }

    /// @dev VULNERABLE: missing an onlyOwner check — ANY caller can drain the
    ///      entire contract to an address of their choosing.
    function sweep(address payable to) external {
        to.transfer(address(this).balance);
    }
}