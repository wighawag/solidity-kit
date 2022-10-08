// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/ITokenURI.sol";
import "../../../utils/Guardian/libraries/Guarded.sol";

contract UsingExternalTokenURI {
	event TokenURIContractSet(ITokenURI newTokenURIContract);
	event TokenURIAdminSet(address newTokenURIAdmin);

	/// @notice the contract that actually generate the sound (and all metadata via the a data: uri via tokenURI call).
	ITokenURI public tokenURIContract;

	/// @notice tokenURIAdmin can update the tokenURI contract, this is intended to be relinquished once the tokenURI has been heavily tested in the wild and that no modification are needed.
	address public tokenURIAdmin;

	/// @param initialTokenURIAdmin admin able to update the tokenURI contract.
	/// @param initialTokenURIContract initial tokenURI contract that generate the metadata including the wav file.
	constructor(address initialTokenURIAdmin, ITokenURI initialTokenURIContract) {
		if (address(initialTokenURIContract) != address(0)) {
			tokenURIContract = initialTokenURIContract;
			emit TokenURIContractSet(initialTokenURIContract);
		}
		if (initialTokenURIAdmin != address(0)) {
			tokenURIAdmin = initialTokenURIAdmin;
			emit TokenURIAdminSet(initialTokenURIAdmin);
		}
	}

	/// @notice set the new tokenURIAdmin that can change the tokenURI
	/// Can only be called by the current tokenURI admin.
	function setTokenURIAdmin(address newTokenURIAdmin) external {
		require(msg.sender == tokenURIAdmin || Guarded.isGuardian(msg.sender, newTokenURIAdmin), "NOT_AUTHORIZED");
		if (tokenURIAdmin != newTokenURIAdmin) {
			tokenURIAdmin = newTokenURIAdmin;
			emit TokenURIAdminSet(newTokenURIAdmin);
		}
	}

	/// @notice Returns the Uniform Resource Identifier (URI) for token `id`.
	function tokenURI(uint256 id) external view returns (string memory) {
		return tokenURIContract.tokenURI(id);
	}

	/// @notice set a new tokenURI contract, that generate the metadata including the wav file, Can only be set by the `tokenURIAdmin`.
	/// @param newTokenURIContract The address of the new tokenURI contract.
	function setTokenURIContract(ITokenURI newTokenURIContract) external {
		require(msg.sender == tokenURIAdmin, "NOT_AUTHORIZED");
		if (tokenURIContract != newTokenURIContract) {
			tokenURIContract = newTokenURIContract;
			emit TokenURIContractSet(newTokenURIContract);
		}
	}
}
