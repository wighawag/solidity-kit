// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UsingPermit.sol";
import "../../../ERC712/implementations/UsingERC712WithFixedDomain.sol";

abstract contract UsingPermitWithFixedDomain is UsingPermit, UsingERC712WithFixedDomain {
	constructor(string memory version) UsingERC712WithFixedDomain(version) {}

	function DOMAIN_SEPARATOR() public view virtual override returns (bytes32) {
		return _DOMAIN_SEPARATOR;
	}
}
