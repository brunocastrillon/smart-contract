// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Saudacao {
    string private _saudacao;
    event SaudacaoEmitida(string saudacao
                          //,uint256 saldo
                          );

    constructor(string memory saudacao) {
        _saudacao = saudacao;
        emit SaudacaoEmitida(saudacao
        //, 0
        );
    }

    function saudar() public view returns (string memory) {
        return _saudacao;
    }

    function EmitirSaudacao
    (
        string memory saudacao
    )
        public
        //payable
        returns (string memory
        //, uint256
        )
    {
        //require(msg.value >= 1000);
        _saudacao = saudacao;
        emit SaudacaoEmitida(saudacao
        //, address(this).balance
        );
        return (saudacao
        //, address(this).balance
        );
    }    
}