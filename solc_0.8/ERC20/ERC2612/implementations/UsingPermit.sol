// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../implementations/ImplementingERC20Internal.sol";
import "../interfaces/IERC2612Standalone.sol";
import "../../../ERC712/implementations/UsingERC712.sol";
import "./ImplementingExternalDomainSeparator.sol";

error InvalidAddress(address addr);
error InvalidSignature();
error DeadlineOver(uint256 currentTime, uint256 deadline);

abstract contract UsingPermit is
	ImplementingERC20Internal,
	ImplementingExternalDomainSeparator,
	IERC2612Standalone,
	UsingERC712
{
	bytes32 internal constant PERMIT_TYPEHASH =
		keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

	mapping(address => uint256) internal _nonces;

	/// @inheritdoc IERC2612Standalone
	function nonces(address owner) external view returns (uint256) {
		return _nonces[owner];
	}

	/// @inheritdoc IERC2612Standalone
	function DOMAIN_SEPARATOR()
		public
		view
		virtual
		override(IERC2612Standalone, ImplementingExternalDomainSeparator)
		returns (bytes32);

	/// @inheritdoc IERC2612Standalone
	function permit(
		address owner,
		address spender,
		uint256 value,
		uint256 deadline,
		uint8 v,
		bytes32 r,
		bytes32 s
	) external override {
		if (owner == address(0)) {
			revert InvalidAddress(address(0));
		}

		uint256 currentNonce = _nonces[owner];
		bytes32 digest = keccak256(
			abi.encodePacked(
				"\x19\x01",
				DOMAIN_SEPARATOR(),
				keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentNonce, deadline))
			)
		);
		if (owner != ecrecover(digest, v, r, s)) {
			revert InvalidSignature();
		}
		if (deadline != 0 && block.timestamp > deadline) {
			revert DeadlineOver(block.timestamp, deadline);
		}

		_nonces[owner] = currentNonce + 1;
		_approveFor(owner, spender, value);
	}
}
