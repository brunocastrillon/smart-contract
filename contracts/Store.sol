// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Store is Ownable {
	using Counters for Counters.Counter;
    Counters.Counter private _orderSeq;
	Counters.Counter private _invoiceSeq;

    address public _owner;

	struct ItemMenu {
		uint Id;
	}

    struct Order {
		uint Id;
		string ItemMenu;
		uint Quantity;		
		uint Price;
		uint Payment;
		uint OrderDate;
		uint DeliveryDate;
		bool Created;
	}

    struct Invoice {
		uint Id;
		uint OrderId;
		bool Created;
	}

	mapping (uint => Order) _orders;
	mapping (uint => Invoice) _invoices;
    
	event OrderDispatched(address customer, string itemMenu, uint quantity, uint orderId);
	event PriceSubmitted(address customer, uint itemMenu, uint price);     
	event PaymentSent(address customer, uint orderId, uint value, uint now);
	event InvoiceSent(address customer, uint invoiceId, uint orderId, uint deliveryDate);
	event OrderDelivered(address customer, uint invoiceId, uint orderId, uint actualDeliveryDate);

    constructor() payable {
		_owner = msg.sender;
	}

    modifier OnlyOrderValidInformation
    (
        string memory itemMenu,
        uint quantity
    )
    {
        bytes memory itemMenuTemp = bytes(itemMenu);

        bool informacaoValida = itemMenuTemp.length == 0 || quantity == 0;
        require(!informacaoValida, 'informacao invalida');
        _;
    }

	modifier OnlyExistingOrder(uint id) {
		require(_orders[id].Created,"pedido nao existe");
		_;
	}

	modifier OnlyExistingInvoice(uint id) {
		require(
			_invoices[id].Created,"fatura nao existe");
		_;
	}	

    function sendOrder
	(
		string memory itemMenu,
		uint quantity
	)
		payable
		public
		OnlyOrderValidInformation(itemMenu, quantity)
	{
		_orderSeq.increment();
		uint256 newOrderId = _orderSeq.current();

		_orders[newOrderId] = Order(newOrderId, itemMenu, quantity, 0, 0, 0, 0, true);
		emit OrderDispatched(msg.sender, itemMenu, quantity, newOrderId);
	}

    // function verificarPedido
	// (
	// 	uint idPedido
	// )
	// 	view
	// 	public
	// 	PedidoExiste(idPedido)
	// 	returns (address cliente, string memory itemMenu, uint quantidade, uint preco, uint pagmentoSeguro) {		
	// 	return(
	// 		_cliente,
	// 		_pedidos[idPedido].ItemMenu,
	// 		_pedidos[idPedido].Quantidade,
	// 		_pedidos[idPedido].Preco,
	// 		_pedidos[idPedido].PagamentoSeguro
	// 		);
	// }

	// function enviarPreco
	// (
	// 	uint idPedido,
	// 	uint preco
	// )
	// 	public
	// 	onlyOwner
	// 	PedidoExiste(idPedido)
	// 	payable
	// {
	// 	_pedidos[idPedido].Preco = preco;
	// 	emit PrecoEnviado(_cliente, idPedido, preco);
	// }

    // function enviarPagamentoSeguro
	// (
	// 	uint idPedido
	// )
	// 	public
	// 	SomenteCliente
	// 	PedidoExiste(idPedido)
	// 	payable
	// {
	// 	_pedidos[idPedido].PagamentoSeguro = msg.value;
	// 	emit PagamentoSeguroEnviado(msg.sender, idPedido, msg.value, block.timestamp);
	// }

    // function enviarFatura
	// (
	// 	uint idPedido,
	// 	uint dataPedido
	// )
	// 	public
	// 	onlyOwner
	// 	PedidoExiste(idPedido)
	// 	payable
	// {
	// 	_sequencialFatura++;
	// 	_faturas[_sequencialFatura] = Fatura(_sequencialFatura, idPedido, true);
	// 	_pedidos[idPedido].DataPedido = dataPedido;
	// 	emit FaturaEnviada(_cliente, _sequencialFatura, idPedido, dataPedido);
	// }

    // function obterFatura
	// (
	// 	uint idFatura
	// )
	// 	public
	// 	view
	// 	FaturaExiste(idFatura)
	// 	returns (address cliente, uint idPedido, uint dataFatura)
	// {
	// 	Fatura storage fatura = _faturas[idFatura];
	// 	Pedido storage pedido = _pedidos[fatura.IdPedido];
	// 	return (_cliente, pedido.Id, pedido.DataPedido);
	// }

    // function MarcarPedidoEntregue
	// (
	// 	uint idFatura,
	// 	uint dataEntrega
	// )
	// 	public
	// 	SomenteCliente
	// 	FaturaExiste(idFatura)
	// 	payable
	// {
	// 	Fatura storage fatura = _faturas[idFatura];
	// 	Pedido storage pedido = _pedidos[fatura.IdPedido];
	// 	pedido.DataEntrega = dataEntrega;
	// 	payable(_dono).transfer(pedido.PagamentoSeguro);
	// 	emit PedidoEntregue(_cliente, idFatura, pedido.Id, dataEntrega); 
	// }    
}