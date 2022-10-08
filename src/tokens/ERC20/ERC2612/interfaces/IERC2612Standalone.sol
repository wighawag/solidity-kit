// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../../../users/ERC712/interfaces/IERC5267.sol";

interface IERC2612Standalone is IERC5267 {
	function permit(
		address owner,
		address spender,
		uint256 value,
		uint256 deadline,
		uint8 v,
		bytes32 r,
		bytes32 s
	) external;

	function nonces(address owner) external view returns (uint256);

	function DOMAIN_SEPARATOR() external view returns (bytes32);
}
