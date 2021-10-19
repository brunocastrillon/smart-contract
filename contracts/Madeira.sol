// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Madeira {
    enum SituacaoLote {
        Disponivel,
        Transito,
        Entregue
    }

    enum SituacaoRemessa {
        Iniciada,
        Transito,
        Entregue
    }    

    struct Lote {
        string Descricao;
        string NomeFazenda; //TODO: esse campodeverá ser trocado pelo address da fazenda
        uint Quantidade;
        uint DataHora;
        uint TotalRemessa;
        SituacaoLote Situacao;
        mapping (uint => Remessa) Envio; //TODO: Struct containing a (nested) mapping cannot be constructed.
    }    
    Lote[] public _lotes;
    
    struct Remessa {
        string Destino;
        string Descricao;
        uint DataHora;
        SituacaoRemessa Situacao;
    }

    event LoteAdicionado(string descricao, string nomeFazenda, uint quantidade);
    event RemessaRegistrada(uint idLote, string destino, string descricao, uint dataHora, SituacaoRemessa situacao);

    constructor() {}

    modifier somenteInformacaoValida
    (
        string memory descricao,
        string memory nomeFazenda,
        uint quantidade
    )
    {
        bytes memory descricaoTemp = bytes(descricao);
        bytes memory nomeFazendaTemp = bytes(nomeFazenda);

        bool informacaoValida = descricaoTemp.length == 0 || nomeFazendaTemp.length == 0 || quantidade == 0;
        require(!informacaoValida, 'informacao invalida');
        _;
    }    

    modifier somenteLoteValido(uint id) {
        require(id >= 0 && id < _lotes.length, "lote nao encontrado");
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
        somenteInformacaoValida(descricao, nomeFazenda, quantidade)
        returns(uint)
    {
        //uint dataHora = block.timestamp;
        
        // Lote memory novoLote = Lote(descricao, nomeFazenda, quantidade, dataHora, 0, SituacaoLote.Disponivel);
        // _lotes.push(novoLote);
        
        emit LoteAdicionado(descricao, nomeFazenda, quantidade);
        
        return _lotes.length - 1;
    }

    function obterLote
    (
        uint id
    )
        public
        view
        somenteLoteValido(id)
        returns(string memory descricao, string memory nomeFazenda, uint quantidade, SituacaoLote situacao)
    {
        Lote storage lote = _lotes[id];
        return (lote.Descricao, lote.NomeFazenda, lote.Quantidade, lote.Situacao);
    }

    function contabilizarLotes() public view returns(uint) {
        return _lotes.length;
    }

    function registrarRemessa
    (
        uint idLote,
        string memory destino,
        string memory descricao,
        SituacaoRemessa situacao
    )
        public
        somenteLoteValido(idLote)
        returns (bool)
    {
        Lote storage lote = _lotes[idLote];
        uint dataHora = block.timestamp;
        Remessa memory novaRemessa = Remessa(destino, descricao, dataHora, situacao);

        if(situacao == SituacaoRemessa.Iniciada) {
            lote.Situacao = SituacaoLote.Transito;
        } else if(situacao == SituacaoRemessa.Entregue) {
            lote.Situacao = SituacaoLote.Entregue;
        }

        lote.Envio[lote.TotalRemessa] = novaRemessa;
        lote.TotalRemessa++;

        emit RemessaRegistrada(idLote, destino, descricao, dataHora, situacao);
        
        return true;
    }

    function informacaoRemessa() public {
        
    }
}