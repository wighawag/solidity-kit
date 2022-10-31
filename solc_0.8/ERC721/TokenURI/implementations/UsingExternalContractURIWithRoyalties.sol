// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IContractURI.sol";
import "../../../ERC2981/implementations/UsingGlobalRoyalties.sol";
import "../../../utils/Guardian/libraries/Guarded.sol";

contract UsingExternalContractURIWithRoyalties is UsingGlobalRoyalties {
	event ContractURIAddressSet(IContractURI newContractURIAddress);
	event ContractURIAdminSet(address newContractURIAdmin);

	/// @notice the contract that return the contract metadata
	IContractURI public contractURIAddress;

	/// @notice contractURIAdmin can update the ContractURI contract, this is intended to be relinquished.
	address public contractURIAdmin;

	/// @param initialContractURIAdmin admin able to update the contractURI contract.
	/// @param initialContractURIAddress initial contractURI contract that generate the metadata including the wav file.
	/// @param initialRoyaltyReceiver receiver of royalties
	/// @param imitialRoyaltyPer10Thousands amount of royalty in 10,000 basis point
	/// @param initialRoyaltyAdmin admin able to update the royalty receiver and rates
	constructor(
		address initialContractURIAdmin,
		IContractURI initialContractURIAddress,
		address initialRoyaltyReceiver,
		uint96 imitialRoyaltyPer10Thousands,
		address initialRoyaltyAdmin
	) UsingGlobalRoyalties(initialRoyaltyReceiver, imitialRoyaltyPer10Thousands, initialRoyaltyAdmin) {
		if (address(initialContractURIAddress) != address(0)) {
			contractURIAddress = initialContractURIAddress;
			emit ContractURIAddressSet(initialContractURIAddress);
		}

		if (initialContractURIAdmin != address(0)) {
			contractURIAdmin = initialContractURIAdmin;
			emit ContractURIAdminSet(initialContractURIAdmin);
		}
	}

	/// @notice set the new contractURIAdmin that can change the contractURI
	/// Can only be called by the current contractURI admin.
	function setContractURIAdmin(address newContractURIAdmin) external {
		if (msg.sender != contractURIAdmin && !Guarded.isGuardian(msg.sender, newContractURIAdmin)) {
			revert NotAuthorized();
		}
		if (contractURIAdmin != newContractURIAdmin) {
			contractURIAdmin = newContractURIAdmin;
			emit ContractURIAdminSet(newContractURIAdmin);
		}
	}

	/// @notice Returns the Uniform Resource Identifier (URI) for the token collection.
	function contractURI() external view returns (string memory) {
		return contractURIAddress.contractURI(_royalty.receiver, _royalty.per10Thousands);
	}

	/// @notice set a new contractURI contract, that generate the metadata including the wav file, Can only be set by the `contractURIAdmin`.
	/// @param newContractURIAddress The address of the new contractURI contract.
	function setContractURI(IContractURI newContractURIAddress) external {
		if (msg.sender != contractURIAdmin) {
			revert NotAuthorized();
		}
		if (contractURIAddress != newContractURIAddress) {
			contractURIAddress = newContractURIAddress;
			emit ContractURIAddressSet(newContractURIAddress);
		}
	}
}
