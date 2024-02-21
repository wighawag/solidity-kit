// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingERC173Events.sol";

interface UsingERC173Events {
    /// @notice This emits when ownership of the contract changes.
    /// @param previousOwner the previous owner
    /// @param newOwner the new owner
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
}
