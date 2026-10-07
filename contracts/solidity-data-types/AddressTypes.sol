// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A learning example for address members, payable casts, and ETH calls.
contract AddressTypes {
    address public owner;
    address public donor;
    address payable public beneficiary;

    constructor(address payable initialBeneficiary) {
        require(initialBeneficiary != address(0), "Invalid beneficiary");
        owner = msg.sender;
        donor = msg.sender;
        beneficiary = initialBeneficiary;
    }

    function inspectDonor()
        external
        view
        returns (uint256 balance, bytes32 codehash, bytes memory code)
    {
        return (donor.balance, donor.codehash, donor.code);
    }

    function setBeneficiary(address newBeneficiary) external {
        require(msg.sender == owner, "Only owner");
        require(newBeneficiary != address(0), "Invalid beneficiary");
        beneficiary = payable(newBeneficiary);
    }

    function deposit() external payable {}

    function sendToBeneficiary(uint256 amount) external {
        require(msg.sender == owner, "Only owner");
        require(amount <= address(this).balance, "Insufficient balance");

        (bool success, ) = beneficiary.call{value: amount}("");
        require(success, "ETH transfer failed");
    }
}
