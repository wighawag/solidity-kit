// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingERC2981AdministrationEvents.sol";

interface IERC2981Administration is UsingERC2981AdministrationEvents {
    /// @notice address allowed to set royalty parameters
    function royaltyAdmin() external returns (address);

    /// @notice set a new royalty receiver and rate, Can only be set by the `royaltyAdmin`.
    /// @param newReceiver the address that should receive the royalty proceeds.
    /// @param royaltyPer10Thousands the share of the salePrice (in 1/10000) given to the receiver.
    function setRoyaltyParameters(address newReceiver, uint96 royaltyPer10Thousands) external;

    /// @notice set the new royaltyAdmin that can change the royalties.
    /// @param newRoyaltyAdmin admin's address going forward
    function setRoyaltyAdmin(address newRoyaltyAdmin) external;
}
