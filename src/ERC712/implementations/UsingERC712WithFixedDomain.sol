// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingERC712.sol";
import "./Named.sol";
import "../../utils/ShortString.sol";

abstract contract UsingERC712WithFixedDomain is UsingERC712, Named {
	bytes32 internal immutable _DOMAIN_SEPARATOR;
	ShortString internal immutable VERSION;

	constructor(string memory version) {
		require(bytes(version).length > 0, "version need to be specified");
		VERSION = toShortString(version);
		_DOMAIN_SEPARATOR = keccak256(
			abi.encode(
				keccak256("EIP712Domain(string name,string version,address verifyingContract)"),
				keccak256(bytes(name())),
				keccak256(bytes(version)),
				address(this)
			)
		);
	}

	function eip712Domain()
		external
		view
		returns (
			bytes1,
			string memory,
			string memory,
			uint256,
			address,
			bytes32,
			uint256[] memory
		)
	{
		// 0x0B == 01011 (name, version, , verifyingContract)
		return (0x0B, name(), toString(VERSION), 0, address(this), bytes32(0), new uint256[](0));
	}
}
