// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingERC721ExternalMinterEvents.sol";

interface IERC721Mintable {}

interface IERC721WithExternalMinter is UsingERC721ExternalMinterEvents {
    /// @notice minterAdmin can update the minter.
    function minterAdmin() external returns (address);

    /// @notice address allowed to mint, allow the sale contract to be separated from the token contract.
    function minter() external returns (address);

    /// @notice set the new minterAdmin that can set the minter
    /// @param newMinterAdmin new address to use as minter admin
    function setMinterAdmin(address newMinterAdmin) external;

    /// @notice set the new minter that can mint
    /// @param newMinter new address to use as minter
    function setMinter(address newMinter) external;
}
