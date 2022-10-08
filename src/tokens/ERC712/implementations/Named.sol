// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Named {
	function name() public view virtual returns (string memory);
}
