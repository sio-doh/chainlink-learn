// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

contract Capsule is KeeperCompatibleInterface {
    address private depositor;
    uint256 private lockedUntil;

    function deposit(uint _lockedUntil) external payable {
        require(block.timestamp >= lockedUntil, "Deposit is not allowed until previous lock time has passed");
        lockedUntil = _lockedUntil; 
        depositor = msg.sender; // keep track of the original depositor
    }

    function checkUpkeep(bytes calldata) external view override returns (bool, bytes memory) {
        return (block.timestamp >= lockedUntil, bytes("0x"));
    }

    function performUpkeep(bytes calldata) external override {
        require(block.timestamp >= lockedUntil, "Locked time has not been reached");
        uint amount = address(this).balance; // get the balance of the contract
        require(amount > 0, "No funds available to pay out");
        payable(depositor).transfer(amount); // transfer the funds back to the depositor
        lockedUntil = type(uint256).max; // reset the locked time
    }
}