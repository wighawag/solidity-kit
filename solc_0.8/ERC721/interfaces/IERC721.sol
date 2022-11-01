// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../ERC165/interfaces/IERC165.sol";

interface IERC721Supply {
	function totalSupply() external view returns (uint256);
}

interface IERC721 is IERC165 {
	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

	error NonExistentToken(uint256 tokenID);
	error NotAuthorized();
	error NotOwner(address provided, address expected);
	error InvalidAddress(address invalid);
	error TransferRejected();

	/// @notice Get the number of tokens owned by an address.
	/// @param owner The address to look for.
	/// @return balance The number of tokens owned by the address.
	function balanceOf(address owner) external view returns (uint256 balance);

	/// @notice Get the owner of a token.
	/// @param tokenId The id of the token.
	/// @return owner The address of the token owner.
	function ownerOf(uint256 tokenId) external view returns (address owner);

	/// @notice Transfer a token between 2 addresses letting the receiver knows of the transfer.
	/// @param from The sender of the token.
	/// @param to The recipient of the token.
	/// @param tokenId The id of the token.
	/// @param data Additional data.
	function safeTransferFrom(
		address from,
		address to,
		uint256 tokenId,
		bytes calldata data
	) external;

	/// @notice Transfer a token between 2 addresses letting the receiver know of the transfer.
	/// @param from The send of the token.
	/// @param to The recipient of the token.
	/// @param tokenId The id of the token.
	function safeTransferFrom(
		address from,
		address to,
		uint256 tokenId
	) external;

	/// @notice Transfer a token between 2 addresses.
	/// @param from The sender of the token.
	/// @param to The recipient of the token.
	/// @param tokenId The id of the token.
	function transferFrom(
		address from,
		address to,
		uint256 tokenId
	) external;

	/// @notice Approve an operator to transfer a specific token on the senders behalf.
	/// @param operator The address receiving the approval.
	/// @param tokenId The id of the token.
	function approve(address operator, uint256 tokenId) external;

	/// @notice Set the approval for an operator to manage all the tokens of the sender.
	/// @param operator The address receiving the approval.
	/// @param approved The determination of the approval.
	function setApprovalForAll(address operator, bool approved) external;

	/// @notice Get the approved operator for a specific token.
	/// @param tokenId The id of the token.
	/// @return operator The address of the operator.
	function getApproved(uint256 tokenId) external view returns (address operator);

	/// @notice Check if the sender approved the operator.
	/// @param owner The address of the owner.
	/// @param operator The address of the operator.
	/// @return isOperator The status of the approval.
	function isApprovedForAll(address owner, address operator) external view returns (bool);
}
