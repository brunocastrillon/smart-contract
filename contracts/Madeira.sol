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
        string Descricao;
        string NomeFazenda; // TODO: esse campodeverá ser trocado pelo address da fazenda
        uint Quantidade;
        uint DataHora;
        Status Situacao;
    }    

    struct Remessa {
        string Destino;
        string Descricao;
        uint DataHora;
        Status Situacao;
    }

    Lote[] public _lotes;

    event LoteAdicionado();
    event RemessaRegistrada();

    constructor() {}

    modifier somenteLoteValidoParaCadastro() {
        _;
    }    

    modifier somenteLoteValidoParaPesquisa(uint id) {
        require(id >= 0 && id < _lotes.length, "");
        _;
    }

    modifier somenteRemessaValida() {
        _;
    }    

    function adicionarLote
    (
        string memory descricao,
        string memory nomeFazenda,
        uint quantidade
    )
        public
        somenteLoteValidoParaCadastro()
        returns(uint)
    {
        uint dataHora = block.timestamp;
        Lote memory novoLote = Lote(descricao, nomeFazenda, quantidade, dataHora, Status.Disponivel);
        _lotes.push(novoLote);
        emit LoteAdicionado();
        return _lotes.length - 1;
    }

    function informacaoLote
    (
        uint id
    )
        public
        view
        somenteLoteValidoParaPesquisa(id)
        returns(string memory descricao, string memory nomeFazenda, uint quantidade, Status situacao)
    {
        Lote memory lote = _lotes[id];
        return (lote.Descricao, lote.NomeFazenda, lote.Quantidade, lote.Situacao);
    }

    function totalLotes() public view returns(uint) {
        return _lotes.length;
    }

    function registrarRemessa() public {
        
    }

    function informacaoRemessa() public {
        
    }    
}