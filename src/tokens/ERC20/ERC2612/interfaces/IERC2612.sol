// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../interfaces/IERC20.sol";
import "./IERC2612Standalone.sol";

interface IERC2612 is IERC2612Standalone, IERC20 {}
