// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface UsingERC20Events {
    /// @notice trigger when tokens are transferred, including zero value transfers.
    /// @param from the account the tokens are sent from
    /// @param to the account the tokens are sent to
    /// @param value number of tokens sent
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// @notice trigger on approval amount being set.
    ///   Note that Transfer events need to be considered to compute the current allowance.
    /// @param owner the account approving the `spender`
    /// @param spender the account allowed to spend
    /// @param value the amount granted
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
