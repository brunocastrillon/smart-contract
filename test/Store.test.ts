import assert = require('assert');

import {
    accounts,
    contract
} from '@openzeppelin/test-environment';

const {
    use,
    expect
} = require('chai');

const { solidity } = require('ethereum-waffle');

const truffleAssert = require('truffle-assertions');
const Store = contract.fromArtifact('Store');

use(solidity);

describe('manage-store', () => {
    let _store: {
        sendOrder: (itemMenu: string, quantity: number, dateTime: number, sender: { from: string }) => any;
        checkOrder: (index: number, sender: { from: string }) => any;
        sendPrice: (index: number, price: number, customer: string, sender: { from: string }) => any;
        total: (sender: { from: string }) => any;
        sendPayment: (index: number, paymentDate: number, sender: { from: string, value: number }) => any;
        // enviarFatura: (arg0: string, arg1: string, arg2: { from: string; }) => any;
        // obterFatura:(arg0: number, arg1: { from: string; }) => any;
        // MarcarPedidoEntregue:(arg0: string, arg1: string, arg2: { from: string; }) => any;
    };

    const _itemMenuNULL = "";
    const _quantityZERO = 0;

    const _owner = accounts[0];
    const _customer = accounts[1];
    const _orderIndex = 0;
    const _invoiceIndex = 0;
    const _itemMenu = "express-mj";
    const _price = 6;
    const _quantity = 3;
    const _payment = 18; //_price * _quantity;
    const _paymentDate = (new Date()).getTime();
    const _orderDate = (new Date()).getTime();
    const _deliveryDate = (new Date()).getTime() + 30000;

    beforeEach(async function () {
        _store = await Store.new({ from: _owner });
    });

    describe('Testando a função sendOrder()', () => {
        it('Usuário não enviou todas as informações: Transação Revertida', async () => {
            await expect(
                _store.sendOrder(_itemMenuNULL, _quantityZERO, 0, { from: _customer })
            ).to.be.revertedWith("informacao invalida");
        });

        it('Ao enviar um novo pedido com sucesso, deve retornar um evento: OrderDispatched()', async () => {
            const store = await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });

            truffleAssert.eventEmitted(store, 'OrderDispatched', (ev: { itemMenu: string; quantity: number; orderDate: number, orderNumber: number, customer: string }) => {
                return ev.itemMenu === _itemMenu && ev.quantity == _quantity && ev.orderDate == _orderDate && ev.orderNumber == _orderIndex + 1 && ev.customer == _customer;
            });
        });
    });

    describe('Testando a função checkOrder()', () => {
        it('Deverá retornar informações do pedido', async () => {
            await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });
            const pedido = await _store.checkOrder(_orderIndex, { from: _customer });
            assert.equal(_itemMenu, pedido.itemMenu);
            assert.equal(_quantity, pedido.quantity);
            assert.equal(0, pedido.price);
            assert.equal(0, pedido.payment);
            assert.equal(_orderDate, pedido.orderDate);
        });
    });

    describe('Testando a função sendPrice()', () => {
        it('Usuário que não é dono do contrato, tentou enviar o preço, deverá retornar - Ownable: caller is not the owner', async () => {
            await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });
            await expect(
                _store.sendPrice(_orderIndex, _price, _customer, { from: _customer })
            ).to.be.revertedWith("Ownable: caller is not the owner");
        });

        it('Ao enviar o preço com sucesso, deverá retornar um evento: PriceSubmitted()', async () => {
            await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });
            const store = await _store.sendPrice(_orderIndex, _price, _customer, { from: _owner });

            truffleAssert.eventEmitted(store, 'PriceSubmitted', (ev: { orderNumber: number, orderPrice: number }) => {
                return ev.orderNumber == _orderIndex && ev.orderPrice == _price;
            });
        });
    });

    describe('Testando a função sendPayment', () => {
        it('Ao realizar um pagamento com suceso, deverá retornar um event: PaymentSent()', async () => {
            await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });
            await _store.sendPrice(_orderIndex, _price, _customer, { from: _owner });
            const store = await _store.sendPayment(_orderIndex, _paymentDate, { from: _customer, value: _payment });

            truffleAssert.eventEmitted(store, 'PaymentSent', (ev: { orderNumber: number, payment: number, paymentDate: number }) => {
                return ev.orderNumber == _orderIndex && ev.payment == _payment && ev.paymentDate == _paymentDate;
            });            
        });
    });

    it("Deverá retornar o total de pedidos", async () => {
        await _store.sendOrder(_itemMenu, _quantity, _orderDate, { from: _customer });
        let pedidos = await _store.total({ from: _customer });

        assert.equal(pedidos, 1);
    });
});