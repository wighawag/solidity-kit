// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC721Enumerable.sol";
import "./BasicERC721.sol";

contract EnumerableERC721 is IERC721Enumerable, BasicERC721 {
    error ERC721OutOfBoundsIndex(address owner, uint256 index);

    mapping(address owner => mapping(uint256 index => uint256)) private _ownedTokens;
    mapping(uint256 tokenId => uint256) private _ownedTokensIndex;

    uint256[] private _allTokens;
    mapping(uint256 tokenId => uint256) private _allTokensIndex;

    // ------------------------------------------------------------------------
    // IERC721Enumerable
    // ------------------------------------------------------------------------
    /// @inheritdoc IERC721Enumerable
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    /// @inheritdoc IERC721Enumerable
    function tokenByIndex(uint256 index) external view returns (uint256) {
        if (index >= totalSupply()) {
            revert ERC721OutOfBoundsIndex(address(0), index);
        }
        return _allTokens[index];
    }

    /// @inheritdoc IERC721Enumerable
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        if (index >= balanceOf(owner)) {
            revert ERC721OutOfBoundsIndex(owner, index);
        }
        return _ownedTokens[owner][index];
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public view override(IERC165, BasicERC721) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // EXTRA FUNCTIONALITY
    // ------------------------------------------------------------------------
    function tokensOfOwner(address owner, uint256 index, uint256 limit) external view returns (uint256[] memory) {
        uint256 total = balanceOf(owner);
        if (index >= total) {
            return new uint256[](0);
        }
        uint256 max = total - index;
        uint256 actualLimit = limit > max ? max : limit;

        uint256[] memory list = new uint256[](actualLimit);

        for (uint256 i = 0; i < actualLimit; i++) {
            list[i] = _ownedTokens[owner][index + i];
        }

        return list;
    }
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // OVERRIDES
    // ------------------------------------------------------------------------

    function _burn(uint256 tokenID) internal override {
        address owner = _ownerOf(tokenID);
        super._burn(tokenID);
        _removeTokenFromOwnerEnumeration(owner, tokenID);
        _removeTokenFromAllTokensEnumeration(tokenID);
    }

    function _transferFrom(address from, address to, uint256 tokenID, bool registered) internal override {
        super._transferFrom(from, to, tokenID, registered);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenID);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenID);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenID);
        } else if (from != to) {
            _addTokenToOwnerEnumeration(to, tokenID);
        }
    }

    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // UTILITIES (from openzeppelin)
    // ------------------------------------------------------------------------

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = balanceOf(to) - 1;
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = balanceOf(from);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        mapping(uint256 index => uint256) storage _ownedTokensByOwner = _ownedTokens[from];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokensByOwner[lastTokenIndex];

            _ownedTokensByOwner[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokensByOwner[lastTokenIndex];
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}
