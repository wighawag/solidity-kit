// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC173.sol";
import "../interfaces/IWithdrawable.sol";
import "../internal/UsingInternalOwner.sol";
import "../../ERC20/interfaces/IERC20.sol";

contract Owned is IERC173, IWithdrawable, UsingInternalOwner {
	address internal _owner;

	constructor(address initialOwner) {
		if (initialOwner != address(0)) {
			_owner = initialOwner;
			emit OwnershipTransferred(address(0), initialOwner);
		}
	}

	/// @inheritdoc IERC173
	function owner() external view returns (address) {
		return _owner;
	}

	/// @inheritdoc IERC173
	function transferOwnership(address newOwner) external {
		address oldOwner = _owner;
		if (msg.sender != oldOwner) {
			revert NotAuthorized();
		}
		_owner = newOwner;
		emit OwnershipTransferred(oldOwner, newOwner);
	}

	/// @inheritdoc IWithdrawable
	function withdrawERC20(IERC20 token, address to) external {
		if (msg.sender != _owner) {
			revert NotAuthorized();
		}
		token.transfer(to, token.balanceOf(address(this)));
	}

	// ------------------------------------------------------------------------------------------------------------------
	// INTERNALS
	// ------------------------------------------------------------------------------------------------------------------

	function _getOwner() internal view override returns (address) {
		return _owner;
	}
}
