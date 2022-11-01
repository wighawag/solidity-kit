// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
	event Transfer(address indexed from, address indexed to, uint256 value);

	event Approval(address indexed owner, address indexed spender, uint256 value);

	error InvalidMsgValue(uint256 provided, uint256 expected);
	error InvalidTotalAmount(uint256 provided, uint256 expected);
	error InvalidAddress(address addr);
	error NotAuthorizedAllowance(uint256 currentAllowance, uint256 expected);
	error NotEnoughTokens(uint256 currentBalance, uint256 expected);

	/// @notice Returns the total token supply.
	function totalSupply() external view returns (uint256);

	/// @notice Returns the number of decimals the token uses.
	function decimals() external view returns (uint8);

	/// @notice Returns the symbol of the token.
	function symbol() external view returns (string memory);

	/// @notice Returns the name of the token.
	function name() external view returns (string memory);

	/// @notice Returns the account balance of another account with address `owner`.
	function balanceOf(address owner) external view returns (uint256);

	/// @notice Transfers `amount` of tokens to address `to`.
	function transfer(address to, uint256 amount) external returns (bool);

	/// @notice Returns the amount which `spender` is still allowed to withdraw from `owner`.
	function allowance(address owner, address spender) external view returns (uint256);

	/// @notice Allows `spender` to withdraw from your account multiple times, up to `amount`.
	function approve(address spender, uint256 amount) external returns (bool);

	/// @notice Transfers `amount` tokens from address `from` to address `to`.
	function transferFrom(
		address from,
		address to,
		uint256 amount
	) external returns (bool);
}
