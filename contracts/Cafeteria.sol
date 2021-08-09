// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Cafeteria {
    address public _dono;
    address public _cliente;

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
		uint numeroPedio;
		bool Criado;
	}

	mapping (uint => Pedido) _pedidos;
	mapping (uint => Fatura) _faturas;
		
	uint _sequencialPedido;
	uint _sequencialFatura;
    
	event PedidoEnviado(address cliente, string itemMenu, uint quantidade, uint numeroPedido);
	event PrecoEnviado(address Cliente, uint numeroPedido, uint preco);     
	event PagamentoSeguroEnviado(address cliente, uint pedidoNumero, uint valor, uint now);
	event FaturaEnviada(address cliente, uint idFatura, uint numeroPedido, uint dataEntrega);
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
		uint id
	)
		view
		public
		PedidoExiste(id)
		returns (address cliente, string memory itemMenu, uint quantidade, uint preco, uint pagmentoSeguro) {		
		return(
			_cliente,
			_pedidos[id].itemMenu,
			_pedidos[id].Quantity,
			_pedidos[id].Preco,
			_pedidos[id].PagamentoSeguro
			);
	}

	function enviarPreco
	(
		uint numeroPedido,
		uint preco
	)
		payable
		public
	{
		require(msg.sender == _owner);          // only the owner can use this function
		require(_orders[orderNo].Created);     // check the order exists

		_orders[orderNo].Price = price; // set the order price
		
		emit PriceSent(_customer, orderNo, price);  // trigger PriceSent event
	}

    function sendSafePayment(uint orderNo) payable public {
		require(_customer == msg.sender);       // only the customer can use this function
		require(_orders[orderNo].Created);	   // check the order exists

		_orders[orderNo].SafePayment = msg.value;    // payout

		emit SafePaymentSent(msg.sender, orderNo, msg.value, block.timestamp); // trigger SafePaymentSent event
	}

    function sendInvoice(uint orderNo, uint order_date) payable public {
		require(_owner == msg.sender);        // only the owner can use this function
		require(_orders[orderNo].Created);   // check the order exists
		
		_invoiceSeq++; // increase the invoice index
		_invoices[_invoiceSeq] = Invoice(_invoiceSeq, orderNo, true); // create the invoice

		_orders[orderNo].OrderDate = order_date; //  set the order date
		
		emit InvoiceSent(_customer, _invoiceSeq, orderNo, order_date);  // trigger InvoiceSent event
	}

    function getInvoice(uint invoiceID) view public returns (address customer, uint orderNo, uint invoice_date){
		require(invoices[invoiceID].created);// check the invoice exists
	
		Invoice storage _invoice = invoices[invoiceID];// get the related invoice info
		Order storage _order     = orders[_invoice.orderNo];		// get the related order info
		
		return (customerAddress, _order.ID, _order.orderDate);// return the invoice
	}

    function markOrderDelivered(uint invoiceID, uint delivery_date) payable public {
		require(customerAddress == msg.sender); // only the customer can use this function
		require(invoices[invoiceID].created); // check the invoice exists
		
		Invoice storage _invoice = invoices[invoiceID]; // get the related invoice info
		Order storage _order     = orders[_invoice.orderNo];	 // get the related order info
		
		_order.deliveryDate = delivery_date; // set the delivery date
		
		emit OrderDelivered(customerAddress, invoiceID, _order.ID, delivery_date); // trigger OrderDelivered event
		
		owner.transfer(_order.safePayment); // payout
	}    
}