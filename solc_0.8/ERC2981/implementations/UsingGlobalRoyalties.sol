// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC2981.sol";
import "../../ERC165/implementations/UsingERC165Internal.sol";
import "../../utils/Guardian/libraries/Guarded.sol";

contract UsingGlobalRoyalties is IERC2981, UsingERC165Internal {
	event RoyaltySet(address receiver, uint256 royaltyPer10Thousands);
	event RoyaltyAdminSet(address newRoyaltyAdmin);

	struct Royalty {
		address receiver;
		uint96 per10Thousands;
	}

	Royalty internal _royalty;

	/// @notice address allowed to set royalty parameters
	address public royaltyAdmin;

	/// @param initialRoyaltyReceiver receiver of royalties
	/// @param imitialRoyaltyPer10Thousands amount of royalty in 10,000 basis point
	/// @param initialRoyaltyAdmin admin able to update the royalty receiver and rates
	constructor(
		address initialRoyaltyReceiver,
		uint96 imitialRoyaltyPer10Thousands,
		address initialRoyaltyAdmin
	) {
		if (initialRoyaltyAdmin != address(0)) {
			royaltyAdmin = initialRoyaltyAdmin;
			emit RoyaltyAdminSet(initialRoyaltyAdmin);
		}

		_royalty.receiver = initialRoyaltyReceiver;
		_royalty.per10Thousands = imitialRoyaltyPer10Thousands;
		emit RoyaltySet(initialRoyaltyReceiver, imitialRoyaltyPer10Thousands);
	}

	/// @notice Called with the sale price to determine how much royalty is owed and to whom.
	/// @param //id - the token queried for royalty information.
	/// @param salePrice - the sale price of the token specified by id.
	/// @return receiver - address of who should be sent the royalty payment.
	/// @return royaltyAmount - the royalty payment amount for salePrice.
	function royaltyInfo(
		uint256, /*id*/
		uint256 salePrice
	) external view returns (address receiver, uint256 royaltyAmount) {
		receiver = _royalty.receiver;
		royaltyAmount = (salePrice * uint256(_royalty.per10Thousands)) / 10000;
	}

	/// @notice set a new royalty receiver and rate, Can only be set by the `royaltyAdmin`.
	/// @param newReceiver the address that should receive the royalty proceeds.
	/// @param royaltyPer10Thousands the share of the salePrice (in 1/10000) given to the receiver.
	function setRoyaltyParameters(address newReceiver, uint96 royaltyPer10Thousands) external {
		require(msg.sender == royaltyAdmin, "NOT_AUTHORIZED");
		require(royaltyPer10Thousands <= 50, "ROYALTY_TOO_HIGH");
		if (_royalty.receiver != newReceiver || _royalty.per10Thousands != royaltyPer10Thousands) {
			_royalty.receiver = newReceiver;
			_royalty.per10Thousands = royaltyPer10Thousands;
			emit RoyaltySet(newReceiver, royaltyPer10Thousands);
		}
	}

	/**
	 * @notice set the new royaltyAdmin that can change the royalties
	 * Can only be called by the current royalty admin.
	 */
	function setRoyaltyAdmin(address newRoyaltyAdmin) external {
		require(msg.sender == royaltyAdmin || Guarded.isGuardian(msg.sender, newRoyaltyAdmin), "NOT_AUTHORIZED");
		if (royaltyAdmin != newRoyaltyAdmin) {
			royaltyAdmin = newRoyaltyAdmin;
			emit RoyaltyAdminSet(newRoyaltyAdmin);
		}
	}

	/// @notice Check if the contract supports an interface.
	/// @param id The id of the interface.
	/// @return Whether the interface is supported.
	function supportsInterface(bytes4 id) public view virtual override(IERC165, UsingERC165Internal) returns (bool) {
		return super.supportsInterface(id) || id == 0x2a55205a; /// 0x2a55205a is ERC2981 (royalty standard)
	}
}
