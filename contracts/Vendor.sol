// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Gold.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vendor is Ownable {
    Gold _gold;
    uint256 public _paridade = 100; //100 gold = 1 eth

    event ComprarToken(address comprador, uint256 quantidadeETH, uint256 quantidadeGLD);
    event VenderToken(address vendedor, uint256 quantidadeGLD, uint256 quantidadeETH);

    constructor(address enderecoToken) {
        _gold = Gold(enderecoToken);
    }

    function comprar() public payable returns (uint256) {
        require(msg.value > 0, "quantidade de ETH insuficiente");

        uint256 quantidadeParaComprar = msg.value * _paridade;
        uint256 saldoVendor = _gold.balanceOf(address(this));

        require(saldoVendor >= quantidadeParaComprar, "saldo do distribuidor insuficiente");

        (bool sent) = _gold.transfer(msg.sender, quantidadeParaComprar);
        require(sent, "falha ao transferir tokens");

         emit ComprarToken(msg.sender, msg.value, quantidadeParaComprar);

         return quantidadeParaComprar;
    }

    function vender(uint256 quantidade) public {
        require(quantidade > 0, "quantidade insuficiente");

        uint256 saldoUsuario = _gold.balanceOf(msg.sender);
        require(saldoUsuario >= quantidade,"saldo inferior a quantidade de tokens que desaja vender");

        uint256 amountOfETHToTransfer = quantidade / _paridade;
        uint256 ownerETHBalance = address(this).balance;
        require(ownerETHBalance >= amountOfETHToTransfer, "Vendor has not enough funds to accept the sell request");

        (bool sent) = _gold.transferFrom(msg.sender, address(this), quantidade);
        require(sent, "Failed to transfer tokens from user to vendor");

        (sent,) = msg.sender.call{value: amountOfETHToTransfer}("");
        require(sent, "Failed to send ETH to the user");        
    }

    function sacar() public onlyOwner {
        uint256 saldoDono = address(this).balance;
        require(saldoDono > 0, "sem saldo para saque");

        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        require(sent, "falha ao enviar saldo do usuario de volta ao proprietario");
    }    
}