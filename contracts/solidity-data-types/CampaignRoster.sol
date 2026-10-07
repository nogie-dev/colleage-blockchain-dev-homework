// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CampaignRoster {
    uint256[] public campaignIds;

    function open(uint256 campaignId) external {
        campaignIds.push(campaignId);
    }

    function closeLast() external {
        require(campaignIds.length > 0, "Roster is empty");
        campaignIds.pop();
    }

    function swapRemove(uint256 index) external {
        campaignIds[index] = campaignIds[campaignIds.length - 1];
        campaignIds.pop();
    }
}
