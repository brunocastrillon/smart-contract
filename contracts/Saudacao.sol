// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Saudacao {
    string private _saudacao;

    constructor(string memory saudacao) {
        _saudacao = saudacao;
    }

    function saudar() public view returns (string memory) {
        return _saudacao;
    }
}