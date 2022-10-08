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

	///@notice the address of the current owner, that is able to set ENS names and withdraw ERC20 owned by the contract.
	address public owner;

	constructor(address initialOwner, address ens) {
		if (initialOwner != address(0)) {
			owner = initialOwner;
			emit OwnershipTransferred(address(0), initialOwner);
		}
		_ens = ENS(ens);
	}

	function setENSName(string memory name) external {
		require(msg.sender == owner, "NOT_AUTHORIZED");
		ReverseRegistrar reverseRegistrar = ReverseRegistrar(_ens.owner(ADDR_REVERSE_NODE));
		reverseRegistrar.setName(name);
	}

	/**
	 * @notice Transfers ownership of the contract to a new account (`newOwner`).
	 * Can only be called by the current owner.
	 */
	function transferOwnership(address newOwner) external {
		address oldOwner = owner;
		require(msg.sender == oldOwner);
		owner = newOwner;
		emit OwnershipTransferred(oldOwner, newOwner);
	}

	function withdrawERC20(IERC20 token, address to) external {
		require(msg.sender == owner, "NOT_AUTHORIZED");
		token.transfer(to, token.balanceOf(address(this)));
	}
}
