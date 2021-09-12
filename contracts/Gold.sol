// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Gold is ERC20 {
    constructor(address deployer, uint256 initialSupply) ERC20("Gold", "GLD") {
        _mint(deployer, initialSupply * 10 ** 18);
    }
}