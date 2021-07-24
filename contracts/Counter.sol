// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint256 public value;

    event Increased(uint256 newValue);

    function increase() public {
        value = value + 1;
        emit Increased(value);
    }
}