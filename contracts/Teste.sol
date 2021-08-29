// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Teste {
    struct Estrutura {
        uint Numero;
    }
    mapping(address => Estrutura[]) _estruturas;

    function adicionar
    (
        uint numero
    )
        public
        returns (uint )
    {
        Estrutura memory estrutura;
        estrutura.Numero = numero;
        _estruturas[msg.sender].push(estrutura);

        return _estruturas[msg.sender][_estruturas[msg.sender].length -1].Numero;
    }

    function alterar
    (
        uint index,
        uint numero
    )
        public
        returns(uint)
    {
        Estrutura memory estrutura;
        estrutura.Numero = numero;

        delete _estruturas[msg.sender][index];
        _estruturas[msg.sender][index] = estrutura;

        return _estruturas[msg.sender][index].Numero;
    }

    function ler
    (
        uint index
    )
        public
        view
        returns
        (
            uint numero
        )
    {
        Estrutura memory estrutura = _estruturas[msg.sender][index];
        return (estrutura.Numero);
    }

    function listar()
        public
        view
        returns
        (
            uint
        )
    {
        return _estruturas[msg.sender].length;
    }    
}