// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SimpleDonation
/// @notice A single-campaign ETH donation contract with separate owner and beneficiary roles.
contract SimpleDonation {
    // The owner manages the campaign but cannot withdraw its funds.
    address public owner;
    address payable public beneficiary;

    // Donation history is cumulative and is not reduced by withdrawals.
    bool public campaignActive;
    uint256 public totalDonated;
    mapping(address => uint256) public donations;

    // Reentrancy guard for withdrawals.
    bool private locked;

    event Donated(address indexed donor, uint256 amount);
    event CampaignStatusChanged(bool active);
    event Withdrawn(address indexed to, uint256 amount);
    event BeneficiaryChanged(
        address indexed oldBeneficiary,
        address indexed newBeneficiary
    );

    constructor(address payable initialBeneficiary) {
        require(initialBeneficiary != address(0), "Invalid beneficiary address");

        owner = msg.sender;
        beneficiary = initialBeneficiary;
        campaignActive = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyBeneficiary() {
        require(msg.sender == beneficiary, "Only beneficiary can call this function");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    /// @notice Donate ETH to the active campaign.
    function donate() external payable {
        require(campaignActive, "Campaign is not active");
        require(msg.value > 0, "Donation must be greater than zero");

        donations[msg.sender] += msg.value;
        totalDonated += msg.value;
        emit Donated(msg.sender, msg.value);
    }

    /// @notice Enable or pause donations. Only the owner can change this setting.
    function setCampaignActive(bool active) external onlyOwner {
        campaignActive = active;
        emit CampaignStatusChanged(active);
    }

    /// @notice Change the recipient after all ETH has been withdrawn.
    function changeBeneficiary(address payable newBeneficiary) external onlyOwner {
        require(newBeneficiary != address(0), "Invalid beneficiary address");
        require(address(this).balance == 0, "Contract balance must be zero");

        address oldBeneficiary = beneficiary;
        beneficiary = newBeneficiary;
        emit BeneficiaryChanged(oldBeneficiary, newBeneficiary);
    }

    /// @notice Send the full contract balance to the beneficiary.
    function withdraw() external onlyBeneficiary nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        (bool success, ) = beneficiary.call{value: balance}("");
        require(success, "Withdrawal failed");

        emit Withdrawn(beneficiary, balance);
    }

    /// @notice Return all ETH ever donated, rounded down to whole ETH.
    function getTotalDonatedInEther() external view returns (uint256) {
        return totalDonated / 1 ether;
    }

    /// @notice Return the caller's cumulative donations, rounded down to whole ETH.
    function getMyDonationInEther() external view returns (uint256) {
        return donations[msg.sender] / 1 ether;
    }

    /// @notice Return the current contract balance, rounded down to whole ETH.
    function getContractBalanceInEther() external view returns (uint256) {
        return address(this).balance / 1 ether;
    }
}
