// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingERC712.sol";
import "./Named.sol";

abstract contract UsingERC712WithDynamicChainId is UsingERC712, Named {
	uint256 private immutable _deploymentChainId;
	bytes32 private immutable _deploymentDomainSeparator;

	constructor(address verifyingContract) {
		uint256 chainId;
		assembly {
			chainId := chainid()
		}

		_deploymentChainId = chainId;
		_deploymentDomainSeparator = _calculateDomainSeparator(
			chainId,
			verifyingContract == address(0) ? address(this) : verifyingContract
		);
	}

	/// @inheritdoc IERC5267
	function eip712Domain()
		external
		view
		virtual
		override
		returns (
			bytes1 fields,
			string memory name,
			string memory version,
			uint256 chainId,
			address verifyingContract,
			bytes32 salt,
			uint256[] memory extensions
		)
	{
		fields = 0x0D;
		name = _name();
		version = "";
		assembly {
			chainId := chainid()
		}
		verifyingContract = address(this);
		salt = 0;
		extensions = new uint256[](0);
	}

	// ------------------------------------------------------------------------------------------------------------------
	// INTERNALS
	// ------------------------------------------------------------------------------------------------------------------

	// need to ensure we can use return value "name" in `eip712Domain`
	function _name() internal view returns (string memory) {
		return name();
	}

	function _currentDomainSeparator() internal view returns (bytes32) {
		uint256 chainId;
		assembly {
			chainId := chainid()
		}

		// in case a fork happen, to support the chain that had to change its chainId, we compute the domain operator
		return
			chainId == _deploymentChainId
				? _deploymentDomainSeparator
				: _calculateDomainSeparator(chainId, address(this));
	}

	/// @dev Calculate the Domain Separator used to compute ERC712 hash
	function _calculateDomainSeparator(uint256 chainId, address verifyingContract) private view returns (bytes32) {
		return
			keccak256(
				abi.encode(
					keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)"),
					keccak256(bytes(name())),
					chainId,
					verifyingContract
				)
			);
	}
}
