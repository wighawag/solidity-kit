// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IContractURI.sol";

interface UsingERC721ExternalContractURIEvents {
    /// @notice Triggered when the external contractURI contract is updated/set.
    /// @param newContractURIAddress the contractURI contract
    event ContractURIAddressSet(IExternalContractURI newContractURIAddress);

    /// @notice Triggered when the account in charge of contractURI updates is updated/set.
    /// @param newContractURIAdmin the new contractURI admin
    event ContractURIAdminSet(address newContractURIAdmin);
}
