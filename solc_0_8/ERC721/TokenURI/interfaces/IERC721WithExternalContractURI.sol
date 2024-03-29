// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IContractURI.sol";
import "./UsingERC721ExternalContractURIEvents.sol";

interface IERC721WithExternalContractURI is IContractURI, UsingERC721ExternalContractURIEvents {
    /// @notice the contract that return the contract metadata
    function contractURIAddress() external returns (IExternalContractURI);

    /// @notice contractURIAdmin can update the ContractURI contract, this is intended to be relinquished.
    function contractURIAdmin() external returns (address);

    /// @notice set the new contractURIAdmin that can change the contractURI
    /// Can only be called by the current contractURI admin.
    function setContractURIAdmin(address newContractURIAdmin) external;

    /// @notice set a new contractURI contract, that generate the metadata including the wav file, Can only be set by the `contractURIAdmin`.
    /// @param newContractURIAddress The address of the new contractURI contract.
    function setContractURI(IExternalContractURI newContractURIAddress) external;
}
