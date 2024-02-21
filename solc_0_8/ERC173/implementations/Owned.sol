// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC173.sol";
import "../interfaces/IWithdrawable.sol";
import "../internal/UsingInternalOwner.sol";
import "../../ERC20/interfaces/IERC20.sol";
import "../../utils/UsingGenericErrors.sol";

contract Owned is IERC173, IWithdrawable, UsingInternalOwner {
    constructor(address initialOwner) {
        if (initialOwner != address(0)) {
            _setOwner(address(0), initialOwner);
        }
    }

    /// @inheritdoc IERC173
    function owner() external view returns (address) {
        return _getOwner();
    }

    /// @inheritdoc IERC173
    function transferOwnership(address newOwner) external {
        address previousOwner = _getOwner();
        if (msg.sender != previousOwner) {
            revert UsingGenericErrors.NotAuthorized();
        }
        _setOwner(previousOwner, newOwner);
    }

    /// @inheritdoc IWithdrawable
    function withdrawERC20(IERC20 token, address to) external {
        if (msg.sender != _getOwner()) {
            revert UsingGenericErrors.NotAuthorized();
        }
        token.transfer(to, token.balanceOf(address(this)));
    }

    // ------------------------------------------------------------------------------------------------------------------
    // INTERNALS
    // ------------------------------------------------------------------------------------------------------------------

    function _getOwner() internal view override returns (address ownerAddress) {
        // solhint-disable-next-line security/no-inline-assembly
        assembly {
            ownerAddress := sload(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103)
        }
    }

    function _setOwner(address previousOwner, address newOwner) internal {
        // solhint-disable-next-line security/no-inline-assembly
        assembly {
            sstore(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103, newOwner)
        }
        emit OwnershipTransferred(previousOwner, newOwner);
    }

    // ------------------------------------------------------------------------------------------------------------------
    // MODIFIERS
    // ------------------------------------------------------------------------------------------------------------------

    modifier onlyOwner() {
        if (msg.sender != _getOwner()) {
            revert UsingGenericErrors.NotAuthorized();
        }
        _;
    }
}
