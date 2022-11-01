// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC721Receiver.sol";
import "../interfaces/IERC721.sol";
import "../interfaces/IERC721WithBlocknumber.sol";
import "./ImplementingERC721Internal.sol";

import "../../openzeppelin/contracts/utils/Address.sol";

abstract contract BasicERC721 is IERC721, IERC721WithBlocknumber, ImplementingERC721Internal {
	using Openzeppelin_Address for address;

	bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

	uint256 internal constant OPERATOR_FLAG = 0x8000000000000000000000000000000000000000000000000000000000000000;

	mapping(uint256 => uint256) internal _owners;
	mapping(address => uint256) internal _balances;
	mapping(address => mapping(address => bool)) internal _operatorsForAll;
	mapping(uint256 => address) internal _operators;

	/// @inheritdoc IERC721
	function approve(address operator, uint256 tokenId) external override {
		(address owner, uint256 blockNumber) = _ownerAndBlockNumberOf(tokenId);
		if (owner == address(0)) {
			revert NonExistentToken(tokenId);
		}
		if (msg.sender != owner && !isApprovedForAll(owner, msg.sender)) {
			revert NotAuthorized();
		}
		_approveFor(owner, blockNumber, operator, tokenId);
	}

	/// @inheritdoc IERC721
	function transferFrom(
		address from,
		address to,
		uint256 tokenId
	) external override {
		(address owner, uint256 blockNumber, bool operatorEnabled) = _ownerBlockNumberAndOperatorEnabledOf(tokenId);
		if (owner == address(0)) {
			revert NonExistentToken(tokenId);
		}
		if (from != owner) {
			revert NotOwner(from, owner);
		}
		if (to == address(0) || to == address(this)) {
			revert InvalidAddress(to);
		}
		if (msg.sender != from) {
			if (!(operatorEnabled && _operators[tokenId] == msg.sender) && !isApprovedForAll(from, msg.sender)) {
				revert NotAuthorized();
			}
		}
		_transferFrom(from, to, tokenId, blockNumber != 0);
	}

	/// @inheritdoc IERC721
	function safeTransferFrom(
		address from,
		address to,
		uint256 tokenId
	) external override {
		safeTransferFrom(from, to, tokenId, "");
	}

	/// @inheritdoc IERC721
	function setApprovalForAll(address operator, bool approved) external override {
		_setApprovalForAll(msg.sender, operator, approved);
	}

	/// @inheritdoc IERC721
	function balanceOf(address owner) public view virtual override returns (uint256 balance) {
		if (owner == address(0)) {
			revert InvalidOwner(owner);
		}
		balance = _balances[owner];
	}

	/// @inheritdoc IERC721
	function ownerOf(uint256 tokenId) external view override returns (address owner) {
		owner = _ownerOf(tokenId);
		if (owner == address(0)) {
			revert NonExistentToken(tokenId);
		}
	}

	/// @inheritdoc IERC721
	function getApproved(uint256 tokenId) external view override returns (address operator) {
		(address owner, bool operatorEnabled) = _ownerAndOperatorEnabledOf(tokenId);
		if (owner == address(0)) {
			revert NonExistentToken(tokenId);
		}
		if (operatorEnabled) {
			return _operators[tokenId];
		} else {
			return address(0);
		}
	}

	/// @inheritdoc IERC721
	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool isOperator) {
		return _operatorsForAll[owner][operator];
	}

	/// @inheritdoc IERC721
	function safeTransferFrom(
		address from,
		address to,
		uint256 tokenId,
		bytes memory data
	) public override {
		(address owner, uint256 blockNumber, bool operatorEnabled) = _ownerBlockNumberAndOperatorEnabledOf(tokenId);
		if (owner == address(0)) {
			revert NonExistentToken(tokenId);
		}
		if (owner != from) {
			revert NotOwner(from, owner);
		}

		if (to == address(0) || to == address(this)) {
			revert InvalidAddress(to);
		}

		if (msg.sender != from) {
			if (!(operatorEnabled && _operators[tokenId] == msg.sender) && !isApprovedForAll(from, msg.sender)) {
				revert NotAuthorized();
			}
		}
		_safeTransferFrom(from, to, tokenId, blockNumber != 0, data);
	}

	/// @inheritdoc IERC165
	function supportsInterface(bytes4 id) public view virtual override returns (bool) {
		/// 0x01ffc9a7 is ERC165.
		/// 0x80ac58cd is ERC721
		/// 0x5b5e139f is for ERC721 metadata
		return id == 0x01ffc9a7 || id == 0x80ac58cd || id == 0x5b5e139f;
	}

	/// @inheritdoc IERC721WithBlocknumber
	function ownerAndLastTransferBlockNumberOf(uint256 id)
		external
		view
		override
		returns (address owner, uint256 blockNumber)
	{
		return _ownerAndBlockNumberOf(id);
	}

	/// @inheritdoc IERC721WithBlocknumber
	function ownerAndLastTransferBlockNumberList(uint256[] calldata ids)
		external
		view
		virtual
		returns (OwnerData[] memory ownersData)
	{
		ownersData = new OwnerData[](ids.length);
		for (uint256 i = 0; i < ids.length; i++) {
			uint256 data = _owners[ids[i]];
			ownersData[i].owner = address(uint160(data));
			ownersData[i].lastTransferBlockNumber = (data >> 160) & 0xFFFFFFFFFFFFFFFFFFFFFF;
		}
	}

	// ------------------------------------------------------------------------------------------------------------------
	// INTERNALS
	// ------------------------------------------------------------------------------------------------------------------

	function _safeMint(address to, uint256 id) internal {
		_safeTransferFrom(address(0), to, id, false, "");
	}

	function _safeTransferFrom(
		address from,
		address to,
		uint256 id,
		bool registered,
		bytes memory data
	) internal {
		_transferFrom(from, to, id, registered);
		if (to.isContract()) {
			if (!_checkOnERC721Received(msg.sender, from, to, id, data)) {
				revert TransferRejected();
			}
		}
	}

	function _transferFrom(
		address from,
		address to,
		uint256 id,
		bool registered
	) internal virtual {
		unchecked {
			_balances[to]++;
			if (registered) {
				_balances[from]--;
			}
		}
		_owners[id] = (block.number << 160) | uint256(uint160(to));
		emit Transfer(from, to, id);
	}

	/// @dev See approve.
	function _approveFor(
		address owner,
		uint256 blockNumber,
		address operator,
		uint256 id
	) internal override {
		if (operator == address(0)) {
			_owners[id] = blockNumber != 0 ? (blockNumber << 160) | uint256(uint160(owner)) : 0;
		} else {
			_owners[id] = OPERATOR_FLAG | (blockNumber != 0 ? (blockNumber << 160) | uint256(uint160(owner)) : 0);
			_operators[id] = operator;
		}
		emit Approval(owner, operator, id);
	}

	/// @dev See setApprovalForAll.
	function _setApprovalForAll(
		address sender,
		address operator,
		bool approved
	) internal override {
		_operatorsForAll[sender][operator] = approved;

		emit ApprovalForAll(sender, operator, approved);
	}

	/// @dev Check if receiving contract accepts erc721 transfers.
	/// @param operator The address of the operator.
	/// @param from The from address, may be different from msg.sender.
	/// @param to The adddress we want to transfer to.
	/// @param id The id of the token we would like to transfer.
	/// @param data Any additional data to send with the transfer.
	/// @return Whether the expected value of 0x150b7a02 is returned.
	function _checkOnERC721Received(
		address operator,
		address from,
		address to,
		uint256 id,
		bytes memory data
	) internal returns (bool) {
		bytes4 retval = IERC721Receiver(to).onERC721Received(operator, from, id, data);
		return (retval == ERC721_RECEIVED);
	}

	/// @dev See ownerOf
	function _ownerOf(uint256 id) internal view virtual returns (address owner) {
		return address(uint160(_owners[id]));
	}

	/// @dev Get the owner and operatorEnabled status of a token.
	/// @param id The token to query.
	/// @return owner The owner of the token.
	/// @return operatorEnabled Whether or not operators are enabled for this token.
	function _ownerAndOperatorEnabledOf(uint256 id)
		internal
		view
		virtual
		returns (address owner, bool operatorEnabled)
	{
		uint256 data = _owners[id];
		owner = address(uint160(data));
		operatorEnabled = (data & OPERATOR_FLAG) == OPERATOR_FLAG;
	}

	/// @dev Get the owner and the last transfer's blockNumber of a token.
	/// @param id The token to query.
	/// @return owner The owner of the token.
	/// @return blockNumber the blockNumber at which the owner became the owner (last transfer).
	function _ownerAndBlockNumberOf(uint256 id)
		internal
		view
		virtual
		override
		returns (address owner, uint256 blockNumber)
	{
		uint256 data = _owners[id];
		owner = address(uint160(data));
		blockNumber = (data >> 160) & 0xFFFFFFFFFFFFFFFFFFFFFF;
	}

	// @dev Get the owner, the last transfer's blockNumber and operatorEnabled status of a token.
	/// @param id The token to query.
	/// @return owner The owner of the token.
	/// @return blockNumber the blockNumber at which the owner became the owner (last transfer).
	/// @return operatorEnabled Whether or not operators are enabled for this token.
	function _ownerBlockNumberAndOperatorEnabledOf(uint256 id)
		internal
		view
		virtual
		returns (
			address owner,
			uint256 blockNumber,
			bool operatorEnabled
		)
	{
		uint256 data = _owners[id];
		owner = address(uint160(data));
		operatorEnabled = (data & OPERATOR_FLAG) == OPERATOR_FLAG;
		blockNumber = (data >> 160) & 0xFFFFFFFFFFFFFFFFFFFFFF;
	}
}
