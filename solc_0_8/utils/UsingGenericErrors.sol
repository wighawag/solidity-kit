// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface UsingGenericErrors {
    /// @notice Not authorized to perform this operation
    error NotAuthorized();

    /// @notice Token cannot be transfered
    error NonTransferable();

    /// @notice function is not implemented
    error NotImplemented();
}
