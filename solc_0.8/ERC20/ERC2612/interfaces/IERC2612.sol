// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC2612 {
	error InvalidAddress(address addr);
	error InvalidSignature();
	error DeadlineOver(uint256 currentTime, uint256 deadline);

	/// @notice allow `spender` to spend `value` amount of token on behalf of `owner`
	/// @param owner owner of the tokens
	/// @param spender address allowed to spend on behalf of the owner.
	/// @param value amount of token allowed to be spent
	/// @param deadline timestamp in seconds after which the permit is not valid.
	/// @param v signature part v
	/// @param r signature part r
	/// @param s signature part s
	function permit(
		address owner,
		address spender,
		uint256 value,
		uint256 deadline,
		uint8 v,
		bytes32 r,
		bytes32 s
	) external;

	/// @notice return the current nonce of the owner
	/// @param owner address queried
	/// @return nonce nonce value
	function nonces(address owner) external view returns (uint256 nonce);

	/// @notice EIP-712 Domain separator hash
	function DOMAIN_SEPARATOR() external view returns (bytes32);
}
