// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingPermit.sol";
import "../../../../users/ERC712/implementations/UsingERC712WithDynamicChainId.sol";

abstract contract UsingPermitWithDynamicChainId is UsingPermit, UsingERC712WithDynamicChainId {
	function DOMAIN_SEPARATOR() public view virtual override returns (bytes32) {
		return _currentDomainSeparator();
	}
}
