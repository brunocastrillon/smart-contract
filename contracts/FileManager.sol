// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract FileManager {
    uint32 private _Id;
    mapping(uint32 => Informacao) private _Arquivos;

    struct Informacao {
        string Hash;
        string Nome;
        uint Data;
        address Remetente;
    }    

    event Salvo(uint32 id, string hashh, address remetente);

    function adicionar(
        string memory hashh,
        string memory nome,
        uint data
    )
        public
        returns (uint32)
    {
        uint32 id = ++_Id;

        Informacao storage arquivo = _Arquivos[id];

        arquivo.Nome = nome;
        arquivo.Hash = hashh;
        arquivo.Data = data;
        arquivo.Remetente = msg.sender;

        emit Salvo(id, hashh, msg.sender);
        return id;
    }

    function ler(uint32 id)
        public
        view
        returns
        (
            string memory nome,
            string memory hashh,
            uint data
        )
    {
        Informacao memory arquivo = _Arquivos[id];
        return (
            arquivo.Nome,
            arquivo.Hash,
            arquivo.Data
        );
    }
}