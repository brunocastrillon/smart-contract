// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Pasta {
    struct Arquivo {
        string Hash;
        string Nome;
        string Tipo;
        uint DataEnvio;
    }    

    mapping(address => Arquivo[]) _arquivos;

    event adicionado(string hashh, address remetente);

    constructor() {

	}    

    function adicionar(
        string memory hashh,
        string memory nome,
        string memory tipo,
        uint data
    )
        public
    {
        _arquivos[msg.sender].push(Arquivo({
            Hash: hashh,
            Nome: nome,
            Tipo: tipo,
            DataEnvio: data
        }));

        emit adicionado(hashh, msg.sender);
    }

    function listar()
        public
        view
        returns (uint)
    {
        return _arquivos[msg.sender].length;
    }

    function ler(uint index)
        public
        view
        returns
        (
            string memory hashh,
            string memory nome,
            string memory tipo,
            uint data
        )
    {
        Arquivo memory arquivo = _arquivos[msg.sender][index];
        return (
            arquivo.Hash,
            arquivo.Nome,
            arquivo.Tipo,
            arquivo.DataEnvio
        );
    }
}