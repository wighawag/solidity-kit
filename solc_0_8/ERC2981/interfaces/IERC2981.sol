// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../ERC165/interfaces/IERC165.sol";

interface IERC2981 is IERC165 {
    /// @notice Called with the sale price to determine how much royalty is owed and to whom.
    /// @param tokenID the token queried for royalty information.
    /// @param salePrice - the sale price of the token specified by `tokenID`.
    /// @return receiver - address of who should be sent the royalty payment.
    /// @return royaltyAmount - the royalty payment amount for salePrice.
    function royaltyInfo(
        uint256 tokenID,
        uint256 salePrice
    ) external view returns (address receiver, uint256 royaltyAmount);
}
