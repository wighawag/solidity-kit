// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface UsingERC2981AdministrationErrors {
    /// @notice The Royality rate exceed the maximum allowed
    /// @param royaltyPer10ThousandsProvided royalty rate provided (per 10,000)
    /// @param max maximum rate allowed (per 10,000)
    error RoyaltyTooHigh(uint256 royaltyPer10ThousandsProvided, uint256 max);
}
