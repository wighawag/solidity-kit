// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IExternalContractURI {
    /// @notice Returns the Uniform Resource Identifier (URI) for the token collection.
    function contractURI(address receiver, uint96 per10Thousands) external view returns (string memory);
}

interface IContractURI {
    /// @notice Returns the Uniform Resource Identifier (URI) for the token collection.
    function contractURI() external view returns (string memory);
}
