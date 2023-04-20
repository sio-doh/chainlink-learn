// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

contract Capsule is KeeperCompatibleInterface {
    uint private lockedUntil;

    function deposit(uint _lockedUntil) external payable {
        require(block.timestamp >= lockedUntil, "Deposit is not allowed until previous lock time has passed");
        lockedUntil = _lockedUntil;
    }

    function checkUpkeep(bytes calldata) external pure override returns (bool, bytes memory) {
        return (true, bytes(""));
    }

    function performUpkeep(bytes calldata) external override {
        
    }   
}