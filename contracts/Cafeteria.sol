// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Cafeteria is Ownable {
    address public _dono;
    address public _cliente;

	struct ItemMenu {
		uint Id;
	}

    struct Pedido {
		uint Id;
		string ItemMenu;
		uint Quantidade;		
		uint Preco;
		uint PagamentoSeguro;
		uint DataPedido;
		uint DataEntrega;
		bool Criado;
	}

    struct Fatura {
		uint Id;
		uint IdPedido;
		bool Criada;
	}

	mapping (uint => Pedido) _pedidos;
	mapping (uint => Fatura) _faturas;
		
	uint _sequencialPedido;
	uint _sequencialFatura;
    
	event PedidoEnviado(address cliente, string itemMenu, uint quantidade, uint numeroPedido);
	event PrecoEnviado(address Cliente, uint idPedido, uint preco);     
	event PagamentoSeguroEnviado(address cliente, uint idPedido, uint valor, uint now);
	event FaturaEnviada(address cliente, uint idFatura, uint idPedido, uint dataEntrega);
	event PedidoEntregue(address cliente, uint idFatura, uint numeroPedido, uint dataEntregueVerdadeira);

    constructor(address comprador) payable {
		_dono = msg.sender;
		_cliente = comprador;
	}

	modifier SomenteCliente() {
		require(
			msg.sender == _cliente,
			"somente o cliente pode executar essa funcao"
			);
		_;
	}

	modifier PedidoExiste(uint id) {
		require(
			_pedidos[id].Criado,
			"pedido nao existe"
			);
		_;
	}

	modifier FaturaExiste(uint id) {
		require(
			_faturas[id].Criada,
			"fatura nao existe"
			);
		_;
	}	

    function enviarPedido
	(
		string memory itemMenu,
		uint quantidade
	)
		payable
		public
		SomenteCliente
	{
		_sequencialPedido++;
		_pedidos[_sequencialPedido] = Pedido(_sequencialPedido, itemMenu, quantidade, 0, 0, 0, 0, true);
		emit PedidoEnviado(msg.sender, itemMenu, quantidade, _sequencialPedido);
	}

    function verificarPedido
	(
		uint idPedido
	)
		view
		public
		PedidoExiste(idPedido)
		returns (address cliente, string memory itemMenu, uint quantidade, uint preco, uint pagmentoSeguro) {		
		return(
			_cliente,
			_pedidos[idPedido].ItemMenu,
			_pedidos[idPedido].Quantidade,
			_pedidos[idPedido].Preco,
			_pedidos[idPedido].PagamentoSeguro
			);
	}

	function enviarPreco
	(
		uint idPedido,
		uint preco
	)
		public
		onlyOwner
		PedidoExiste(idPedido)
		payable
	{
		_pedidos[idPedido].Preco = preco;
		emit PrecoEnviado(_cliente, idPedido, preco);
	}

    function enviarPagamentoSeguro
	(
		uint idPedido
	)
		public
		SomenteCliente
		PedidoExiste(idPedido)
		payable
	{
		_pedidos[idPedido].PagamentoSeguro = msg.value;
		emit PagamentoSeguroEnviado(msg.sender, idPedido, msg.value, block.timestamp);
	}

    function enviarFatura
	(
		uint idPedido,
		uint dataPedido
	)
		public
		onlyOwner
		PedidoExiste(idPedido)
		payable
	{
		_sequencialFatura++;
		_faturas[_sequencialFatura] = Fatura(_sequencialFatura, idPedido, true);
		_pedidos[idPedido].DataPedido = dataPedido;
		emit FaturaEnviada(_cliente, _sequencialFatura, idPedido, dataPedido);
	}

    function obterFatura
	(
		uint idFatura
	)
		public
		view
		FaturaExiste(idFatura)
		returns (address cliente, uint idPedido, uint dataFatura)
	{
		Fatura storage fatura = _faturas[idFatura];
		Pedido storage pedido = _pedidos[fatura.IdPedido];
		return (_cliente, pedido.Id, pedido.DataPedido);
	}

    function MarcarPedidoEntregue
	(
		uint idFatura,
		uint dataEntrega
	)
		public
		SomenteCliente
		FaturaExiste(idFatura)
		payable
	{
		Fatura storage fatura = _faturas[idFatura];
		Pedido storage pedido = _pedidos[fatura.IdPedido];
		pedido.DataEntrega = dataEntrega;
		payable(_dono).transfer(pedido.PagamentoSeguro);
		emit PedidoEntregue(_cliente, idFatura, pedido.Id, dataEntrega); 
	}    
}