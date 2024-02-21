// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../ERC165/interfaces/IERC165.sol";
import "./UsingERC721Events.sol";

interface IERC721Supply {
    /// @notice return the total number of token in existence
    function totalSupply() external view returns (uint256);
}

interface IERC721 is IERC165, UsingERC721Events {
    /// @notice Get the number of tokens owned by an address.
    /// @param owner The address to look for.
    /// @return balance The number of tokens owned by the address.
    function balanceOf(address owner) external view returns (uint256 balance);

    /// @notice Get the owner of a token.
    /// @param tokenID The id of the token.
    /// @return owner The address of the token owner.
    function ownerOf(uint256 tokenID) external view returns (address owner);

    /// @notice Transfer a token between 2 addresses letting the receiver knows of the transfer.
    /// @param from The sender of the token.
    /// @param to The recipient of the token.
    /// @param tokenID The id of the token.
    /// @param data Additional data.
    function safeTransferFrom(address from, address to, uint256 tokenID, bytes calldata data) external;

    /// @notice Transfer a token between 2 addresses letting the receiver know of the transfer.
    /// @param from The send of the token.
    /// @param to The recipient of the token.
    /// @param tokenID The id of the token.
    function safeTransferFrom(address from, address to, uint256 tokenID) external;

    /// @notice Transfer a token between 2 addresses.
    /// @param from The sender of the token.
    /// @param to The recipient of the token.
    /// @param tokenID The id of the token.
    function transferFrom(address from, address to, uint256 tokenID) external;

    /// @notice Approve an operator to transfer a specific token on the senders behalf.
    /// @param operator The address receiving the approval.
    /// @param tokenID The id of the token.
    function approve(address operator, uint256 tokenID) external;

    /// @notice Set the approval for an operator to manage all the tokens of the sender.
    /// @param operator The address receiving the approval.
    /// @param approved The determination of the approval.
    function setApprovalForAll(address operator, bool approved) external;

    /// @notice Get the approved operator for a specific token.
    /// @param tokenID The id of the token.
    /// @return operator The address of the operator.
    function getApproved(uint256 tokenID) external view returns (address operator);

    /// @notice Check if the sender approved the operator to transfer any of its tokens.
    /// @param owner The address of the owner.
    /// @param operator The address of the operator.
    /// @return isOperator The status of the approval.
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}
