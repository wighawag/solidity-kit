// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface UsingERC721Errors {
    /// @notice The token does not exist
    /// @param tokenID id of the expected token
    error NonExistentToken(uint256 tokenID);

    /// @notice The address from which the token is sent is not the current owner
    /// @param provided the address expected to be the current owner
    /// @param currentOwner the current owner
    error NotOwner(address provided, address currentOwner);

    /// @notice An invalid address is specified (for example: zero address)
    /// @param addr invalid address
    error InvalidAddress(address addr);

    /// @notice The Transfer was rejected by the destination
    error TransferRejected();

    /// @notice The Nonce overflowed, make a transfer to self to allow new nonces.
    error NonceOverflow();
}
