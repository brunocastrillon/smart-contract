// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Cassino is Ownable {
    address private _owner;
    uint256 private _coeficiente;

    event Apostar(address payable indexed jogador, uint256 tamanhoAposta, uint8 numeroAposta, uint8 numeroVencedor);
    event Pagar(address payable vencedor, uint256 valor);
 
    constructor() payable {
        _owner = msg.sender;
        _coeficiente = msg.value;
    }

    modifier ApostaValida(uint256 tamanhoAposta){
        require(tamanhoAposta > 0, 'aposta invalida');
        _;
    }    

    modifier LimiteAposta(uint256 tamanhoAposta){
        uint256 limite = address(this).balance / 100;
        require(tamanhoAposta <= limite, 'o valor da aposta nao pode exceder o tamanho maximo da aposta');
        _;
    }

    function fechar
    (
        address payable owner
    )
        external
        payable
        onlyOwner
    {
        selfdestruct(owner);
    }

    function reserva() external payable {}

    function apostar
    (
        uint8 numero,
        address payable jogador,
        uint256 tamanhoAposta
    )
        external
        ApostaValida(tamanhoAposta)
        LimiteAposta(tamanhoAposta)
        payable
    {
        uint8 numeroVencedor = gerarNumeroVencedor();
        emit Apostar(jogador, tamanhoAposta, numero, numeroVencedor);

        if (numero == numeroVencedor) {
            pagar(jogador, tamanhoAposta * _coeficiente);
        }
    }

    function pagar
    (
        address payable vencedor,
        uint256 premio
    )
        internal
    {
        assert(premio > 0);
        assert(premio <= address(this).balance);

        vencedor.transfer(premio);
        emit Pagar(vencedor, premio);            
    }

    function gerarNumeroVencedor() public view returns (uint8) {
        return uint8(block.number % 10 + 1); //TODO: NÃO FAZER ISSO EM PRODUÇÃO!!!
    }
}