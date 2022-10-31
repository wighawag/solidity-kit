// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../ERC165/interfaces/IERC165.sol";

interface IERC721 is IERC165 {
	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

	error NonExistentToken(uint256 tokenID);
	error NotAuthorized();
	error NotOwner(address provided, address expected);
	error InvalidAddress(address invalid);
	error TransferRejected();
	error InvalidOwner(address invalid);

	function balanceOf(address owner) external view returns (uint256 balance);

	function ownerOf(uint256 tokenId) external view returns (address owner);

	function safeTransferFrom(
		address from,
		address to,
		uint256 tokenId,
		bytes calldata data
	) external;

	function safeTransferFrom(
		address from,
		address to,
		uint256 tokenId
	) external;

	function transferFrom(
		address from,
		address to,
		uint256 tokenId
	) external;

	function approve(address to, uint256 tokenId) external;

	function setApprovalForAll(address operator, bool _approved) external;

	function getApproved(uint256 tokenId) external view returns (address operator);

	function isApprovedForAll(address owner, address operator) external view returns (bool);
}
