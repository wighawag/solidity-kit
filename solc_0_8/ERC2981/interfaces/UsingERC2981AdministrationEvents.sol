// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface UsingERC2981AdministrationEvents {
    /// @notice Triggered when Royalty receiver and/or rate is updated/set
    /// @param receiver the account receiving the royalty
    /// @param royaltyPer10Thousands the royalty rate (per 10,000)
    event RoyaltySet(address receiver, uint256 royaltyPer10Thousands);

    /// @notice Triggered when the account in charge of royalty settings is updated/set.
    /// @param newRoyaltyAdmin the new royalty admin
    event RoyaltyAdminSet(address newRoyaltyAdmin);
}
