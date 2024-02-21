// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface UsingERC721ExternalMinterEvents {
    /// @notice Triggered when the account in charge of minter updates is updated/set.
    /// @param newMinterAdmin the new minter admin
    event MinterAdminSet(address newMinterAdmin);

    /// @notice Triggered when the minter is updated/set.
    /// @param newMinter the new minter
    event MinterSet(address newMinter);
}
