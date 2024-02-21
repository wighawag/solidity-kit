// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingERC173Events.sol";

interface IERC173 is UsingERC173Events {
    /// @notice Get the address of the owner
    /// @return The address of the owner.
    function owner() external view returns (address);

    /// @notice Set the address of the new owner of the contract
    /// @dev Set newOwner to address(0) to renounce any ownership.
    /// @param newOwner The address of the new owner of the contract
    function transferOwnership(address newOwner) external;
}
