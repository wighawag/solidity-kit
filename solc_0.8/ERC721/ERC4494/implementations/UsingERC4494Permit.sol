// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../implementations/ImplementingERC721Internal.sol";
import "../../../ERC165/implementations/UsingERC165Internal.sol";
import "../interfaces/IERC4494.sol";
import "../../../ERC712/implementations/UsingERC712.sol";
import "../../../ERC712/implementations/ImplementingExternalDomainSeparator.sol";
import "../../../ERC721/interfaces/IERC721.sol";

import "../../..//openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "../../../openzeppelin/contracts/utils/Address.sol";

abstract contract UsingERC4494Permit is
	IERC4494,
	IERC4494PermitForAll,
	IERC4494Alternative,
	ImplementingERC721Internal,
	UsingERC165Internal,
	ImplementingExternalDomainSeparator,
	UsingERC712
{
	bytes32 public constant PERMIT_TYPEHASH =
		keccak256("Permit(address spender,uint256 tokenId,uint256 nonce,uint256 deadline)");
	bytes32 public constant PERMIT_FOR_ALL_TYPEHASH =
		keccak256("PermitForAll(address owner,address spender,uint256 nonce,uint256 deadline)");

	mapping(address => uint256) internal _userNonces;

	/// @inheritdoc IERC4494PermitForAll
	function nonces(address account) external view virtual returns (uint256 nonce) {
		return _userNonces[account];
	}

	/// @inheritdoc IERC4494
	function nonces(uint256 id) public view virtual returns (uint256 nonce) {
		(address owner, uint256 blockNumber) = _ownerAndBlockNumberOf(id);
		if (owner == address(0)) {
			revert IERC721.NonExistentToken(id);
		}
		return blockNumber;
	}

	/// @inheritdoc IERC4494Alternative
	function tokenNonces(uint256 tokenId) external view returns (uint256 nonce) {
		return nonces(tokenId);
	}

	/// @inheritdoc IERC4494
	function permit(
		address spender,
		uint256 tokenId,
		uint256 deadline,
		bytes memory sig
	) external override(IERC4494, IERC4494Alternative) {
		if (block.timestamp > deadline) {
			revert DeadlineOver(block.timestamp, deadline);
		}

		(address owner, uint256 blockNumber) = _ownerAndBlockNumberOf(tokenId);
		if (owner == address(0)) {
			revert IERC721.NonExistentToken(tokenId);
		}

		// We use blockNumber as nonce as we already store it per tokens. It can thus act as an increasing transfer counter.
		// while technically multiple transfer could happen in the same block, the signed message would be using a previous block.
		// And the transfer would use then a more recent blockNumber, invalidating that message when transfer is executed.
		_requireValidPermit(owner, spender, tokenId, deadline, blockNumber, sig);

		_approveFor(owner, blockNumber, spender, tokenId);
	}

	/// @inheritdoc IERC4494PermitForAll
	function permitForAll(
		address signer,
		address spender,
		uint256 deadline,
		bytes memory sig
	) external {
		if (block.timestamp > deadline) {
			revert DeadlineOver(block.timestamp, deadline);
		}

		_requireValidPermitForAll(signer, spender, deadline, _userNonces[signer]++, sig);

		_setApprovalForAll(signer, spender, true);
	}

	/// @inheritdoc IERC165
	function supportsInterface(bytes4 id) public view virtual override(IERC165, UsingERC165Internal) returns (bool) {
		return
			super.supportsInterface(id) ||
			id == type(IERC4494).interfaceId ||
			id == type(IERC4494Alternative).interfaceId;
	}

	/// @inheritdoc ImplementingExternalDomainSeparator
	function DOMAIN_SEPARATOR()
		public
		view
		virtual
		override(IERC4494, IERC4494PermitForAll, IERC4494Alternative, ImplementingExternalDomainSeparator)
		returns (bytes32);

	// ------------------------------------------------------------------------------------------------------------------
	// INTERNALS
	// ------------------------------------------------------------------------------------------------------------------

	function _requireValidPermit(
		address signer,
		address spender,
		uint256 id,
		uint256 deadline,
		uint256 nonce,
		bytes memory sig
	) internal view {
		bytes32 digest = keccak256(
			abi.encodePacked(
				"\x19\x01",
				DOMAIN_SEPARATOR(),
				keccak256(abi.encode(PERMIT_TYPEHASH, spender, id, nonce, deadline))
			)
		);
		if (!Openzeppelin_SignatureChecker.isValidSignatureNow(signer, digest, sig)) {
			revert InvalidSignature();
		}
	}

	function _requireValidPermitForAll(
		address signer,
		address spender,
		uint256 deadline,
		uint256 nonce,
		bytes memory sig
	) internal view {
		bytes32 digest = keccak256(
			abi.encodePacked(
				"\x19\x01",
				DOMAIN_SEPARATOR(),
				keccak256(abi.encode(PERMIT_FOR_ALL_TYPEHASH, signer, spender, nonce, deadline))
			)
		);
		if (!Openzeppelin_SignatureChecker.isValidSignatureNow(signer, digest, sig)) {
			revert InvalidSignature();
		}
	}
}
