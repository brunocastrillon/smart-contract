// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Saudacao {
    string private _saudando;

    constructor(string memory saudacao) {
        _saudando = saudacao;
    }

    function saudar() public view returns (string memory) {
        return _saudando;
    }
}