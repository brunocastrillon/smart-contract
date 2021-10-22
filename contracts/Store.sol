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
		uint OrderIndex;
		uint InvoiceDate;
		bool Created;
	}
	mapping (address => Invoice[]) _invoices;
    
	event OrderDispatched(string itemMenu, uint quantity, uint orderDate, uint orderIndex, address customer);
	event PriceSubmitted(uint orderIndex, uint orderPrice);     
	event PaymentSent(uint orderIndex, uint payment, uint paymentDate);
	event InvoiceSent(uint invoiceIndex, uint orderIndex, uint invoiceDate);
	event OrderDelivered(uint invoiceIndex, uint orderIndex, uint actualDeliveryDate);

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

		uint orderIndex = _orders[msg.sender].length;

		emit OrderDispatched(itemMenu, quantity, dateTime, orderIndex, msg.sender);
	}

    function checkOrder
	(
		uint orderIndex
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
		Order memory order = _orders[msg.sender][orderIndex];
		return(order.ItemMenu, order.Quantity, order.Price, order.Payment, order.OrderDate, order.DeliveryDate);
	}

	function sendPrice
	(
		uint orderIndex,
		uint price,
		address customer
	)
		public
		onlyOwner
		payable
	{
		Order memory orderOld = _orders[customer][orderIndex];
		Order memory orderUpdated;

		orderUpdated.ItemMenu = orderOld.ItemMenu;
		orderUpdated.Price = price;
		orderUpdated.Quantity = orderOld.Quantity;
		orderUpdated.Payment = orderOld.Payment;
		orderUpdated.OrderDate = orderOld.OrderDate;
		orderUpdated.DeliveryDate = orderOld.DeliveryDate;
		orderUpdated.Created = orderOld.Created;

		delete _orders[customer][orderIndex];
		_orders[customer][orderIndex] = orderUpdated;

		emit PriceSubmitted(orderIndex, price);
	}

    function sendPayment
	(
		uint orderIndex,
		uint paymentDate
	)
		public
		payable
	{
		Order memory orderOld = _orders[msg.sender][orderIndex];
		Order memory orderUpdated;

		orderUpdated.ItemMenu = orderOld.ItemMenu;
		orderUpdated.Price = orderOld.Price;
		orderUpdated.Quantity = orderOld.Quantity;
		orderUpdated.Payment = msg.value;
		orderUpdated.OrderDate = orderOld.OrderDate;
		orderUpdated.DeliveryDate = orderOld.DeliveryDate;
		orderUpdated.Created = orderOld.Created;

		delete _orders[msg.sender][orderIndex];
		_orders[msg.sender][orderIndex] = orderUpdated;		

		emit PaymentSent(orderIndex, msg.value, paymentDate);
	}

    function sendInvoice
	(
		uint orderIndex,
		uint invoiceDate,
		address customer
	)
		public
		onlyOwner
	{
		_invoices[customer].push(Invoice({
			OrderIndex: orderIndex,
			InvoiceDate: invoiceDate,
			Created: true
		}));

		uint invoiceIndex = _invoices[customer].length;

		emit InvoiceSent(invoiceIndex, orderIndex, invoiceDate);
	}

	function checkInvoice
	(
		uint invoiceIndex
	)
		public
		view
		returns (
			uint orderIndex,
			uint invoiceDate
		)
	{
		Invoice memory invoice = _invoices[msg.sender][invoiceIndex];
		return(invoice.OrderIndex, invoice.InvoiceDate);
	}

	function deliver
	(
		uint invoiceIndex,
		uint deliveryDate
	)
		public
	{
		Invoice memory invoice = _invoices[msg.sender][invoiceIndex];
		Order memory orderOld = _orders[msg.sender][invoice.OrderIndex];

		Order memory orderUpdated;

		orderUpdated.ItemMenu = orderOld.ItemMenu;
		orderUpdated.Price = orderOld.Price;
		orderUpdated.Quantity = orderOld.Quantity;
		orderUpdated.Payment = orderOld.Payment;
		orderUpdated.OrderDate = orderOld.OrderDate;
		orderUpdated.DeliveryDate = deliveryDate;
		orderUpdated.Created = orderOld.Created;

		delete _orders[msg.sender][invoice.OrderIndex];
		_orders[msg.sender][invoice.OrderIndex] = orderUpdated;

		emit OrderDelivered(invoiceIndex, invoice.OrderIndex, deliveryDate);
	}

    function totalOrder()
        public
        view
        returns (uint)
    {
        return _orders[msg.sender].length;
    }

    function totalInvoice()
        public
        view
        returns (uint)
    {
        return _invoices[msg.sender].length;
    }	
}