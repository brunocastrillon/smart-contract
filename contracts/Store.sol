// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Store is Ownable {
	address private _owner;

    struct Order {
		string ItemMenu;
		uint Price;
		uint Quantity;		
		uint Payment;
		uint OrderDate;
		uint DeliveryDate;
		bool Created;
	}
	mapping (address => Order[]) _orders;

    struct Invoice {
		uint OrderNumber;
		bool Created;
	}
	mapping (address => Invoice[]) _invoices;
    
	event OrderDispatched(string itemMenu, uint quantity, uint orderDate, uint orderNumber, address customer);
	event PriceSubmitted(uint orderNumber, uint orderPrice);     
	event PaymentSent(uint orderNumber, uint payment, uint paymentDate);
	event InvoiceSent(uint invoiceNumber, uint orderNumber, uint deliveryDate);
	event OrderDelivered(uint invoiceNumber, uint orderNumber, uint actualDeliveryDate);

    constructor() payable {
		_owner = msg.sender;
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
		_orders[msg.sender].push(Order({
			ItemMenu: itemMenu,
			Price: 0,
			Quantity: quantity,
			Payment: 0,
			OrderDate: dateTime,
			DeliveryDate: 0,
			Created: true
		}));

		uint indexOrder = _orders[msg.sender].length;

		emit OrderDispatched(itemMenu, quantity, dateTime, indexOrder, msg.sender);
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
			uint deliveryDate
		)
	{
		Order memory order = _orders[msg.sender][index];
		return(order.ItemMenu, order.Quantity, order.Price, order.Payment, order.OrderDate, order.DeliveryDate);
	}


	function sendPrice
	(
		uint index,
		uint price,
		address customer
	)
		public
		onlyOwner
		payable
	{
		Order memory orderOld = _orders[customer][index];
		Order memory orderUpdated;

		orderUpdated.ItemMenu = orderOld.ItemMenu;
		orderUpdated.Price = price;
		orderUpdated.Quantity = orderOld.Quantity;
		orderUpdated.Payment = orderOld.Payment;
		orderUpdated.OrderDate = orderOld.OrderDate;
		orderUpdated.DeliveryDate = orderOld.DeliveryDate;
		orderUpdated.Created = orderOld.Created;

		delete _orders[customer][index];
		_orders[customer][index] = orderUpdated;

		emit PriceSubmitted(index, price);
	}

    function sendPayment
	(
		uint index,
		uint paymentDate
	)
		public
		payable
	{
		Order memory orderOld = _orders[msg.sender][index];
		Order memory orderUpdated;

		orderUpdated.ItemMenu = orderOld.ItemMenu;
		orderUpdated.Price = orderOld.Price;
		orderUpdated.Quantity = orderOld.Quantity;
		orderUpdated.Payment = msg.value;
		orderUpdated.OrderDate = orderOld.OrderDate;
		orderUpdated.DeliveryDate = orderOld.DeliveryDate;
		orderUpdated.Created = orderOld.Created;

		delete _orders[msg.sender][index];
		_orders[msg.sender][index] = orderUpdated;		

		emit PaymentSent(index, msg.value, paymentDate);
	}

    function total()
        public
        view
        returns (uint)
    {
        return _orders[msg.sender].length;
    }	

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