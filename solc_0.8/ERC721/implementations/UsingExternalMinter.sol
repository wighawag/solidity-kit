// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../utils/Guardian/libraries/Guarded.sol";

contract UsingExternalMinter {
	event MinterAdminSet(address newMinterAdmin);
	event MinterSet(address newMinter);

	/// @notice minterAdmin can update the minter. At the time being there is 576 Bleeps but there is space for extra instrument and the upper limit is 1024.
	/// could be given to the DAO later so instrument can be added, the sale of these new bleeps could benenfit the DAO too and add new members.
	address public minterAdmin;

	/// @notice address allowed to mint, allow the sale contract to be separated from the token contract that can focus on the core logic
	/// Once all 1024 potential bleeps (there could be less, at minimum there are 576 bleeps) are minted, no minter can mint anymore
	address public minter;

	constructor(address initialMinterAdmin) {
		if (initialMinterAdmin != address(0)) {
			minterAdmin = initialMinterAdmin;
			emit MinterAdminSet(initialMinterAdmin);
		}
	}

	/**
	 * @notice set the new minterAdmin that can set the minter for Bleeps
	 * Can only be called by the current minter admin.
	 */
	function setMinterAdmin(address newMinterAdmin) external {
		require(msg.sender == minterAdmin || Guarded.isGuardian(msg.sender, newMinterAdmin), "NOT_AUTHORIZED");
		if (newMinterAdmin != minterAdmin) {
			minterAdmin = newMinterAdmin;
			emit MinterAdminSet(newMinterAdmin);
		}
	}

	/**
	 * @notice set the new minter that can mint
	 * Can only be called by the minter admin.
	 */
	function setMinter(address newMinter) external {
		require(msg.sender == minterAdmin, "NOT_AUTHORIZED");
		if (minter != newMinter) {
			minter = newMinter;
			emit MinterSet(newMinter);
		}
	}
}
