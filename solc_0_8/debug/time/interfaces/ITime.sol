// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./UsingTimeEvents.sol";

interface ITime is UsingTimeEvents {
    function timestamp() external view returns (uint256);
}

interface ITimeSetter is UsingTimeEvents {
    function increaseTime(uint256 delta) external;
}
