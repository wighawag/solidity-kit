// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract ImplementingExternalDomainSeparator {
	function DOMAIN_SEPARATOR() public view virtual returns (bytes32);
}
