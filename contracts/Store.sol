// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Store is Ownable {
	using Counters for Counters.Counter;
    Counters.Counter private _orderSeq;
	Counters.Counter private _invoiceSeq;

	struct ItemMenu {
		uint Id;
	}

    struct Order {
		uint Number;
		string ItemMenu;
		uint Price;
		uint Quantity;		
		uint Payment;
		uint OrderDate;
		uint DeliveryDate;
		bool Created;
	}

    struct Invoice {
		uint Number;
		uint OrderNumber;
		bool Created;
	}

	mapping (address => Order[]) _orders;
	mapping (address => Invoice[]) _invoices;
    
	event OrderDispatched(string itemMenu, uint quantity, uint orderDate, uint orderNumber, address customer);
	event PriceSubmitted(uint orderNumber, uint price);     
	event PaymentSent(uint orderNumber, uint value, uint now);
	event InvoiceSent(uint invoiceNumber, uint orderNumber, uint deliveryDate);
	event OrderDelivered(uint invoiceNumber, uint orderNumber, uint actualDeliveryDate);

    constructor() payable {

	}

	//TODO: - Criar modificador para validar a data/hora do pedido

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

    function sendOrder
	(
		string memory itemMenu,
		uint quantity,
		uint dateTime
	)
		payable
		public
		OnlyOrderValidInformation(itemMenu, quantity)
	{
		_orderSeq.increment();
		uint256 newOrderNumber = _orderSeq.current();

		_orders[msg.sender].push(Order({
			Number: newOrderNumber,
			ItemMenu: itemMenu,
			Price: 0,
			Quantity: quantity,
			Payment: 0,
			OrderDate: dateTime,
			DeliveryDate: 0,
			Created: true
		}));

		emit OrderDispatched(itemMenu, quantity, dateTime, newOrderNumber, msg.sender);
	}

    function checkOrder
	(
		uint index
	)
		public
		view
		returns (
			string memory itemMenu,
			uint quantity,
			uint price,
			uint payment,
			uint orderDate,
			uint deliveryDate,
			uint orderId
		)
	{
		Order memory order = _orders[msg.sender][index];
		return(order.ItemMenu, order.Quantity, order.Price, order.Payment, order.OrderDate, order.DeliveryDate, order.Number);
	}


	// function sendPrice
	// (
	// 	// uint orderId,
	// 	// uint price
	// 	uint index,
	// 	uint price
	// )
	// 	public
	// 	onlyOwner
	// 	payable
	// {
	// 	Order memory order = _orders[msg.sender][index];
	// 	Order memory orderUpdated;

	// 	orderUpdated.Number = order.Number;


	// 	delete _orders[msg.sender][index];
	// 	_orders[msg.sender][index] = orderUpdated;


	// 	emit PriceSubmitted(index, price);
	// }

    function total()
        public
        view
        returns (uint)
    {
        return _orders[msg.sender].length;
    }	



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