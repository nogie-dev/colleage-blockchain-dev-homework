// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct DonorProfile {
    string name;
    uint256 score;
}

contract ProfileBook {
    mapping(address => DonorProfile) public profiles;

    function join(string calldata donorName) external {
        profiles[msg.sender] = DonorProfile(donorName, 0);
    }

    function addScore(uint256 pointsToAdd) external {
        profiles[msg.sender].score += pointsToAdd;
    }

    // The generated public getter omits the dynamic string field.
    function getProfile(address donor)
        external
        view
        returns (string memory name, uint256 score)
    {
        DonorProfile storage profile = profiles[donor];
        return (profile.name, profile.score);
    }
}
