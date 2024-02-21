// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ITokenURI.sol";

interface UsingERC721ExternalTokenURIEvents {
    /// @notice Triggered when the external tokenURI contract is updated/set.
    /// @param newTokenURIContract the new tokenURI contract
    event TokenURIContractSet(ITokenURI newTokenURIContract);

    /// @notice Triggered when the account in charge of tokenURI updates is updated/set.
    /// @param newTokenURIAdmin the new tokenURI admin
    event TokenURIAdminSet(address newTokenURIAdmin);
}
