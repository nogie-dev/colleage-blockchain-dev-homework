// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Campaign {
    bool public campaignActive;
    bool public succeeded;

    // Included so the true branch of isOpen() can be exercised in Remix.
    function activate() external {
        campaignActive = true;
    }

    function finalize() external {
        campaignActive = false;
        succeeded = true;
    }

    function isOpen() external view returns (bool) {
        return campaignActive && !succeeded;
    }
}
