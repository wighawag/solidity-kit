// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC173.sol";
import "../../ERC20/interfaces/IERC20.sol";

interface ReverseRegistrar {
	function setName(string memory name) external returns (bytes32);
}

interface ENS {
	function owner(bytes32 node) external view returns (address);
}

contract Owned is IERC173 {
	bytes32 internal constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
	ENS internal immutable _ens;

	/// @inheritdoc IERC173
	address public owner;

	constructor(address initialOwner, address ens) {
		if (initialOwner != address(0)) {
			owner = initialOwner;
			emit OwnershipTransferred(address(0), initialOwner);
		}
		_ens = ENS(ens);
	}

	/// @notice set the reverse-record name for this contract
	/// @param name ENS name to set
	function setENSName(string memory name) external {
		if (msg.sender != owner) {
			revert IERC173.NotAuthorized();
		}
		ReverseRegistrar reverseRegistrar = ReverseRegistrar(_ens.owner(ADDR_REVERSE_NODE));
		reverseRegistrar.setName(name);
	}

	/// @inheritdoc IERC173
	function transferOwnership(address newOwner) external {
		address oldOwner = owner;
		if (msg.sender != oldOwner) {
			revert NotAuthorized();
		}
		owner = newOwner;
		emit OwnershipTransferred(oldOwner, newOwner);
	}

	/// @notice withdraw the total balance of a particular ERC20 token owned by this contract.
	/// @param token ERC20 contract address to withdraw
	/// @param to address that will receive the tokens
	function withdrawERC20(IERC20 token, address to) external {
		if (msg.sender != owner) {
			revert NotAuthorized();
		}
		token.transfer(to, token.balanceOf(address(this)));
	}
}
