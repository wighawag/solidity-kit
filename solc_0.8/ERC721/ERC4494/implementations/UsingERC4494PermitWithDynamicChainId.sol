// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingERC4494Permit.sol";

abstract contract UsingERC4494PermitWithDynamicChainId is UsingERC4494Permit, UsingERC712WithDynamicChainId {
	function DOMAIN_SEPARATOR() public view virtual override returns (bytes32) {
		return _currentDomainSeparator();
	}
}
