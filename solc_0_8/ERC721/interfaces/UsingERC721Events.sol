// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface UsingERC721Events {
    /// @notice Triggered when a token is transferred
    /// @param from the account the token is sent from
    /// @param to the account the token is sent to
    /// @param tokenID id of the token being sent
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenID);

    /// @notice Triggered when a token is approved to be sent by another account
    ///  Note tat the approval get reset when a Transfer event for that same token is emitted.
    /// @param owner current owner of the token
    /// @param approved account who can know transfer on the owner's behalf
    /// @param tokenID id of the token being approved
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenID);

    /// @notice Triggered when an account approve or disaprove another to transfer on its behalf
    /// @param owner the account granting rights over all of its token
    /// @param operator account who can know transfer on the owner's behalf
    /// @param approved whether it is approved or not
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}
