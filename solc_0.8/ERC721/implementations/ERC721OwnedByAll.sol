// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC721Receiver.sol";
import "./BasicERC721.sol";

import "../../openzeppelin/contracts/utils/Address.sol";

abstract contract ERC721OwnedByAll is BasicERC721 {
	/// @notice Get the number of tokens owned by an address.
	/// @param owner The address to look for.
	/// @return balance The number of tokens owned by the address.
	function balanceOf(address owner) public view override returns (uint256 balance) {
		require(owner != address(0), "ZERO_ADDRESS_OWNER");
		balance = _balances[owner];
		(, uint256 blockNumber) = _ownerAndBlockNumberOf(uint256(uint160(owner)));

		if (blockNumber == 0) {
			// owned token was never registered
			unchecked {
				balance++;
			}
		}
	}

	/// @notice Get the list of owner of a token and the blockNumber of its last transfer, useful to voting mechanism.
	/// @param ids The list of token ids to check.
	/// @return ownersData The list of (owner, lastTransferBlockNumber) for each ids given as input.
	function ownerAndLastTransferBlockNumberList(uint256[] calldata ids)
		external
		view
		override
		returns (OwnerData[] memory ownersData)
	{
		ownersData = new OwnerData[](ids.length);
		for (uint256 i = 0; i < ids.length; i++) {
			uint256 id = ids[i];
			uint256 data = _owners[id];
			address owner = address(uint160(data));
			if (owner == address(0) && id < 2**160) {
				owner = address(uint160(id));
			}
			ownersData[i].owner = owner;
			ownersData[i].lastTransferBlockNumber = (data >> 160) & 0xFFFFFFFFFFFFFFFFFFFFFF;
		}
	}

	/// @notice Count NFTs tracked by this contract
	/// @return A count of valid NFTs tracked by this contract, where each one of
	///  them has an assigned and queryable owner not equal to the zero address
	function totalSupply() external pure returns (uint256) {
		return 2**160 - 1; // do not count token with id zero whose owner would otherwise be the zero address
	}

	// ------------------------------------------------------------------------------------------------------------------
	// INTERNALS
	// ------------------------------------------------------------------------------------------------------------------

	/// @dev See ownerOf
	function _ownerOf(uint256 id) internal view override returns (address owner) {
		owner = address(uint160(_owners[id]));
		if (owner == address(0) && id < 2**160) {
			owner = address(uint160(id));
		}
	}

	/// @dev See _ownerAndOperatorEnabledOf
	function _ownerAndOperatorEnabledOf(uint256 id)
		internal
		view
		override
		returns (address owner, bool operatorEnabled)
	{
		uint256 data = _owners[id];
		owner = address(uint160(data));
		if (owner == address(0) && id < 2**160) {
			owner = address(uint160(id));
		}
		operatorEnabled = (data & OPERATOR_FLAG) == OPERATOR_FLAG;
	}

	/// @dev See _ownerAndBlockNumberOf
	function _ownerAndBlockNumberOf(uint256 id) internal view override returns (address owner, uint256 blockNumber) {
		uint256 data = _owners[id];
		owner = address(uint160(data));
		if (owner == address(0) && id < 2**160) {
			owner = address(uint160(id));
		}
		blockNumber = (data >> 160) & 0xFFFFFFFFFFFFFFFFFFFFFF;
	}

	/// @dev See _ownerBlockNumberAndOperatorEnabledOf
	function _ownerBlockNumberAndOperatorEnabledOf(uint256 id)
		internal
		view
		override
		returns (
			address owner,
			uint256 blockNumber,
			bool operatorEnabled
		)
	{
		uint256 data = _owners[id];
		owner = address(uint160(data));
		if (owner == address(0) && id < 2**160) {
			owner = address(uint160(id));
		}
		operatorEnabled = (data & OPERATOR_FLAG) == OPERATOR_FLAG;
		blockNumber = (data >> 160) & 0xFFFFFFFFFFFFFFFFFFFFFF;
	}
}
