// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Madeira {
    enum Status {
        Disponivel,
        Iniciada,
        Transito,
        Entregue
    }

    struct Lote {
        int Id;
    }    

    struct Remessa {
        int Id;
    }

    Lote[] public _lotes;

    constructor() {}

    modifier somenteLoteValido() {
        _;
    }

    function adicionarLote() public {
        
    }

    function informacaoLote() public {
        
    }

    function totalLotes() public {
        
    }

    function registrarRemessa() public {
        
    }

    function informacaoRemessa() public {
        
    }    
}