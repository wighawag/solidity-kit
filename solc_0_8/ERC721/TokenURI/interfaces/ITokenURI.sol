// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITokenURI {
    /// @notice Returns the Uniform Resource Identifier (URI) for token `id`.
    /// @param tokenID the token to query
    function tokenURI(uint256 tokenID) external view returns (string memory);
}
